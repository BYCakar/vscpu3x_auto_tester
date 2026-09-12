TESTNAME ?=
GUI ?= 0
COVER ?= 0
VIVADO ?= vivado
FPGA_JOBS ?= 4

FPGA_DIR := $(CURDIR)/fpga

ENV_VLOG_DEFINES :=
ENV_SIM_PLUSARGS :=
ifneq ($(TESTNAME),)
	ENV_VLOG_DEFINES += +define+VSCPU_MEM_INIT
	ENV_SIM_PLUSARGS += +VSCPU_MEM_INIT_FILE_PREFIX=$(PWD)/verification/vscpu3x_apps/$(TESTNAME)/$(TESTNAME)
endif

VSIM_DO = set ::ENV_VLOG_DEFINES {$(ENV_VLOG_DEFINES)};
VSIM_DO += set ::ENV_SIM_PLUSARGS {$(ENV_SIM_PLUSARGS)};
VSIM_DO += set ::GUI {$(GUI)};
VSIM_DO += set ::COVER {$(COVER)};
VSIM_MODE = $(if $(filter 0,$(GUI)),-c,-gui)

.PHONY: sim_rtl sim_gl clean fpga_build fpga_clean

sim_rtl:
	cd verification/sim && vsim $(VSIM_MODE) -do "$(VSIM_DO) do compile_design.tcl"

sim_gl:
	cd verification/sim && vsim $(VSIM_MODE) -do "$(VSIM_DO) do compile_design_gl.tcl"

fpga_build:
	cd "$(FPGA_DIR)" && $(VIVADO) -mode batch -source scripts/build.tcl -tclargs $(FPGA_JOBS)

fpga_clean:
	$(RM) -r "$(FPGA_DIR)/build" "$(FPGA_DIR)/.Xil"
	$(RM) "$(FPGA_DIR)"/vivado*.jou "$(FPGA_DIR)"/vivado*.log "$(FPGA_DIR)"/vivado*.str

clean:
	rm -rf verification/sim/work
	rm verification/sim/transcript verification/sim/vsim.wlf
