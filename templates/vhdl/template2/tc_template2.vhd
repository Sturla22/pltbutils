----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Testcase Entity for Template Testbench             ----
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
use work.pltbutils_func_pkg.all;

entity tc_template2 is
  generic (
    G_SKIPTESTS   : std_logic_vector := (
                      '0', -- Dummy
                      '0', -- Test 1
                      '0'  -- Test 2
                           -- ... etc
                    )
    -- < Template info: add more generics here if needed >    
  );
  port (
    pltbs           : out pltbs_t;
    clk             : in  std_logic; -- Template example
    rst             : out std_logic -- Template example
    -- < Template info: add more ports for testcase component here. >
    -- <                Inputs on the DUT should be outputs here,   >
    -- <                and vice versa.                             >
    -- <                Exception: clocks are inputs both on DUT    >
    -- <                and here.                                   >
  );
end entity tc_template2;
