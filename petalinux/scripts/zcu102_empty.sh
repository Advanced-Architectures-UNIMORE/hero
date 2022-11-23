# =====================================================================
# Project:      HERO
# Title:        zcu102_empty
# Description:  Compilation flow for ZCU102 Petalinux image for empty 
#               FPGA projects.
#
# $Date:        6.10.2022
# =====================================================================
#
# Copyright (C) 2022 University of Modena and Reggio Emilia.
#
# Authors: 
# - Gianluca Bellocchi, University of Modena and Reggio Emilia.
#
# =====================================================================

#!/usr/bin/env bash

# Read input arguments.
# - targets
readonly TARGET_BOARD="$1"
readonly TARGET_NAME="$2"
readonly TARGET_BITSTREAM="$3"
# - environment
readonly PETALINUX_ROOT="$4"
readonly BUILD_DIR="$5"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target name: $TARGET_NAME"
echo -e ">> Target bitstream: $TARGET_BITSTREAM"
echo -e ">> Script root: $PETALINUX_ROOT"
echo -e ">> Project location: $BUILD_DIR"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

set -e

# Change working directory to path of script, so this script can be executed from anywhere.
cd "$PETALINUX_ROOT"

# Resolve symlinks.
cd "$(pwd -P)"

# Obtain bitstream path from configuration.
set +e
bitstream="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" "$TARGET_BITSTREAM" \
    | tr -d '"')";
if test "$?" -ne 0; then
  >&2 echo "Error: '$1' is not defined in '$LOCAL_CFG'!"
  exit 1
fi
set -e
readonly bitstream="${bitstream//\$BR2_EXTERNAL_HERO_PATH/$HERO_ROOT}"
if ! test -r "$bitstream"; then
  echo "Error: Path to bitstream ('$bitstream') is not readable!"
  exit 1
fi
BITSTREAM_DIR=$(dirname "$bitstream")

# Print some user information about configuration settings
echo -e "\nBuilding Petalinux project with the following configuration settings...\n"
echo -e ">> Bitstream location: $bitstream"

# Initialize Python environment suitable for PetaLinux.
python3.6 -m venv .venv
ln -sf python3.6 .venv/bin/python3
source .venv/bin/activate

if [ "$NO_IIS" -eq 1 ]; then
  PETALINUX_VER=''
else
  if [ -z "$PETALINUX_VER" ]; then
    PETALINUX_VER="vitis-2019.2"
  fi
fi
readonly PETALINUX_VER

# move to project location 
cd $BUILD_DIR

# create project
PETALINUX_PRJ_NAME=$TARGET_BOARD\_empty
echo -e ">> Petalinux project name: $PETALINUX_PRJ_NAME"
if [ ! -d "$PETALINUX_PRJ_NAME" ]; then
    $PETALINUX_VER petalinux-create -t project -n "$PETALINUX_PRJ_NAME" --template zynqMP
fi
cd "$PETALINUX_PRJ_NAME"

# initialize and set necessary configuration from config and local config
$PETALINUX_VER petalinux-config --oldconfig --get-hw-description "$BITSTREAM_DIR"

mkdir -p components/ext_sources
cd components/ext_sources
if [ ! -d "linux-xlnx" ]; then
    # git clone --depth 1 --single-branch --branch xilinx-v2019.2.01 git@github.com:Xilinx/linux-xlnx.git
    git clone --depth 1 --single-branch --branch xilinx-v2019.2.01 https://github.com/Xilinx/linux-xlnx.git
fi  
cd linux-xlnx
git checkout tags/xilinx-v2019.2.01

cd ../../../
sed -i 's|CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_LINUX__XLNX||' project-spec/configs/config
sed -i 's|CONFIG_SUBSYSTEM_ROOTFS_INITRAMFS||' project-spec/configs/config
echo 'CONFIG_SUBSYSTEM_ROOTFS_SD=y' >> project-spec/configs/config
echo 'CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT__LOCAL__SRC=y' >> project-spec/configs/config
echo 'CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT_LOCAL_SRC_PATH="${TOPDIR}/../components/ext_sources/linux-xlnx"' >> project-spec/configs/config
echo 'CONFIG_SUBSYSTEM_SDROOT_DEV="/dev/mmcblk0p2"' >> project-spec/configs/config
echo 'CONFIG_SUBSYSTEM_MACHINE_NAME="zcu102-revb"' >> project-spec/configs/config

if [ -f "$LOCAL_CFG" ] && grep -q PT_ETH_MAC "$LOCAL_CFG"; then
    sed -e 's/PT_ETH_MAC/CONFIG_SUBSYSTEM_ETHERNET_PSU_ETHERNET_3_MAC/;t;d' "$LOCAL_CFG" >> project-spec/configs/config
fi

$PETALINUX_VER petalinux-config --oldconfig --get-hw-description "$BITSTREAM_DIR"

echo "
/include/ \"system-conf.dtsi\"
/ {
  chosen {
        bootargs = \"console=ttyPS0,115200 earlycon clk_ignore_unused\";
        stdout-path = \"serial0:115200n8\";
  };
};
" > project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

# Configure RootFS
rootfs_enable() {
    sed -i -e "s/# CONFIG_$1 is not set/CONFIG_$1=y/" project-spec/configs/rootfs_config
}
for pkg in \
    bash \
    bash-completion \
    bc \
    ed \
    grep \
    patch \
    sed \
    util-linux \
    util-linux-blkid \
    util-linux-lscpu \
    vim \
; do
  rootfs_enable $pkg
done

create_install_app() {
    $PETALINUX_VER petalinux-create --force -t apps --template install -n ${1} --enable
    cd project-spec/meta-user/recipes-apps/${1}
    patch <"$PETALINUX_ROOT/scripts/recipes-apps/${1}/${1}.bb.patch"
    rm -r files
    cp -r "$PETALINUX_ROOT/scripts/recipes-apps/${1}/files" .
    cd ->/dev/null
}

# Create application that will mount SD card folders on boot.
create_install_app init-mount
# Create application that will execute scripts from SD card on boot.
create_install_app init-exec-scripts
# Create application to deploy custom `/etc/sysctl.conf`.
cp "$HERO_ROOT/board/common/overlay/etc/sysctl.conf" "$PETALINUX_ROOT/scripts/recipes-apps/sysctl-conf/files/"
create_install_app sysctl-conf

# Build PetaLinux.
set +e
$PETALINUX_VER petalinux-build
echo "First build might fail, this is expected..."
set -e
mkdir -p build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/
cp project-spec/hw-description/system.hdf build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/
$PETALINUX_VER petalinux-build

mkdir -p build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/

cd images/linux
if [ ! -f regs.init ]; then
  echo ".set. 0xFF41A040 = 0x3;" > regs.init
fi

if [ -z ${PETALINUX_PRJ_NAME} ]; then

  # Generate images including bitstream with `petalinux-package`.
  cp "$bitstream" hero_exil${TARGET_BOARD}_wrapper.bit
  echo "
  the_ROM_image:
  {
    [init] regs.init
    [bootloader] zynqmp_fsbl.elf
    [pmufw_image] pmufw.elf
    [destination_device=pl] hero_exil${TARGET_BOARD}_wrapper.bit
    [destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
    [destination_cpu=a53-0, exception_level=el-2] u-boot.elf
  }
  # " > bootgen.bif
  $PETALINUX_VER petalinux-package --boot --force \
    --fsbl zynqmp_fsbl.elf \
    --fpga hero_exil${TARGET_BOARD}_wrapper.bit \
    --u-boot u-boot.elf \
    --pmufw pmufw.elf \
    --bif bootgen.bif

else

  # Generate images including bitstream with `petalinux-package`.
  cp "$bitstream" ${PETALINUX_PRJ_NAME}.bit
  echo "
  the_ROM_image:
  {
    [init] regs.init
    [bootloader] zynqmp_fsbl.elf
    [pmufw_image] pmufw.elf
    [destination_device=pl] ${PETALINUX_PRJ_NAME}.bit
    [destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
    [destination_cpu=a53-0, exception_level=el-2] u-boot.elf
  }
  # " > bootgen.bif
  $PETALINUX_VER petalinux-package --boot --force \
    --fsbl zynqmp_fsbl.elf \
    --fpga ${PETALINUX_PRJ_NAME}.bit \
    --u-boot u-boot.elf \
    --pmufw pmufw.elf \
    --bif bootgen.bif

fi