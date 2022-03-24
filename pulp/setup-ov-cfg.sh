# =====================================================================
# Project:      PULP SDK
# Title:        setup-ov-cfg.sh
# Description:  Setup SDK profile for target overlay device.
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
  exit 1
else
  echo -e ""
  echo "# ====================================================================="
  echo "#"
  echo "# Setup of overlay libraries for target '${ov_cfg_device}'"
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

# ------------------------------------------------------------------------------------- #

# ============= #
# Setup headers #
# ============= #

# The compiled headers for ${ov_cfg_device} are symbolically linked to an include directory.
# This allows to not modify the compilation flow and adapt it to the different overlay
# instances the user may want to work with.
if [ -d "${install_inc_dir}" ]; then
    ln -sf ${install_inc_dir} ${install_dir}/include
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
ln -sf ${install_lib_dir} ${install_lib_dir}/../${pulp_chip}

# Create symlink from current config to hero-sim
# FIXME: remove the special logic for hero-sim after unifying this further
ln -sf ${install_lib_dir} ${install_lib_dir}/../hero-sim

# ------------------------------------------------------------------------------------- #

# ======================================== #
# Build and install configuration profiles #
# ======================================== #

# Remove previous versions of same overlay instance
if [ -d "${install_ov_cfg_dir}-xilzcu102" ]; then
    if [ -n "$(ls -A ${install_ov_cfg_dir}-xilzcu102 2>/dev/null)" ]; then
        rm ${install_ov_cfg_dir}-xilzcu102/*
    fi
fi
if [ -d "${install_ov_cfg_dir}-sim" ]; then
    if [ -n "$(ls -A ${install_ov_cfg_dir}-sim 2>/dev/null)" ]; then
        rm ${install_ov_cfg_dir}-sim/*
    fi
fi

# Install deployment object files (xilzcu102)
cd ${THIS_DIR}
source ${THIS_DIR}/sdk/sourceme.sh
mkdir -p ${install_ov_cfg_dir}-xilzcu102
$HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/xilzcu102/cl_config.h -c refs/rt_conf.c -o ${install_ov_cfg_dir}-xilzcu102/rt_conf.o
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/xilzcu102/* ${install_ov_cfg_dir}-xilzcu102

# Install simulation object files (sim)
cd ${THIS_DIR}
source ${THIS_DIR}/sdk/sourceme.sh
mkdir -p ${install_ov_cfg_dir}-sim
# $HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/sim/cl_config.h -c refs/rt_conf.c -o ${install_ov_cfg_dir}-sim/rt_conf.o
ln -sf ${install_ov_cfg_dir}-xilzcu102/rt_conf.o ${install_ov_cfg_dir}-sim
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/sim/* ${install_ov_cfg_dir}-sim

# Install deployment object files (xilzcu102)
cp -r ${THIS_DIR}/refs/omptarget.ld ${install_hero_cfg_dir}
cp -r ${THIS_DIR}/refs/rt_conf.c ${install_hero_cfg_dir}

# Create symlink to hero-urania/sim
ln -sf ${install_ov_cfg_dir}-xilzcu102 ${install_hero_cfg_dir}/hero-urania
ln -sf ${install_ov_cfg_dir}-sim ${install_hero_cfg_dir}/hero-sim

# ------------------------------------------------------------------------------------- #