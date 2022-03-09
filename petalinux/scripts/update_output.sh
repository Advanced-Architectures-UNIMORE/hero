# =====================================================================
# Project:      HERO
# Title:        update_output
# Description:  Collect project binaries, divided per project.
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
# - environment
readonly BUILD_DIR="$3"
readonly OUT_DIR="$4"

# Print some user information about input parameters
echo -e "Creating output files for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target board: $TARGET_NAME"
echo -e ">> Build location: $BUILD_DIR"
echo -e ">> Output location: $OUT_DIR"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Obtain overlay instance name from configuration.
set +e
ov_cfg_device="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" "$TARGET_NAME" \
    | tr -d '"')";
if test "$?" -ne 0; then
  >&2 echo "Error: '$1' is not defined in '$LOCAL_CFG'!"
  exit 1
fi

# Print some user information about configuration settings
echo -e "\nConfiguration settings...\n"
echo -e ">> Overlay instance name: $ov_cfg_device"

PETALINUX_PRJ_NAME=$TARGET_BOARD-$ov_cfg_device

if [ -d "$OUT_DIR/$PETALINUX_PRJ_NAME" ]; then
  echo -e "\nOutput files already exist for project '$PETALINUX_PRJ_NAME'"
  exit 1
else
    mkdir $OUT_DIR/$PETALINUX_PRJ_NAME
    cp $BUILD_DIR/$PETALINUX_PRJ_NAME/config.project $OUT_DIR/$PETALINUX_PRJ_NAME
    cp -r $BUILD_DIR/$PETALINUX_PRJ_NAME/.petalinux/ $OUT_DIR/$PETALINUX_PRJ_NAME
    cp -r $BUILD_DIR/$PETALINUX_PRJ_NAME/images $OUT_DIR/$PETALINUX_PRJ_NAME
fi