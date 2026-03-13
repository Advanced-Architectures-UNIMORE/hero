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

TARGET_BOARD 		:= zcu102
TARGET_VER 			:= 2019_2
TARGET_NAME			:= OV_CFG_DEV
TARGET_BITSTREAM 	:= BR2_HERO_BITSTREAM
TARGET_XSA 			:= BR2_HERO_XSA

BUILD_DIR			:= ${PETALINUX_ROOT}

SCRIPTS_DIR			:= $(PETALINUX_ROOT)/scripts
OUT_DIR				:= $(PETALINUX_ROOT)/output

.PHONY: clean

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ #

# ------- #
#  BOARD  #
# ------- #

# 1) update_bitstream (off-board) ~ retrieve new bitstream and re-compile project outputs.
#
# 2) update_output (off-board) ~ collect project binaries, divided per project.
#
# 3) update_boardenv (on-board) ~ copy new images to board.
#
# 4) reboot_zcu102 (on-board) ~ reboot board.

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
