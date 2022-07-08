# =====================================================================
# Project:      PULP SDK
# Title:        build-sdk.sh
# Description:  Initialize SDK setup and build the PULP runtime libraries.
#
# $Date:        24.3.2022
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
    echo "# Initializing SDK setup for target '${ov_cfg_device}'"
    echo "#"
    echo "# ====================================================================="
    echo -e ""
fi

# set env vars
export PULP_RISCV_GCC_TOOLCHAIN=$HERO_INSTALL

# ------------------------------------------------------------------------------------- #

# ============================== #
# Compile PULP runtime libraries #
# ============================== #

echo -e "Compiling PULP runtime libraries"

cd ${THIS_DIR}/sdk

source configs/${pulp_chip}.sh
source configs/platform-hsa.sh

# checkout packages
for m in \
    json-tools \
    pulp-tools \
    pulp-configs \
    pulp-rules \
    archi \
    hal \
    debug-bridge2 \
    debug-bridge; \
do
    plpbuild --m $m checkout build --stdout
done
plpbuild --g runtime checkout --stdout

# Building `pulp-rt` will fail, but this is to be expected.
set +e
plpbuild --m pulp-rt build --stdout
echo 'NOTE: The failure of building `pulp-rt` at this point is known and can be tolerated.'

# Now that the `pulp-rt` headers are installed, we can go ahead and install `archi-host` followed by
# a re-installation of the entire SDK.  At some point, this will fail because two of the runtime
# variants ('tiny' and 'bare') are not aligned with the main runtime, causing the wrong header files
# to be deployed.
plpbuild --m archi-host build --stdout

# We fix this by forcing the `pulp-rt` headers, followed by the final compilation of `libvmm`.
find runtime/pulp-rt/include -type f -exec touch {} +
plpbuild --m pulp-rt build --stdout
plpbuild --m libvmm build --stdout
plpbuild --g runtime build --stdout

# Setup environment
plpbuild --g pkg build
make env

# ------------------------------------------------------------------------------------- #

# ================================ #
# Create HEADER and LIB for target #
# ================================ #

# Create header directory
echo -e "Creating HEADER directory for target"
mkdir -p ${PULP_SDK_HOME}/install/headers/
src=${PULP_SDK_HOME}/install/include
dst=${PULP_SDK_HOME}/install/headers/${ov_cfg_device}
if [ ! -d ${dst} ]; then
    mv ${src} ${dst}
else
    rm -rf ${dst}
    mv ${src} ${dst}
fi

# Create library directory
echo -e "Creating LIB directory for target"
src=${PULP_SDK_HOME}/install/lib/${pulp_chip}
dst=${PULP_SDK_HOME}/install/lib/${ov_cfg_device}
if [ ! -d ${dst} ]; then
    mv ${src} ${dst}
else
    rm -rf ${dst}
    mv ${src} ${dst}
fi

# ------------------------------------------------------------------------------------- #