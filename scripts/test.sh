#!/bin/env bash
# file: test.sh

testbench="tb_pltbutils"
workdir="build"
options="-P$workdir --workdir=$workdir"

set -e

source scripts/build_ghdl.sh

ghdl -i $options bench/vhdl/$testbench.vhd
ghdl -m $options $testbench
ghdl -r $options $testbench

