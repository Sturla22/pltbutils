----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Example Testcase Architecture for                  ----
---- Template Testbench                                            ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                  ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file is an example which demonstrates how PlTbUtils     ----
---- can be used.                                                 ----
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

architecture tc1 of tc_template is
begin
  p_tc1 : process
  begin
    startsim("tc1", pltbutils_sc);
    rst         <= '1'; -- Template example
    -- < Template info: initialize other DUT stimuli here. >
        
    testname(1, "Reset test", pltbutils_sc); -- Template example
    waitclks(2, clk, pltbutils_sc); -- Template example
    check("template_signal during reset", template_signal, 0, pltbutils_sc); -- Template example
    -- < Template info: check other DUT outputs here. 
    rst  <= '0'; -- Template example
    
    testname(2, "Template test", pltbutils_sc);
    -- < Template info: set all relevant DUT inputs here. >
    waitclks(2, clk, pltbutils_sc); -- Template example
    -- < Template info: check all relevant DUT outputs here. >
    
    -- < Template info: add more tests here. >

    endsim(pltbutils_sc, true);
    wait;
  end process p_tc1;
end architecture tc1;