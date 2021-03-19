----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Testcase Architecture for                          ----
---- Template Testbench                                           ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file is a template, which can be used as a base when    ----
---- testbenches which use PlTbUtils.                             ----
---- Copy this file to your preferred location and rename the     ----
---- copied file and its contents, by replacing the word          ---- 
---- "templateXX" with a name for your design.                    ----
---- Also remove informative comments enclosed in < ... > .       ----
----                                                              ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Per Larsson, pela.opencores@gmail.com                      ----
----                                                              ----
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.txt_util.all;
use work.pltbutils_func_pkg.all;

architecture tc1 of tc_template2 is
begin
  p_tc1 : process
    variable pltbv  : pltbv_t := C_PLTBV_INIT;
  begin
    startsim("tc1", G_SKIPTESTS, pltbv, pltbs);
    rst         <= '1'; -- Template example
    -- < Template info: initialize other DUT stimuli here. >
        
    starttest(1, "Reset test", pltbv, pltbs); -- Template example
    if is_test_active(pltbv) then
      waitclks(2, clk, pltbv, pltbs); -- Template example
      check("template_signal during reset", template_signal, 0, pltbv, pltbs); -- Template example
      -- < Template info: check other DUT outputs here. 
      rst  <= '0'; -- Template example
    end if; -- is_test_active()
    endtest(pltbv, pltbs);
    
    starttest(2, "Template test", pltbv, pltbs);
    if is_test_active(pltbv) then
      -- < Template info: set all relevant DUT inputs here. >
      waitclks(2, clk, pltbv, pltbs); -- Template example
      -- < Template info: check all relevant DUT outputs here. >
    end if; -- is_test_active()
    endtest(pltbv, pltbs);

    -- < Template info: add more tests here. >

    endsim(pltbv, pltbs, true);
    wait;
  end process p_tc1;
end architecture tc1;