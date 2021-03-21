# tc1.do
# ModelSim do script for compiling and running simulation  
set libname worklib
set vsim_arg ""
if {$argc >= 1} {
  set vsim_arg $1
}

do comp.do  
vsim -l ../log/tc1.log $vsim_arg $libname.tb_pltbutils
if [file exists log.do] {
  do log.do
}
if [file exists ../bin/wave.do] {
  do ../bin/wave.do
}
run 1 ms

    
