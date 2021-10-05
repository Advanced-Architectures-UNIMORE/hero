#!/usr/bin/env bash

set -e

readonly script_path="$( cd "$(dirname "$0")" ; pwd -P )"

readonly slm_path="$1"
readonly app_dir="$2"
readonly OPENMP_APP="$3"

if [ $SLM_CONV_GITHUB ]; then
    slm_conv="$script_path/slm_conv"
else
    slm_conv='slm_conv-0.3'
fi

if ! which $slm_conv &>/dev/null; then
    slm_conv=~andkurt/bin/slm_conv-0.3
fi
declare -r slm_conv

mkdir -p "$slm_path"
cd "$slm_path"

if $OPENMP_APP; then
    
    # Format binary from OpenMP examples.
    readonly examples_path="$script_path/../../openmp-examples"
    readonly app_path="$examples_path/$app_dir"
    readonly app_name=$(basename $app_dir)
    $slm_conv --swap-endianness -f "$app_path/${app_name}_l1.slm" \
        -w 32 -P 32 -S 1 -n 2048 -s 0x10000000 -F l1_%01S_%01P.slm
    $slm_conv --swap-endianness -f "$app_path/${app_name}_l2.slm" \
        -w 32 -P  4 -S 8 -n 1024 -s 0x1c000000 -F l2_%01S_%01P.slm
    cp "$app_path/${app_name}.dis" "${app_name}.dis"

else

    # Format binary from HWPE generated examples.
    readonly deps_path="$script_path/../deps"
    readonly hwpe_path="$deps_path/$app_dir"
    readonly app_name=$(basename $app_dir)
    $slm_conv --swap-endianness -f "$hwpe_path/${app_name}_l1.slm" \
        -w 32 -P 64 -S 1 -n 1024 -s 0x10000000 -F l1_%01S_%01P.slm
    $slm_conv --swap-endianness -f "$hwpe_path/${app_name}_l2.slm" \
        -w 32 -P 4 -S 8 -n 1024 -s 0x1c000000 -F l2_%01S_%01P.slm
    cp "$hwpe_path/${app_name}.dis" "${app_name}.dis"

fi
