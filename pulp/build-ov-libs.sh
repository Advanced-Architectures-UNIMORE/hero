# =====================================================================
# Project:      PULP SDK
# Title:        build-ov-libs.sh
# Description:  Build device libraries for target overlay device.
#
# $Date:        24.3.2022
# =====================================================================
#
# Copyright (C) 2022 University of Modena and Reggio Emilia.
#
# Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

#!/usr/bin/env bash

# ------------------------------------------------------------------------------------- #

# ============== #
# Initialization #
# ============== #

# set local vars
pulp_chip=${1}
THIS_DIR=$(dirname "$(readlink -f "$0")")

# Check environment
set -e
if [ -z "${PULP_SDK_HOME}" ]; then
  echo "Fatal error: The 'PULP_SDK_HOME' environment variable is not defined!"
  exit 1
fi
if [ -z "${HERO_INSTALL}" ]; then
  echo "Fatal error: The 'HERO_INSTALL' environment variable is not defined!"
  exit 1
fi
if [ "$#" -ne 1 ]; then
    echo 'Fatal: expects a single argument'
    exit 1
fi
if [ ! -f "${THIS_DIR}/sdk/configs/${pulp_chip}.sh" ]; then
    echo "Fatal: Config for PULP chip '$1' does not exist"
    exit 1
fi

# Check board installation environment
if [ -z "${HERO_TARGET_HOST}" ]; then
    echo "Fatal: 'HERO_TARGET_HOST' environment variable is not defined!"
    exit 1
fi
if [ -z "${HERO_TARGET_PATH_LIB}" ]; then
    echo "Fatal: 'HERO_TARGET_PATH_LIB' environment variable is not defined!"
    exit 1
fi

# read target overlay device (set in local.cfg in HERO root directory)
# this can either overlay or not with hero-urania
hero_root_dir="${THIS_DIR}/.."
hero_config_file=${hero_root_dir}/local.cfg # HERO Config File
eval ov_cfg_device=$(grep OV_CFG_DEV ${hero_config_file} | sed 's/.*=//' | tr -d '"')
if [ -z "${ov_cfg_device}" ]; then
  echo "ERROR: please set OV_CFG_DEV in local.cfg file"
  exit 1
else
  echo -e ""
  echo "# ====================================================================="
  echo "#"
  echo "# Build device libraries for target '${ov_cfg_device}'"
  echo "#"
  echo "# ====================================================================="
  echo -e ""
fi

# ------------------------------------------------------------------------------------- #

# ================================== #
# Build and install device libraries #
# ================================== #

# Build libhero-target
make -C "${hero_root_dir}/support/libhero-target/pulp" header build install

# Build libpremnotify for PULP
${THIS_DIR}/setup-libprem-pulp.sh "${THIS_DIR}/.."

# ------------------------------------------------------------------------------------- #