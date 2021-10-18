# Author: Gianluca Bellocchi

ROOT := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

TEST_FOLDER 	:= $(ROOT)/../test
SLM_FILES 		:= $(TEST_FOLDER)/slm_files

HWACC := mmul_parallel

APP_NAME := hwpe-tests/hwpe-fir
OPEN_MP_APP := tests-pulp/api

# Modelsim
VSIM_GUI := false

# Test
HWPE_REPO := hwpe-generated-ex/sw
SINGLE_HWACC := ${HWPE_REPO}
MULTI_HWACC := ${HWPE_REPO}/multi-ip-test 

all: clean compile gen_slm sim

sim: 
	@echo 'Start simulation.'
	@./start_sim.sh ${VSIM_GUI}

gen_slm_openmp:
	@echo 'Getting pre-compiled SW stimuli.'
	@rm -f $(SLM_FILES)/*
	@$(TEST_FOLDER)/gen_slm_files.sh $(SLM_FILES) $(OPEN_MP_APP) true

gen_slm_accelerator_rich:
	@echo 'Getting pre-compiled SW stimuli.'
	@rm -f $(SLM_FILES)/*
	@$(TEST_FOLDER)/gen_slm_files.sh $(SLM_FILES) $(MULTI_HWACC) false
	
gen_slm_hwpe:
	@echo 'Getting pre-compiled SW stimuli.'
	@rm -f $(SLM_FILES)/*
	@$(TEST_FOLDER)/gen_slm_files.sh $(SLM_FILES) $(SINGLE_HWACC) false

compile:
	@echo 'Compiling hardware.'
	@./compile.sh

clean_lib: clean
	@rm -rf work

.PHONY: clean
clean:
	@rm -f $(SLM_FILES)/*
	@rm -f transcript vivado* *.log *.bak
	@rm -f compile.tcl
	@rm -f modelsim.ini
	@rm -rf work

