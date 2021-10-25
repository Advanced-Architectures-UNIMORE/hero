#!/usr/bin/env bash

error_exit()
{
  echo -e "\n$1\n" 1>&2
  exit 1
}

# Read input arguments.
readonly TARGET_BOARD="$1"
readonly TARGET_HW="$2"
readonly ROOT_DIR="$3"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target hardware: $TARGET_HW\n"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Move to images directory
cd "$TARGET_BOARD/images/linux"

# Copy new image
if [ -n "$HERO_TARGET_HOST" ]; then
  scp {BOOT.BIN,image.ub} $HERO_TARGET_HOST:/run/media/mmcblk0p1/
else
  error_exit "HERO_TARGET_HOST is not defined. Aborting."
fi

