# =====================================================================
# Project:      PULP SDK
# Title:        build-refs.sh
# Description:  Build the PULP configuration (under refs/).
#
# $Date:        8.7.2022
# =====================================================================
#
# Authors: 
#   - Andreas Kurth, ETHZ.
#   - Gianluca Bellocchi, University of Modena and Reggio Emilia.
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
else
    echo -e ""
    echo "# ====================================================================="
    echo "#"
    echo "# Building SDK conifguration refs for target '${ov_cfg_device}'"
    echo "#"
    echo "# ====================================================================="
    echo -e ""
fi

# set env vars
export PULP_RISCV_GCC_TOOLCHAIN=$HERO_INSTALL

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

# SDK environment setup
source ${THIS_DIR}/sdk/sourceme.sh

echo -e "Creating components of SDK setup:"

# ------------------------------------------------------------------------------------- #

# =================================== #
# Build and install SDK configuration #
# =================================== #

echo -e "\nUpdate SDK configurations:"

# Remove previous versions of configuration files
if [ -d "${install_ov_cfg_dir}/xilzcu102" ]; then
    if [ -n "$(ls -A ${install_ov_cfg_dir}/xilzcu102 2>/dev/null)" ]; then
        rm ${install_ov_cfg_dir}/xilzcu102/*
    fi
fi
if [ -d "${install_ov_cfg_dir}/sim" ]; then
    if [ -n "$(ls -A ${install_ov_cfg_dir}/sim 2>/dev/null)" ]; then
        rm ${install_ov_cfg_dir}/sim/*
    fi
fi

# Install deployment object files (xilzcu102)
echo -e "- XILZCU102"
cd ${THIS_DIR}
mkdir -p ${install_ov_cfg_dir}/xilzcu102
$HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/xilzcu102/cl_config.h -c refs/rt_conf.c -o ${install_ov_cfg_dir}/xilzcu102/rt_conf.o
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/xilzcu102/* ${install_ov_cfg_dir}/xilzcu102

# Install simulation object files (sim)
echo -e "- SIM"
cd ${THIS_DIR}
mkdir -p ${install_ov_cfg_dir}/sim
# $HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/sim/cl_config.h -c refs/rt_conf.c -o ${install_ov_cfg_dir}/sim/rt_conf.o
ln -sf ${install_ov_cfg_dir}/xilzcu102/rt_conf.o ${install_ov_cfg_dir}/sim
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/sim/* ${install_ov_cfg_dir}/sim

# Install deployment object files (xilzcu102)
cp -r ${THIS_DIR}/refs/omptarget.ld ${install_ov_cfg_dir}
cp -r ${THIS_DIR}/refs/rt_conf.c ${install_ov_cfg_dir}

# ------------------------------------------------------------------------------------- #