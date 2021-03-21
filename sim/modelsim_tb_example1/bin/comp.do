# comp.do
# ModelSim do-script for compiling design and testbench
if {![file exists $libname]} {
  vlib $libname
}
vcom -novopt -work $libname \
     ../../../examples/vhdl/rtl_example/dut_example.vhd \
     ../../../src/vhdl/txt_util.vhd \
     ../../../src/vhdl/pltbutils_user_cfg_pkg.vhd \
     ../../../src/vhdl/pltbutils_func_pkg.vhd \
     ../../../src/vhdl/pltbutils_comp.vhd \
     ../../../src/vhdl/pltbutils_comp_pkg.vhd \
     ../../../examples/vhdl/tb_example1/tb_example1.vhd
     