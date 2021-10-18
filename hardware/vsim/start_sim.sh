#!/usr/bin/env bash

set -e

readonly vsim_gui="$1"

if [ $UNIMORE -eq 1 ]; then
if [ $vsim_gui -eq 1 ]; then
    # Run in GUI mode and silence console output.
    echo "UNIMORE setup - GUI mode"
    sleep 1s
    vsim -do 'source run.tcl' &>/dev/null
else
    # Run in console-only mode.
    echo "UNIMORE setup - Console-only mode"
    sleep 1s
    vsim -c -do 'source run.tcl; quit -code $quitCode'
fi
fi

if [ $IIS -eq 1 ]; then
if [ $vsim_gui -eq 1 ]; then
    # Run in GUI mode and silence console output.
    echo "IIS setup - GUI mode"
    sleep 1s
    vsim-10.7b -do 'source run.tcl' &>/dev/null
else
    # Run in console-only mode.
    echo "IIS setup - Console-only mode"
    sleep 1s
    vsim-10.7b -c -do 'source run.tcl; quit -code $quitCode'
fi
fi
