# =====================================================================
# Project:      HERO
# Title:        post_image
# Description:  Script invoked during the build of the Linux environment
#               (kernel and the base root filesystem). The recipe for the
#               Xilinx ZCU102 is "make br-har-exilzcu102". This script
#               invokes Petalinux to build the Petalinux components for HERO.
#
# $Date:        22.03.2022
# =====================================================================
#
# Authors:
# - Andreas Kurth, ETHZ <akurth@iis.ee.ethz.ch>.
# - Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

#!/usr/bin/env bash

# set system from hero device tree
#ln -sf hero.dtb ${BINARIES_DIR}/system.dtb

# TODO: add case to just update Linux binaries with new bistream once the Petalinux prj already exists

# Move to petalinux directory
cd ${BR2_EXTERNAL_HERO_PATH}/petalinux/

# Build the petalinux zcu102 config
# Note: The invoked Mk recipes feed the scripts
# with different variables that can be modified
# by the user in case a different bitstream, project
# directory, etc. has to be used.
make build_petalinux

# Update local outputs to be copied in buildroot
make update_output

# Copy compiled components to buildroot
cp ${BR2_EXTERNAL_HERO_PATH}/petalinux/output/zcu102/images/linux/{bl31.bin,bl31.elf,image.ub,Image,pmufw.elf,regs.init,system.dtb,System.map.linux,u-boot.bin,zynqmp_fsbl.elf} $1
cp ${BR2_EXTERNAL_HERO_PATH}/petalinux/output/zcu102/images/linux/BOOT.BIN $1/boot.bin
cd -

support/scripts/genimage.sh -c ${BR2_EXTERNAL_HERO_PATH}/board/xilzcu102/genimage.cfg
