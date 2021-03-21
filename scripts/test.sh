#!/bin/env bash
# file: test.sh

testbench="tb_pltbutils"
workdir="build"
options="-P$workdir --workdir=$workdir"

run_options="-gG_BINTESTFILE_REFERENCE=bench/testfiles/bintestfile_reference.bin"
run_options+=" -gG_BINTESTFILE_CORRECT=bench/testfiles/bintestfile_correct.bin"
run_options+=" -gG_BINTESTFILE_ERROR=bench/testfiles/bintestfile_error.bin"
run_options+=" -gG_BINTESTFILE_SHORTER=bench/testfiles/bintestfile_shorter.bin"
run_options+=" -gG_BINTESTFILE_LONGER=bench/testfiles/bintestfile_longer.txt"
run_options+=" -gG_TEXTTESTFILE_REFERENCE=bench/testfiles/texttestfile_reference.txt"
run_options+=" -gG_TEXTTESTFILE_CORRECT=bench/testfiles/texttestfile_correct.txt"
run_options+=" -gG_TEXTTESTFILE_ERROR=bench/testfiles/texttestfile_error.txt"
run_options+=" -gG_TEXTTESTFILE_SHORTER=bench/testfiles/texttestfile_shorter.txt"
run_options+=" -gG_TEXTTESTFILE_LONGER=bench/testfiles/texttestfile_longer.txt"
run_options+=" -gG_DATTESTFILE_REFERENCE=bench/testfiles/dattestfile_reference.dat"
run_options+=" -gG_DATTESTFILE_CORRECT=bench/testfiles/dattestfile_correct.dat"
run_options+=" -gG_DATTESTFILE_ERROR=bench/testfiles/dattestfile_error.dat"
run_options+=" -gG_DATTESTFILE_SHORTER=bench/testfiles/dattestfile_shorter.dat"
run_options+=" -gG_DATTESTFILE_LONGER=bench/testfiles/dattestfile_longer.dat"

set -e

source scripts/build_ghdl.sh

ghdl -i $options bench/vhdl/$testbench.vhd
ghdl -m $options $testbench
ghdl -r $options $testbench $run_options

