# comp.do
# ModelSim do-script for compiling design and testbench
vlib work
vcom -novopt -work work \
     ../../../example/vhdl/dut_example.vhd \
     ../../../src/vhdl/txt_util.vhd \
     ../../../src/vhdl/pltbutils_type_pkg.vhd \
     ../../../src/vhdl/pltbutils_func_pkg.vhd \
     ../../../src/vhdl/pltbutils_comp.vhd \
     ../../../src/vhdl/pltbutils_comp_pkg.vhd \
     ../../../example/vhdl/tc_example.vhd \
     $1 \
     ../../../example/vhdl/tb_example.vhd
     