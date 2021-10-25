#!/usr/bin/env bash

error_exit()
{
  echo -e "\n$1\n" 1>&2
  exit 1
}

# Read input arguments.
readonly ROOT_DIR="$1"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"
readonly OUT_DIR="$ROOT_DIR/output"

# Move to images directory
cd $OUT_DIR

# Copy new image
if [ -n "$HERO_TARGET_HOST" ]; then
  scp {BOOT.BIN,image.ub} $HERO_TARGET_HOST:/run/media/mmcblk0p1/
else
  error_exit "HERO_TARGET_HOST is not defined. Aborting."
fi

