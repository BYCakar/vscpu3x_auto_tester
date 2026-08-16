TESTNAME ?=

ENV_VLOG_DEFINES :=
ENV_SIM_PLUSARGS :=
ifneq ($(TESTNAME),)
	ENV_VLOG_DEFINES += +define+VSCPU_MEM_INIT
	ENV_SIM_PLUSARGS += +VSCPU_MEM_INIT_FILE_PREFIX=$(PWD)/verification/vscpu3x_apps/$(TESTNAME)/$(TESTNAME)
endif

VSIM_DO = set ::ENV_VLOG_DEFINES {$(ENV_VLOG_DEFINES)};
VSIM_DO += set ::ENV_SIM_PLUSARGS {$(ENV_SIM_PLUSARGS)};
VSIM_DO += do compile_design.tcl


sim_rtl:
	cd verification/sim && vsim -do "$(VSIM_DO)"

clean:
	rm -rf verification/sim/work
	rm verification/sim/transcript verification/sim/vsim.wlf