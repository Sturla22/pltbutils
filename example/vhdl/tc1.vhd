----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Example Testcase Architecture for                  ----
---- Example Testbench                                            ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                  ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file is a template, which can be used as a base when    ----
---- testbenches which use PlTbUtils.                             ----
---- Copy this file to your preferred location and rename the     ----
---- copied file and its contents, by replacing the word          ---- 
---- "template" with a name for your design.                      ----
---- Also remove informative comments enclosed in < ... > .       ----
----                                                              ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Per Larsson, pela@opencores.org                            ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2013 Authors and OPENCORES.ORG                 ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU Lesser General Public License for more  ----
---- details.                                                     ----
----                                                              ----
---- You should have received a copy of the GNU Lesser General    ----
---- Public License along with this source; if not, download it   ----
---- from http://www.opencores.org/lgpl.shtml                     ----
----                                                              ----
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pltbutils_func_pkg.all;

-- NOTE: The purpose of the following code is to demonstrate some of the 
-- features in PlTbUtils, not to do a thorough verification.
architecture tc1 of tc_example is
begin
  p_tc1 : process
  begin
    startsim("tc1", pltbutils_sc);
    rst         <= '1';
    carry_in    <= '0';
    x           <= (others => '0');
    y           <= (others => '0');
        
    starttest(1, "Reset test", pltbutils_sc);
    waitclks(2, clk, pltbutils_sc);    
    check("Sum during reset",       sum,         0, pltbutils_sc);
    check("Carry out during reset", carry_out, '0', pltbutils_sc);
    rst         <= '0';
    endtest(pltbutils_sc);
    
    starttest(2, "Simple sum test", pltbutils_sc);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbutils_sc);
    check("Sum",       sum,         3, pltbutils_sc); 
    check("Carry out", carry_out, '0', pltbutils_sc); 
    endtest(pltbutils_sc);
    
    starttest(3, "Simple carry in test", pltbutils_sc);
    print(G_DISABLE_BUGS=0, pltbutils_sc, "Bug here somewhere");
    carry_in <= '1';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbutils_sc);
    check("Sum",       sum,         4, pltbutils_sc); 
    check("Carry out", carry_out, '0', pltbutils_sc);
    print(pltbutils_sc, "");
    endtest(pltbutils_sc);

    starttest(4, "Simple carry out test", pltbutils_sc);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(2**G_WIDTH-1, x'length));
    y <= std_logic_vector(to_unsigned(1, x'length));
    waitclks(2, clk, pltbutils_sc);
    check("Sum",       sum,         0, pltbutils_sc); 
    check("Carry out", carry_out, '1', pltbutils_sc);
    endtest(pltbutils_sc);

    endsim(pltbutils_sc, true);
    wait;
  end process p_tc1;
end architecture tc1;