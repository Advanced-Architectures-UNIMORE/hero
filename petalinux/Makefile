# =====================================================================
# Project:      HERO
# Title:        Makefile
# Description:  Define operations compliant with compilation of Petalinux 
#				image for HERO.
#
# $Date:        9.03.2022
# =====================================================================
#
# Copyright (C) 2022 University of Modena and Reggio Emilia.
#
# Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

PETALINUX_ROOT 		:= $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# user parameters
TARGET_BOARD 		:= zcu102
TARGET_NAME			:= OV_CFG_DEV
TARGET_BITSTREAM 	:= BR2_HERO_BITSTREAM

# project
BUILD_DIR		:= ${PETALINUX_ROOT}

# directories
SCRIPTS_DIR		:= $(PETALINUX_ROOT)/scripts
OUT_DIR			:= $(PETALINUX_ROOT)/output

.PHONY: clean

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #

# ------- #
#  BOARD  #
# ------- #

# Procedure to offline/online update of board projects:
#
# 1) update_bitstream (offline) ~ retrieve new bitstream and re-compile project outputs.
#
# 2) update_output (offline) ~ collect project binaries, divided per project.
#
# 3) update_boardenv (online) ~ copy new images to board.
#
# 4) reboot_zcu102 (online) ~ reboot board.

reboot_zcu102:
	@$(SCRIPTS_DIR)/reboot_zcu102.sh

update_boardenv:
	@$(SCRIPTS_DIR)/update_boardenv.sh \
		$(TARGET_BOARD) $(TARGET_NAME) ${OUT_DIR}

update_output: clean_output
	@$(SCRIPTS_DIR)/$@.sh \
		$(TARGET_BOARD) $(TARGET_NAME) ${BUILD_DIR} ${OUT_DIR}

update_bitstream:
	@$(SCRIPTS_DIR)/$@.sh \
		$(TARGET_BOARD) $(TARGET_NAME) $(TARGET_BITSTREAM) ${PETALINUX_ROOT} ${BUILD_DIR}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #

# ------------------------- #
#  BUILD LINUX ENVIRONMENT  #
# ------------------------- #

build_petalinux:
	@$(SCRIPTS_DIR)/$(TARGET_BOARD).sh \
		$(TARGET_BOARD) $(TARGET_NAME) $(TARGET_BITSTREAM) ${PETALINUX_ROOT} ${BUILD_DIR}

build_petalinux_empty:
	@$(SCRIPTS_DIR)/$(TARGET_BOARD)_empty.sh \
		$(TARGET_BOARD) $(TARGET_NAME) $(TARGET_BITSTREAM) ${PETALINUX_ROOT} ${BUILD_DIR}

clean_output:
	@rm -rf $(OUT_DIR)/*

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #
