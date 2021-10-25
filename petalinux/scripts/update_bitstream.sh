#!/usr/bin/env bash

# Read input arguments.
readonly TARGET_BOARD="$1"
readonly TARGET_HW="$2"
readonly ROOT_DIR="$3"

# Print some user information about input parameters
echo -e "Building Petalinux project for...\n"
echo -e ">> Target board: $TARGET_BOARD"
echo -e ">> Target hardware: $TARGET_HW\n"

readonly HERO_ROOT="$HERO_HOME_DIR"
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Obtain bitstream path from configuration.
set +e
bitstream="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" $TARGET_HW \
    | tr -d '"')";
BITSTREAM_DIR=$(dirname "$bitstream")

# Print some user information about the target hw
echo -e "Recovering bitstream information...\n"
echo -e ">> Target bitstream path: $bitstream"

# Move to images directory
cd "$TARGET_BOARD/images/linux"

if [ ! -f regs.init ]; then
  echo ".set. 0xFF41A040 = 0x3;" > regs.init
fi

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