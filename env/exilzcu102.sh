THIS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

if [[ -z "${HERO_INSTALL}" ]]; then
    echo "Error: HERO_INSTALL variable is not set (set it to toolchain installation path)"
    return
fi
export PATH=${HERO_INSTALL}/bin:$PATH

export PULP_CURRENT_CONFIG=hero-urania@config_file=${HERO_PULP_SDK_DIR}/configs/json/hero-urania.json

if [[ -z "${HERO_TARGET_HOST}" ]]; then
  export HERO_TARGET_PATH="/mnt/root/"
else
  export HERO_TARGET_PATH="/home/root/workspace_gbellocchi" # personalize this with your own board working space
fi
export HERO_TARGET_PATH_APPS="${HERO_TARGET_PATH}/apps"
export HERO_TARGET_PATH_LIB="${HERO_BOARD_LIB_PATH}"
export HERO_TARGET_PATH_DRIVER="${HERO_BOARD_DRIVER_PATH}"

export HWPE_TARGET_PATH_LIB="${HERO_TARGET_PATH}/lib"

# read target overlay device (set in local.cfg in HERO root directory)
# this can either overlay or not with hero-urania
hero_root_dir="${THIS_DIR}/.."
hero_config_file=${hero_root_dir}/local.cfg
eval OV_CFG_DEVICE=$(grep OV_CFG_DEV ${hero_config_file} | sed 's/.*=//' | tr -d '"')
if [ -z "${OV_CFG_DEVICE}" ]; then
    echo "ERROR: please set OV_CFG_DEV in local.cfg file"
    exit 1
else
    echo "Setup of overlay libraries for '${OV_CFG_DEVICE}'"
    export HWPE_TARGET_PATH_LIB="${HERO_TARGET_PATH}/libs/${OV_CFG_DEVICE}"
fi

export PLATFORM=ZYNQMP
export BOARD=ZYNQMP

export ARCH="aarch64"
export HERO_TOOLCHAIN_HOST_TARGET="${ARCH}-hero-linux-gnu"
export CROSS_COMPILE="${HERO_TOOLCHAIN_HOST_TARGET}-"

export HERO_TOOLCHAIN_HOST_LINUX_ARCH="${ARCH}"
export KERNEL_ARCH=${ARCH}
export KERNEL_CROSS_COMPILE=${CROSS_COMPILE}

export PULP_RISCV_GCC_TOOLCHAIN=${HERO_INSTALL}

export HERO_PULP_SDK_DIR=$(readlink -f "$THIS_DIR/../pulp/sdk")

source ${HERO_PULP_SDK_DIR}/init.sh > /dev/null
if [ -f ${HERO_PULP_SDK_DIR}/sourceme.sh ]; then
    export HERO_PULP_INC_DIR=${HERO_PULP_SDK_DIR}/pkg/sdk/dev/install/include
    source ${HERO_PULP_SDK_DIR}/sourceme.sh
fi

# TODO: determine correct sysroot in ToolChain
unset LDFLAGS
export CFLAGS="--sysroot=${HERO_INSTALL}/aarch64-hero-linux-gnu/"

# If PREM passes enabled, source the corresponding environment.
if [ ! -z "$HERCULES_INSTALL" ]; then
  echo "Configuring HERCULES at: $HERCULES_INSTALL"
  source ${HERCULES_INSTALL}/prem-environment.sh > /dev/null
  echo "Configuring HERCULES for architecture HERO/PULP"
  export HERCULES_ARCH="PULP"
fi
