# =====================================================================
# Project:      HERO
# Title:        update_bitstream
# Description:  Retrieve new bitstream and re-compile project outputs.
#
# $Date:        9.03.2022
# =====================================================================
#
# Copyright (C) 2022 University of Modena and Reggio Emilia.
#
# Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

#!/usr/bin/env bash

# Read input arguments.
# - targets
readonly TARGET_BOARD="$1"
readonly TARGET_NAME="$2"
readonly TARGET_BITSTREAM="$3"
# - environment
readonly SCRIPT_DIR="$4"
readonly BUILD_DIR="$5"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target board: $TARGET_NAME"
echo -e ">> Target bitstream: $TARGET_BITSTREAM"
echo -e ">> Script root: $SCRIPT_DIR"
echo -e ">> Project location: $BUILD_DIR"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

set -e

# Change working directory to path of script, so this script can be executed from anywhere.
cd "$SCRIPT_DIR"

# Resolve symlinks.
cd "$(pwd -P)"

# Obtain overlay instance name from configuration.
set +e
ov_cfg_device="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" "$TARGET_NAME" \
    | tr -d '"')";
if test "$?" -ne 0; then
  >&2 echo "Error: '$1' is not defined in '$LOCAL_CFG'!"
  exit 1
fi

# Obtain bitstream path from configuration.
set +e
bitstream="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" $TARGET_BITSTREAM \
    | tr -d '"')";
BITSTREAM_DIR=$(dirname "$bitstream")

# Print some user information about configuration settings
echo -e "\nBuilding Petalinux project with the following configuration settings...\n"
echo -e ">> Overlay instance name: $ov_cfg_device"
echo -e ">> Bitstream location: $bitstream"

# retrieve project name
PETALINUX_PRJ_NAME=$TARGET_BOARD 

# move to project location 
cd "$BUILD_DIR/$PETALINUX_PRJ_NAME/images/linux"

if [ ! -f regs.init ]; then
  echo ".set. 0xFF41A040 = 0x3;" > regs.init
fi

if [ -z ${PETALINUX_PRJ_NAME} ]; then

  # Generate images including bitstream with `petalinux-package`.
  cp "$bitstream" hero_exil${TARGET_BOARD}_wrapper.bit
  echo "
  the_ROM_image:
  {
    [init] regs.init
    [bootloader] zynqmp_fsbl.elf
    [pmufw_image] pmufw.elf
    [destination_device=pl] hero_exil${TARGET_BOARD}_wrapper.bit
    [destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
    [destination_cpu=a53-0, exception_level=el-2] u-boot.elf
  }
  # " > bootgen.bif
  $PETALINUX_VER petalinux-package --boot --force \
    --fsbl zynqmp_fsbl.elf \
    --fpga hero_exil${TARGET_BOARD}_wrapper.bit \
    --u-boot u-boot.elf \
    --pmufw pmufw.elf \
    --bif bootgen.bif

else

  # Generate images including bitstream with `petalinux-package`.
  cp "$bitstream" ${PETALINUX_PRJ_NAME}.bit
  echo "
  the_ROM_image:
  {
    [init] regs.init
    [bootloader] zynqmp_fsbl.elf
    [pmufw_image] pmufw.elf
    [destination_device=pl] ${PETALINUX_PRJ_NAME}.bit
    [destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
    [destination_cpu=a53-0, exception_level=el-2] u-boot.elf
  }
  # " > bootgen.bif
  $PETALINUX_VER petalinux-package --boot --force \
    --fsbl zynqmp_fsbl.elf \
    --fpga ${PETALINUX_PRJ_NAME}.bit \
    --u-boot u-boot.elf \
    --pmufw pmufw.elf \
    --bif bootgen.bif

fi