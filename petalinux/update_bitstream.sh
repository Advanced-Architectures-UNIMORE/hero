#!/usr/bin/env bash

readonly THIS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly HERO_ROOT=$HERO_HOME_DIR
readonly LOCAL_CFG="$HERO_ROOT/local.cfg"

# Decide which bitstream to use (position in local.cfg)
readonly LOCAL_CFG_BITSTREAM="OVERLAY_BENCH_BITSTREAM"

# Obtain bitstream path from configuration.
set +e
bitstream="$("$HERO_ROOT/util/configfile/get_value" -s "$LOCAL_CFG" $LOCAL_CFG_BITSTREAM \
    | tr -d '"')";
echo "path to bitstream: $bitstream"

# Move to images directory
cd zcu102/images/linux

# Generate images including bitstream with `petalinux-package`.
cp "$bitstream" hero_exil${TARGET}_wrapper.bit
echo "
the_ROM_image:
{
  [init] regs.init
  [bootloader] zynqmp_fsbl.elf
  [pmufw_image] pmufw.elf
  [destination_device=pl] hero_exil${TARGET}_wrapper.bit
  [destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
  [destination_cpu=a53-0, exception_level=el-2] u-boot.elf
}
" > bootgen.bif
$PETALINUX_VER petalinux-package --boot --force \
  --fsbl zynqmp_fsbl.elf \
  --fpga hero_exil${TARGET}_wrapper.bit \
  --u-boot u-boot.elf \
  --pmufw pmufw.elf \
  --bif bootgen.bif
