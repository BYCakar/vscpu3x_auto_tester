# Shared FPGA, SRAM and testbench compilation for RTL and gate-level runs.
foreach {option default} {GUI 1 COVER 1 ENV_VLOG_DEFINES {} ENV_SIM_PLUSARGS {}} {
    if {![info exists ::$option]} {
        set ::$option $default
    }
}

if {!$::GUI} {
    onerror {quit -force -code 1}
    onbreak {
        if {[examine -radix binary /vscpu3x_test_tb/sim_test_passed] eq "1"} {
            quit -force -code 0
        }
        quit -force -code 1
    }
}

vlib work
vmap work

set VSCPU3X_HOME ../../caravel_vscpu3x/verilog/rtl
set VSCPU3X_GL_HOME ../../caravel_vscpu3x/verilog/gl
set PDK_HOME ../../caravel_vscpu3x/pdk/sky130A/libs.ref/sky130_fd_sc_hd/verilog
set FPGA_HOME ../../design/src
set TB_HOME ../tb

set VLOG_OPTIONS [list +acc +incdir+$VSCPU3X_HOME +incdir+$FPGA_HOME \
    +define+MPRJ_IO_PADS=38 +define+VSCPU_MEM_FILL_1S]
lappend VLOG_OPTIONS {*}$::ENV_VLOG_DEFINES
set VSIM_OPTIONS [list -sv_lib $TB_HOME/dpi_uart/dpi_uart]
if {$::COVER} {
    lappend VLOG_OPTIONS -cover bcesft
    lappend VSIM_OPTIONS -coverage
}

if {$SIM_MODE eq "gl"} {
    # The supplied netlists have explicit supply ports. FUNCTIONAL selects
    # functional cell models; no SDF timing annotation is applied.
    lappend VLOG_OPTIONS +define+USE_POWER_PINS +define+FUNCTIONAL +define+UNIT_DELAY=#1
    # These PDK models omit explicit wire types on some ports despite
    # default_nettype none; allow those declarations only in the cell library.
    vlog -suppress 2892 {*}$VLOG_OPTIONS $PDK_HOME/primitives.v
    vlog -suppress 2892 {*}$VLOG_OPTIONS $PDK_HOME/sky130_fd_sc_hd.v
}

foreach design_file {
    Modbus_Regspace.v
    modbus_uart_tx.v
    modbus_uart_rx.v
    Modbus_UART_Controller.v
    fifo.v
    Modbus_CRC16.v
    Modbus_Top.v
    cmd_uart.v
    cmd_uart_controller.sv
    test_rom.v
    test_driver.v
    test_controller.v
    vscpu3x_pinmux.v
    vscpu3x_auto_tester_top.v
    vscpu3x_test_top.v
} {
    if {[file extension $design_file] eq ".sv"} {
        vlog -sv {*}$VLOG_OPTIONS $FPGA_HOME/$design_file
    } else {
        vlog {*}$VLOG_OPTIONS $FPGA_HOME/$design_file
    }
}

if {$SIM_MODE eq "gl"} {
    foreach design_file {
        VerySimpleCPU_core.v
        main_controller.v
        main_memory.v
        uart.v
        user_project_wrapper.v
    } {
        vlog {*}$VLOG_OPTIONS $VSCPU3X_GL_HOME/$design_file
    }
} else {
    foreach design_file {
        user_project_wrapper.v
        parameters.v
        agent_memory_controller.v
        codemaker_memory_controller.v
        command_processor_memory_controller.v
        control_tower_memory_controller.v
        list_ch04_11_mod_m_counter.v
        list_ch04_20_fifo.v
        list_ch08_01_uart_rx.v
        list_ch08_03_uart_tx.v
        list_ch08_04_uart.v
        main_controller.v
        main_memory.v
        multicore_mem_controller.v
        Priority_Arbiter.v
        reset_circuit.v
        Round_Robin_Arbiter.v
        Thermometer_Mask.v
        uart_cp.v
        uart_p.v
        VerySimpleCPU_core.v
        VerySimpleCPU.v
    } {
        vlog {*}$VLOG_OPTIONS $VSCPU3X_HOME/$design_file
    }
}

# Both filelists use the RTL SRAM simulation model and the same testbench.
vlog {*}$VLOG_OPTIONS $VSCPU3X_HOME/sky130_sram_2kbyte_1rw1r_32x512_8.v
vlog -sv {*}$VLOG_OPTIONS $TB_HOME/dpi_uart/dpi_uart.sv
vlog -sv {*}$VLOG_OPTIONS $TB_HOME/vscpu3x_test_tb.v

# Questa's -onfinish exit also returns zero for $fatal. Stop first so the
# batch onbreak handler can return the testbench's actual completion result.
lappend VSIM_OPTIONS -onfinish stop
vsim {*}$VSIM_OPTIONS work.vscpu3x_test_tb {*}$::ENV_SIM_PLUSARGS

if {$::COVER} {
    coverage save -onexit sim_${SIM_MODE}.ucdb
}

if {$::GUI} {
    do wave.do
} else {
    run -all
    # The onbreak handler exits on completion; any other end is incomplete.
    quit -force -code 1
}
