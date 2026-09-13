TESTNAME ?=
SIM ?= questa
GUI ?= 0
COVER ?= 0
TRACE ?= 0
SIM_PLUSARGS ?=
VERILATOR ?= verilator
VERILATOR_JOBS ?= 4
VERILATOR_FLAGS ?=
VIVADO ?= vivado
FPGA_JOBS ?= 4
PYTHON ?= python3
VENV_DIR ?= $(CURDIR)/.venv

FPGA_DIR := $(CURDIR)/fpga
CARAVEL_DIR := $(CURDIR)/caravel_vscpu3x

ENV_VLOG_DEFINES :=
ENV_SIM_PLUSARGS := $(SIM_PLUSARGS)
ifneq ($(TESTNAME),)
	ENV_VLOG_DEFINES += +define+VSCPU_MEM_INIT
	ENV_SIM_PLUSARGS += +VSCPU_MEM_INIT_FILE_PREFIX=$(CURDIR)/verification/vscpu3x_apps/$(TESTNAME)/$(TESTNAME)
endif

VSIM_DO = set ::ENV_VLOG_DEFINES {$(ENV_VLOG_DEFINES)};
VSIM_DO += set ::ENV_SIM_PLUSARGS {$(ENV_SIM_PLUSARGS)};
VSIM_DO += set ::GUI {$(GUI)};
VSIM_DO += set ::COVER {$(COVER)};
VSIM_MODE = $(if $(filter 0,$(GUI)),-c,-gui)

.PHONY: sim_rtl sim_gl verilator_rtl_build verilator_gl_build gl_setup clean fpga_build fpga_clean

ifeq ($(SIM),questa)
sim_rtl:
	cd verification/sim && vsim $(VSIM_MODE) -do "$(VSIM_DO) do compile_design.tcl"

sim_gl:
	cd verification/sim && vsim $(VSIM_MODE) -do "$(VSIM_DO) do compile_design_gl.tcl"
else ifeq ($(SIM),verilator)
sim_rtl sim_gl:
	$(PYTHON) verification/sim/verilator_sim.py --mode $(patsubst sim_%,%,$@)
else
sim_rtl sim_gl:
	@echo "Unsupported SIM=$(SIM); choose questa or verilator" >&2
	@exit 2
endif

# Export options without routing their contents through shell command parsing.
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export VERILATOR := $(VERILATOR)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export VERILATOR_JOBS := $(VERILATOR_JOBS)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export VERILATOR_FLAGS := $(VERILATOR_FLAGS)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export GUI := $(GUI)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export COVER := $(COVER)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export TRACE := $(TRACE)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export TESTNAME := $(TESTNAME)
sim_rtl sim_gl verilator_rtl_build verilator_gl_build: export SIM_PLUSARGS := $(SIM_PLUSARGS)

verilator_rtl_build verilator_gl_build:
	$(PYTHON) verification/sim/verilator_sim.py --mode $(patsubst verilator_%_build,%,$@) --build-only

gl_setup:
	git submodule update --init -- caravel_vscpu3x
	$(PYTHON) -m venv "$(VENV_DIR)"
	. "$(VENV_DIR)/bin/activate" && \
		cd "$(CARAVEL_DIR)" && \
		export CARAVEL_ROOT="$$PWD/caravel" PDK_ROOT="$$PWD/pdk" && \
		if [ ! -d "$$CARAVEL_ROOT" ]; then $(MAKE) install; fi && \
		$(MAKE) pdk-with-volare

fpga_build:
	cd "$(FPGA_DIR)" && $(VIVADO) -mode batch -source scripts/build.tcl -tclargs $(FPGA_JOBS)

fpga_clean:
	$(RM) -r "$(FPGA_DIR)/build" "$(FPGA_DIR)/.Xil"
	$(RM) "$(FPGA_DIR)"/vivado*.jou "$(FPGA_DIR)"/vivado*.log "$(FPGA_DIR)"/vivado*.str

clean:
	$(RM) -r verification/sim/work verification/sim/verilator
	$(RM) verification/sim/transcript verification/sim/vsim.wlf
