# =====================================================================
# Project:      HERO
# Title:        build_zcu102
# Description:  Compilation flow for ZCU102 Petalinux image for HERO.
#
# $Date:        28.05.2024
# =====================================================================
#
# Copyright (C) 2024 University of Modena and Reggio Emilia.
#
# Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

#!/usr/bin/env bash

# Read input arguments
readonly TARGET_BOARD="$1"
readonly TARGET_VER="$2"
readonly TARGET_NAME="$3"
readonly TARGET_BITSTREAM="$4"
readonly TARGET_XSA="$5"
readonly PETALINUX_ROOT="$6"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Import functions
if [ "$TARGET_VER" == "2022_2" ]; then
  source $PETALINUX_ROOT/scripts/2022_2.sh
fi

set -e

# Resolve symlinks
cd "$(pwd -P)"

# Move to Petalinux root
cd "$PETALINUX_ROOT"

# Define variables
def_local_vars

# Get local configuration
get_local_cfg

# Print variables
print_script_vars

# # Create project
# create_prj
# init_prj

# # Confiigure project
# cfg_prj_top
# cfg_prj_kernel

# # Build project
# build_prj

# Generate Linux images
gen_images
