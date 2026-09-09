set script_dir [file dirname [file normalize [info script]]]
set fpga_dir [file dirname $script_dir]
set project_root [file dirname $fpga_dir]
set rtl_dir [file join $project_root design src]
set constr_dir [file join $fpga_dir constr]
set build_dir [file join $fpga_dir build]

set project_name vscpu3x_auto_tester
set top_name fpga_wrapper
set part_name xc7k325tffg900-2

set jobs 4
if {$argc > 0} {
    set jobs [lindex $argv 0]
}
if {![string is integer -strict $jobs] || $jobs < 1} {
    error "FPGA_JOBS must be a positive integer (got '$jobs')"
}

set rtl_files [list \
    [file join $rtl_dir Modbus_Regspace.v] \
    [file join $rtl_dir modbus_uart_tx.v] \
    [file join $rtl_dir modbus_uart_rx.v] \
    [file join $rtl_dir Modbus_UART_Controller.v] \
    [file join $rtl_dir fifo.v] \
    [file join $rtl_dir Modbus_CRC16.v] \
    [file join $rtl_dir Modbus_Top.v] \
    [file join $rtl_dir cmd_uart.v] \
    [file join $rtl_dir cmd_uart_controller.sv] \
    [file join $rtl_dir test_rom.v] \
    [file join $rtl_dir test_driver.v] \
    [file join $rtl_dir test_controller.v] \
    [file join $rtl_dir vscpu3x_pinmux.v] \
    [file join $rtl_dir vscpu3x_auto_tester_top.v] \
    [file join $rtl_dir fpga_wrapper.v] \
]

set constraint_files [list \
    [file join $constr_dir Genesys-2-Master.xdc] \
    [file join $constr_dir timing.xdc] \
]

foreach required_file [concat $rtl_files $constraint_files] {
    if {![file isfile $required_file]} {
        error "Required FPGA input does not exist: $required_file"
    }
}

proc require_run_success {run_name} {
    wait_on_run $run_name
    set run [get_runs $run_name]
    set status [get_property STATUS $run]
    set progress [get_property PROGRESS $run]
    if {$progress ne "100%" || ![string match "*Complete!*" $status]} {
        error "Vivado run '$run_name' failed: status='$status', progress='$progress'"
    }
}

file mkdir $build_dir
create_project -force $project_name $build_dir -part $part_name
set_property target_language Verilog [current_project]
set_property default_lib xil_defaultlib [current_project]

add_files -fileset sources_1 -norecurse $rtl_files
set_property include_dirs [list $rtl_dir] [get_filesets sources_1]
set_property top $top_name [get_filesets sources_1]

add_files -fileset constrs_1 -norecurse $constraint_files
update_compile_order -fileset sources_1

# Uncomment the 2 lines below if you want to start vivado GUI instead
# start_gui
# return

puts "INFO: Synthesizing $top_name for Genesys 2 ($part_name) with $jobs jobs"
launch_runs synth_1 -jobs $jobs
require_run_success synth_1

puts "INFO: Implementing design and generating bitstream"
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
require_run_success impl_1

set generated_bit [file join $build_dir ${project_name}.runs impl_1 ${top_name}.bit]
if {![file isfile $generated_bit]} {
    error "Vivado completed without producing the expected bitstream: $generated_bit"
}

set output_bit [file join $build_dir ${top_name}.bit]
file copy -force $generated_bit $output_bit
puts "INFO: Bitstream ready: $output_bit"
