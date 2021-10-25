########################################################
## Gianluca Bellocchi <gianluca.bellocchi@unimore.it> ##
########################################################

ROOT 			:= $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# user parameters
TARGET_BOARD 	:= zcu102
TARGET_HW 		:= BR2_HERO_BITSTREAM

# directories
SCRIPTS_DIR		:= $(ROOT)/scripts
OUT_DIR			:= $(ROOT)/output

.PHONY: clean

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #

# ------- #
#  BOARD  #
# ------- #

reboot_zcu102:
	@$(SCRIPTS_DIR)/reboot_zcu102.sh

update_boardenv:
	@$(SCRIPTS_DIR)/update_boardenv.sh \
		$(TARGET_BOARD) $(TARGET_HW) $(ROOT) # input parameters

update_bitstream:
	@$(SCRIPTS_DIR)/update_bitstream.sh \
		$(TARGET_BOARD) $(TARGET_HW) $(ROOT) # input parameters

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #

# ------------------------- #
#  BUILD LINUX ENVIRONMENT  #
# ------------------------- #

update_output: clean_output
	@mkdir $(OUT_DIR)/$(TARGET_BOARD)
	@cp $(TARGET_BOARD)/config.project $(OUT_DIR)/$(TARGET_BOARD)/
	@cp -r $(TARGET_BOARD)/.petalinux/ $(OUT_DIR)/$(TARGET_BOARD)/
	@cp -r $(ROOT)/$(TARGET_BOARD)/images $(OUT_DIR)/$(TARGET_BOARD)

build_petalinux: clean_petalinux
	@$(SCRIPTS_DIR)/$(TARGET_BOARD).sh \
		$(TARGET_BOARD) $(TARGET_HW) $(ROOT) # input parameters

clean_petalinux:
	@rm -rf $(TARGET_BOARD)

clean_output:
	@rm -rf $(OUT_DIR)/*

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #