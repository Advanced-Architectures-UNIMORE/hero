# =====================================================================
# Project:      PULP SDK
# Title:        setup-ov-libs.sh
# Description:  Update configuration files and create symbolic link to 
#               device library.
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

# set local vars
pulp_chip=${1}
THIS_DIR=$(dirname "$(readlink -f "$0")")

# read target overlay device (set in local.cfg in HERO root directory)
# this can either overlay or not with hero-urania
hero_root_dir="${THIS_DIR}/.."
hero_config_file=${hero_root_dir}/local.cfg # HERO Config File
eval ov_cfg_device=$(grep OV_CFG_DEV ${hero_config_file} | sed 's/.*=//' | tr -d '"')
if [ -z "${ov_cfg_device}" ]; then
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
else
    echo "Setup of overlay libraries for '${ov_cfg_device}'"
fi

# Device install dir
install_dir=${PULP_SDK_HOME}/install
install_cfg_dir=${install_dir}/overlay/${ov_cfg_device}
install_lib_dir=${install_dir}/lib/${ov_cfg_device}

# Remove previous versions of same instance
if [ -d "${install_cfg_dir}/xilzcu102" ]; then
    if [ -n "$(ls -A ${install_cfg_dir}/xilzcu102 2>/dev/null)" ]; then
        rm ${install_cfg_dir}/xilzcu102/*
    fi
fi
if [ -d "${install_cfg_dir}/sim" ]; then
    if [ -n "$(ls -A ${install_cfg_dir}/sim 2>/dev/null)" ]; then
        rm ${install_cfg_dir}/sim/*
    fi
fi

# Install deployment object files (xilzcu102)
cd ${THIS_DIR}
source ${THIS_DIR}/sdk/sourceme.sh
mkdir -p ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/xilzcu102
$HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/xilzcu102/cl_config.h -c refs/rt_conf.c -o ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/xilzcu102/rt_conf.o
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/xilzcu102/* ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/xilzcu102

# Install deployment object files (sim)
cd ${THIS_DIR}
source ${THIS_DIR}/sdk/sourceme.sh
mkdir -p ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/sim
$HERO_INSTALL/bin/riscv32-unknown-elf-gcc -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include -march=rv32imcxpulpv2 -D__riscv__ -include refs/${ov_cfg_device}/sim/cl_config.h -c refs/rt_conf.c -o ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/sim/rt_conf.o
cp -r ${THIS_DIR}/refs/${ov_cfg_device}/sim/* ${PULP_SDK_HOME}/install/overlay/${ov_cfg_device}/sim

# The compiled library for ${ov_cfg_device} are symbolically linked to ${pulp_chip}
# because to build configurations for ${ov_cfg_device} would be a majour effort (dynamic
# generation of json scripts, etc. for the SDK to build the runtime libs, etc.) that
# is not on the critical path right now.
# NB: This symbolic link has to be updated at each application swapping.
ln -sf ${install_lib_dir} ${install_lib_dir}/../${pulp_chip}

# Create symlink from current config to hero-sim
# FIXME: remove the special logic for hero-sim after unifying this further
ln -sf ${install_lib_dir} ${install_lib_dir}/../hero-sim

# Build libhero-target
make -C "${hero_root_dir}/support/libhero-target/pulp" header build install

# Build libpremnotify for PULP
${THIS_DIR}/setup-libprem-pulp.sh "${THIS_DIR}/.."
