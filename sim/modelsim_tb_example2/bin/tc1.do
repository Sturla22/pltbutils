# tc1.do
# ModelSim do script for compiling and running simulation
set tc ../../../examples/vhdl/tb_example2/tc1.vhd   
set libname worklib
set vsim_arg ""
if {$argc >= 1} {
  set vsim_arg $1
}

do comp.do $tc  
vsim -l ../log/$tc.log $vsim_arg $libname.tb_example2
if [file exists log.do] {
  do log.do
}
if [file exists ../bin/wave.do] {
  do ../bin/wave.do
}
run 1 ms

    