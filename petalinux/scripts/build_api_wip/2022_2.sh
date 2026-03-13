# =====================================================================
# Project:      HERO
# Title:        2022_2
# Description:  Functions to handle Petalinux 2022.2 build.
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

# =====================================================================
# Title:        print_script_vars
# Description:  Print user log with build parameters, which depends on
#               Makefile variables, local configurations, etc.
# =====================================================================

print_script_vars()
{
  # From Makefile
  echo -e "# ===================================================================== #"
  echo -e "[zcu102.sh] Building Petalinux with the following variables:\n"

  echo -e "Makefile variables:\n"
  echo -e ">> Petalinux root: $PETALINUX_ROOT"
  echo -e ">> Petalinux version: $TARGET_VER"
  echo -e ">> Target board: $TARGET_BOARD"
  echo -e ">> Target name: $TARGET_NAME"
  echo -e ">> Target bitstream: $TARGET_BITSTREAM"
  echo -e ">> Target XSA: $TARGET_XSA"
  echo -e ""

  # From local_cfg
  echo -e "Local configuration settings:\n"
  echo -e ">> Overlay instance name: $ov_cfg_device"
  echo -e ">> XSA location: $xsa"
  echo -e ">> Bitstream location: $bitstream"
  echo -e ""

  # from local script
  echo -e "Local script variables:\n"
  echo -e ">> Petalinux project name: $PETALINUX_PRJ_NAME"
  echo -e ">> Petalinux IIS header: $PETALINUX_VER"
  echo -e "# ===================================================================== #"
}

# =====================================================================
# Title:        def_local_vars
# Description:  Define local script variables.
# =====================================================================

def_local_vars(){
  echo -e "[zcu102.sh] Defining local script variables"

  # Define project name
  PETALINUX_PRJ_NAME=$TARGET_BOARD

  # Retrieve IIS setup if necessary
  if [ "$NO_IIS" -eq 1 ]; then
    PETALINUX_VER=''
  else
    if [ -z "$PETALINUX_VER" ]; then
      PETALINUX_VER="vitis-2022.2"
    fi
  fi
  readonly PETALINUX_VER
}

# =====================================================================
# Title:        get_local_cfg
# Description:  Get values from local_cfg in top repository.
# =====================================================================

get_local_cfg(){
  echo -e "[zcu102.sh] Retrieving local configuration"

  # Obtain overlay instance name from configuration
  set +e
  ov_cfg_device="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" "$TARGET_NAME" \
      | tr -d '"')";
  if test "$?" -ne 0; then
    >&2 echo "Error: '$1' is not defined in '$LOCAL_CFG'!"
    exit 1
  fi

  # Obtain XSA path from configuration
  set +e
  xsa="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" "$TARGET_XSA" \
      | tr -d '"')";
  if test "$?" -ne 0; then
    >&2 echo "Error: '$1' is not defined in '$LOCAL_CFG'!"
    exit 1
  fi
  set -e
  readonly xsa="${xsa//\$BR2_EXTERNAL_HERO_PATH/$HERO_ROOT}"
  if ! test -r "$xsa"; then
    echo "Error: Path to XSA ('$xsa') is not readable!"
    exit 1
  fi
  XSA_DIR=$(dirname "$xsa")

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
}

# =====================================================================
# Title:        create_prj
# Description:  Create Petalinux project.
# =====================================================================

create_prj()
{
  echo -e "[zcu102.sh] Creating Petalinux project"

  # Create project
  if [ ! -d "$TARGET_BOARD" ]; then
      $PETALINUX_VER petalinux-create -t project -n "$PETALINUX_PRJ_NAME" --template zynqMP
  fi

  # Move inside project directory
  cd "$PETALINUX_ROOT/$PETALINUX_PRJ_NAME"

  # Initialize Python environment suitable for PetaLinux.
  python3.6 -m venv .venv
  ln -sf python3.6 .venv/bin/python3
  source .venv/bin/activate
}

# =====================================================================
# Title:        init_prj
# Description:  Initialize Petalinux project and retrieve Linux sources.
# =====================================================================

init_prj(){
  echo -e "[zcu102.sh] Initializing Petalinux project"

  # Move inside project directory
  cd "$PETALINUX_ROOT/$PETALINUX_PRJ_NAME"

  # Initialize and set necessary configuration from config and local config
  $PETALINUX_VER petalinux-config --silentconfig --get-hw-description "$XSA_DIR"

  # Get linux sources
  mkdir -p $PETALINUX_ROOT/$PETALINUX_PRJ_NAME/components/ext_sources
  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME/components/ext_sources
  if [ ! -d "linux-xlnx" ]; then
      git clone --depth 1 --single-branch --branch xilinx-v2022.2 https://github.com/Xilinx/linux-xlnx.git
  fi
  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME/components/ext_sources/linux-xlnx
  git checkout tags/xilinx-v2022.2
}

# =====================================================================
# Title:        cfg_prj_top
# Description:  Configure Petalinux top project.
# =====================================================================

cfg_prj_top(){
  echo -e "[zcu102.sh] Configuring Petalinux top project"

  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME

  # Configure petalinux project
  sed -i 's|CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_LINUX__XLNX||' project-spec/configs/config
  sed -i 's|CONFIG_SUBSYSTEM_ROOTFS_INITRAMFS||' project-spec/configs/config
  echo 'CONFIG_SUBSYSTEM_ROOTFS_SD=y' >> project-spec/configs/config
  echo 'CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT__LOCAL__SRC=y' >> project-spec/configs/config
  # echo 'CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT_LOCAL_SRC_PATH="${TOPDIR}/../../components/ext_sources/linux-xlnx"' >> project-spec/configs/config
  echo 'CONFIG_SUBSYSTEM_COMPONENT_LINUX__KERNEL_NAME_EXT_LOCAL_SRC_PATH="${TOPDIR}/../components/ext_sources/linux-xlnx"' >> project-spec/configs/config
  echo 'CONFIG_SUBSYSTEM_SDROOT_DEV="/dev/mmcblk0p2"' >> project-spec/configs/config
  echo 'CONFIG_SUBSYSTEM_MACHINE_NAME="zcu102-revb"' >> project-spec/configs/config

  if [ -f "$LOCAL_CFG" ] && grep -q PT_ETH_MAC "$LOCAL_CFG"; then
      sed -e 's/PT_ETH_MAC/CONFIG_SUBSYSTEM_ETHERNET_PSU_ETHERNET_3_MAC/;t;d' "$LOCAL_CFG" >> project-spec/configs/config
  fi

  # Retrieve XSA file
  $PETALINUX_VER petalinux-config --silentconfig --get-hw-description "$XSA_DIR"

  echo "
  /include/ \"system-conf.dtsi\"
  /include/ \"${HERO_ROOT}/board/xilzcu102/hero.dtsi\"
  / {
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
}

# =====================================================================
# Title:        cfg_prj_kernel
# Description:  Configure Petalinux kernel.
# =====================================================================

cfg_prj_kernel(){
  echo -e "[zcu102.sh] Configuring Petalinux kernel"

  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME

  # # # Run kernel configuration and build just to generate devtool fragment which contains the change deltas from the kernel baseline
  # echo "Generating kernel configuration file with devtool"
  # $PETALINUX_VER petalinux-config -c kernel --silentconfig
  # $PETALINUX_VER petalinux-build -c kernel

  # # Configure petalinux kernel
  # echo "Configuring petalinux kernel"
  # echo '# CONFIG_CPU_IDLE is not set' >> project-spec/meta-user/recipes-kernel/linux/linux-xlnx/devtool-fragment.cfg
  # echo 'CONFIG_EDAC_CORTEX_ARM64=y' >> project-spec/meta-user/recipes-kernel/linux/linux-xlnx/devtool-fragment.cfg
}

# =====================================================================
# Title:        build_prj
# Description:  Build Petalinux project.
# =====================================================================

build_prj(){
  echo -e "[zcu102.sh] Building Petalinux project"

  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME

  # Build PetaLinux.
  set +e
  $PETALINUX_VER petalinux-build
  # # # # echo "First build might fail, this is expected..."
  # # # # set -e
  # # # # mkdir -p build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/
  # # # # cp project-spec/hw-description/system.hdf build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/
  # # # # $PETALINUX_VER petalinux-build
}

# =====================================================================
# Title:        gen_images
# Description:  Generate Petalinux images.
# =====================================================================

gen_images(){
  echo -e "[zcu102.sh] Generate Petalinux images"

  cd $PETALINUX_ROOT/$PETALINUX_PRJ_NAME/images/linux

  # mkdir -p $PETALINUX_ROOT/$PETALINUX_PRJ_NAME/build/tmp/work/aarch64-xilinx-linux/external-hdf/1.0-r0/git/plnx_aarch64/

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
}
