#---------------------------------------------------------------------
#---                                                              ----
#--- PlTbUtils Script for generating test files                   ----
#---                                                              ----
#--- This file is part of the PlTbUtils project                   ----
#--- http://opencores.org/project,pltbutils                       ----
#---                                                              ----
#--- Description:                                                 ----
#--- PlTbUtils is a collection of functions, procedures and       ----
#--- components for easily creating stimuli and checking response ----
#--- in automatic self-checking testbenches.                      ----
#---                                                              ----
#--- This file generates test files for verifying the file check  ----
#--- procedures check_binfile, check_txtfile, check_datfile, etc. ----
#--- In tb_pltbutils.vhd, there are tests that let these          ----
#--- procedures compare test files (the ones generated by this    ----
#--- script).                                                     ----
#---                                                              ----
#--- To Do:                                                       ----
#--- -                                                            ----
#---                                                              ----
#--- Author(s):                                                   ----
#--- - Per Larsson, pela.opencores@gmail.com                      ----
#---                                                              ----
#---------------------------------------------------------------------
#---                                                              ----
#--- Copyright (C) 2020 Authors and OPENCORES.ORG                 ----
#---                                                              ----
#--- This source file may be used and distributed without         ----
#--- restriction provided that this copyright statement is not    ----
#--- removed from the file and that any derivative work contains  ----
#--- the original copyright notice and the associated disclaimer. ----
#---                                                              ----
#--- This source file is free software; you can redistribute it   ----
#--- and/or modify it under the terms of the GNU Lesser General   ----
#--- Public License as published by the Free Software Foundation; ----
#--- either version 2.1 of the License, or (at your option) any   ----
#--- later version.                                               ----
#---                                                              ----
#--- This source is distributed in the hope that it will be       ----
#--- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
#--- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
#--- PURPOSE. See the GNU Lesser General Public License for more  ----
#--- details.                                                     ----
#---                                                              ----
#--- You should have received a copy of the GNU Lesser General    ----
#--- Public License along with this source; if not, download it   ----
#--- from http://www.opencores.org/lgpl.shtml                     ----
#---                                                              ----
#---------------------------------------------------------------------

# File names of test files
set BINTESTFILE_REFERENCE        "../bench/testfiles/bintestfile_reference.bin"
set BINTESTFILE_CORRECT          "../bench/testfiles/bintestfile_correct.bin"
set BINTESTFILE_ERROR            "../bench/testfiles/bintestfile_error.bin"
set BINTESTFILE_SHORTER          "../bench/testfiles/bintestfile_shorter.bin"
set BINTESTFILE_LONGER           "../bench/testfiles/bintestfile_longer.bin"

set BINTESTFILE_HEADER           "Bintestfile R   "
set BINTESTFILE_HEADER_ERR       "Bintestfile E   "

# Generate test files
set fp_bin_ref   [open $BINTESTFILE_REFERENCE wb]
set fp_bin_corr  [open $BINTESTFILE_CORRECT   wb]
set fp_bin_err   [open $BINTESTFILE_ERROR     wb]
set fp_bin_long  [open $BINTESTFILE_LONGER    wb]
set fp_bin_short [open $BINTESTFILE_SHORTER   wb]
puts -nonewline $fp_bin_ref   $BINTESTFILE_HEADER
puts -nonewline $fp_bin_corr  $BINTESTFILE_HEADER
puts -nonewline $fp_bin_err   $BINTESTFILE_HEADER_ERR
puts -nonewline $fp_bin_long  $BINTESTFILE_HEADER
puts -nonewline $fp_bin_short $BINTESTFILE_HEADER
for {set i 0} {$i < 2} {incr i} {
  for {set j 0} {$j < 256} {incr j} {
    puts -nonewline $fp_bin_ref   [binary format c $j]
    puts -nonewline $fp_bin_corr  [binary format c $j]
    puts -nonewline $fp_bin_err   [binary format c $j]
    puts -nonewline $fp_bin_long  [binary format c $j]
    if {!($i == 1 && $j == 255)} { ;# Skip last byte in the shorter file
      puts -nonewline $fp_bin_short [binary format c $j]
    }
  }
}
puts -nonewline $fp_bin_long L ;# Add extra byte in the longer file
close $fp_bin_ref
close $fp_bin_corr
close $fp_bin_err
close $fp_bin_long
close $fp_bin_short

