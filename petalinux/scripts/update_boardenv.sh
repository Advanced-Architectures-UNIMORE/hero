# =====================================================================
# Project:      HERO
# Title:        update_boardenv
# Description:  Copy new images to board.
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

error_exit()
{
  echo -e "\n$1\n" 1>&2
  
}

# Read input arguments.
# - targets
readonly TARGET_BOARD="$1"
readonly TARGET_NAME="$2"
# - environment
readonly OUT_DIR="$3"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target board: $TARGET_NAME"
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

PETALINUX_PRJ_NAME=$TARGET_BOARD 

# Copy new image
if [ -n "$HERO_TARGET_HOST" ]; then
  if [ -d "$OUT_DIR/$PETALINUX_PRJ_NAME" ]; then
    cd "$OUT_DIR/$PETALINUX_PRJ_NAME/images/linux"
    scp {BOOT.BIN,image.ub} $HERO_TARGET_HOST:/run/media/mmcblk0p1/
  else
    error_exit "Output files not found for project '$PETALINUX_PRJ_NAME'. Aborting."
  fi
  
else
  error_exit "HERO_TARGET_HOST is not defined. Aborting."
fi

