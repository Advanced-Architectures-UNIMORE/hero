#!/usr/bin/env bash

readonly THIS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly HERO_ROOT=$HERO_HOME_DIR
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Move to images directory
cd zcu102/images/linux

# Copy new image
scp {BOOT.BIN,image.ub} root@hero-zcu102-08:/run/media/mmcblk0p1/