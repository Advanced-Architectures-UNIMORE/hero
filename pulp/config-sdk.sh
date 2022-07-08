# =====================================================================
# Project:      PULP SDK
# Title:        config-sdk.sh
# Description:  Configure SDK for target overlay device.
#
# $Date:        2.3.2022
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

# read target overlay device (set in local.cfg in HERO root directory)
# this can either overlay or not with hero-urania
hero_root_dir="${THIS_DIR}/.."
hero_config_file=${hero_root_dir}/local.cfg # HERO Config File
ov_cfg_device=$(grep OV_CFG_DEV ${hero_config_file} | sed 's/.*=//' | sed 's/ //g' | tr -d '"') 
if [ -z "${ov_cfg_device}" ]; then
  echo "ERROR: please set OV_CFG_DEV in local.cfg file"
  exit 1
else
  echo -e ""
  echo "# ====================================================================="
  echo "#"
  echo "# Configuring SDK for target '${ov_cfg_device}'"
  echo "#"
  echo "# ====================================================================="
  echo -e ""
fi

# ------------------------------------------------------------------------------------- #

# ========================= #
# Define installation paths #
# ========================= #

# Device install dir
install_dir=${PULP_SDK_HOME}/install
install_hero_cfg_dir=${install_dir}/hero
install_ov_cfg_dir=${install_dir}/hero/${ov_cfg_device}
install_inc_dir=${install_dir}/headers/${ov_cfg_device}
install_lib_dir=${install_dir}/lib/${ov_cfg_device}

echo -e "Creating components of SDK setup:"

# ------------------------------------------------------------------------------------- #

[ ! -d "$install_inc_dir" ] && mkdir -p ${install_inc_dir}
[ ! -d "$install_lib_dir" ] && mkdir -p ${install_lib_dir}
[ ! -d "${install_ov_cfg_dir}/xilzcu102" ] && mkdir -p ${install_ov_cfg_dir}/xilzcu102
[ ! -d "${install_ov_cfg_dir}/sim" ] && mkdir -p ${install_ov_cfg_dir}/sim

# ============= #
# Setup headers #
# ============= #

# The compiled headers for ${ov_cfg_device} are symbolically linked to an include directory.
# This allows to not modify the compilation flow and adapt it to the different overlay
# instances the user may want to work with.

echo -e "- HEADERS: ${install_inc_dir}"

link=${install_dir}/include
if [ -d "${install_inc_dir}" ]; then
    ln -sf ${install_inc_dir} ${link}
else
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
    exit 1
fi

# ------------------------------------------------------------------------------------- #

# =============== #
# Setup libraries #
# =============== #

# The compiled library for ${ov_cfg_device} are symbolically linked to ${pulp_chip}
# because to build configurations for ${ov_cfg_device} would be a majour effort (dynamic
# generation of json scripts, etc. for the SDK to build the runtime libs, etc.) that
# is not on the critical path right now.
# NB: This symbolic link has to be updated at each application swapping.

echo -e "- LIB ${pulp_chip}: ${install_lib_dir}"

link=${install_dir}/lib/${pulp_chip}
if [ -d "${install_lib_dir}" ]; then
    ln -sf ${install_lib_dir} ${link}
else
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
    exit 1
fi

# Create symlink from current config to hero-sim
# FIXME: remove the special logic for hero-sim after unifying this further

echo -e "- LIB hero-sim: ${install_lib_dir}"

link=${install_dir}/lib/hero-sim
if [ -d "${install_lib_dir}" ]; then
    ln -sf ${install_lib_dir} ${link}
else
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
    exit 1
fi

# Create symlink to SDK configuration files

echo -e "- SDK CFG-files"

ln -sf ${install_ov_cfg_dir}/xilzcu102 ${install_hero_cfg_dir}/hero-urania
ln -sf ${install_ov_cfg_dir}/sim ${install_hero_cfg_dir}/hero-sim

# ------------------------------------------------------------------------------------- #

# ============================ #
# check if SDK build is needed #
# ============================ #

if [ -z "$(ls -A ${install_lib_dir})" ]; then
    echo -e ""
    echo -e "########################################################################################################################################"
    echo -e "-- WARNING -- No libraries have been found for target '${ov_cfg_device}'. It is recommended to launch an SDK build (cmd: make sdk-pulp)."
    echo -e "########################################################################################################################################"
    echo -e ""
fi

# ------------------------------------------------------------------------------------- #