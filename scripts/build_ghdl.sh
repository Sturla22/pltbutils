#!/bin/env bash
# file: build_ghdl.sh

workdir="build"
lib_name="work"
lib_src="src/vhdl/*.vhd"

set -e

mkdir -p $workdir
ghdl -i --workdir=$workdir --work=$lib_name $lib_src

