# =====================================================================
# Project:      PULP SDK
# Title:        clean-sdk.sh
# Description:  Clean SDK profile for target overlay device.
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

# check environment
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

# read target overlay device (set in local.cfg in HERO root directory)
# this can either overlay or not with hero-urania
hero_root_dir="${THIS_DIR}/.."
hero_config_file=${hero_root_dir}/local.cfg # HERO Config File
eval ov_cfg_device=$(grep OV_CFG_DEV ${hero_config_file} | sed 's/.*=//' | tr -d '"')
if [ -z "${ov_cfg_device}" ]; then
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
else
    echo -e ""
    echo "# ====================================================================="
    echo "#"
    echo "# Cleaning SDK profile for target '${ov_cfg_device}'"
    echo "#"
    echo "# ====================================================================="
    echo -e ""
fi

# set env vars
export PULP_RISCV_GCC_TOOLCHAIN=$HERO_INSTALL

# ------------------------------------------------------------------------------------- #

# ======== #
# Cleaning #
# ======== #

# Device install dir
install_dir=${PULP_SDK_HOME}/install
install_hero_cfg_dir=${install_dir}/hero
install_ov_cfg_dir=${install_dir}/hero/${ov_cfg_device}
install_inc_dir=${install_dir}/headers/${ov_cfg_device}
install_lib_dir=${install_dir}/lib/${ov_cfg_device}

# Unlink old symbolic links

# headers
link=${install_dir}/include
if [ -L ${link} ]; then
    if [ -e ${link} ]; then
        unlink ${link}
    fi
fi

# libs
# - hero-urania
link=${install_lib_dir}/../${pulp_chip}
if [ -L ${link} ]; then
    if [ -e ${link} ]; then
        unlink ${link}
    fi
fi
# - hero-sim
link=${install_lib_dir}/../hero-sim
if [ -L ${link} ]; then
    if [ -e ${link} ]; then
        unlink ${link}
    fi
fi

# config files
# - hero-urania
link=${install_hero_cfg_dir}/hero-urania
echo "link=${install_hero_cfg_dir}/hero-urania"
if [ -L ${link} ]; then
    if [ -e ${link} ]; then
        unlink ${link}
    fi
fi
# - hero-sim
link=${install_hero_cfg_dir}/hero-sim
if [ -L ${link} ]; then
    if [ -e ${link} ]; then
        unlink ${link}
    fi
fi

# ------------------------------------------------------------------------------------- #