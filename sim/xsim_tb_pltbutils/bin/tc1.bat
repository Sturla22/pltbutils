@echo off
set tb_name=tb_pltbutils
set libname=xil_defaultlib

call xelab -prj ..\bin\%tb_name%.prj -s %tb_name% %libname%.%tb_name%
::echo xelab error level: %errorlevel%
if %errorlevel% equ 0 (
  call xsim -runall %tb_name%
)
echo Error level (0 is good): %errorlevel%
