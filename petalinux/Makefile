# Author: Gianluca Bellocchi <gianluca.bellocchi@unimore.it>

ROOT 			:= $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# user parameters
TARGET_BOARD 	:= zcu102
TARGET_HW 		:= BR2_HERO_BITSTREAM

# directories
SCRIPTS_DIR		:= $(ROOT)/scripts

.PHONY: clean

update_output:
	@rm -rf $(ROOT)/output/*
	@cp -r $(ROOT)/$(TARGET_BOARD)/images/linux/* $(ROOT)/output

build_petalinux:
	@$(SCRIPTS_DIR)/$(TARGET_BOARD).sh \
		$(TARGET_BOARD) $(TARGET_HW) $(ROOT) # input parameters

clean:
	@rm -rf $(TARGET_BOARD)
