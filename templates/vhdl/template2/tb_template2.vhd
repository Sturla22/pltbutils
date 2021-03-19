----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Testbench Template 2                               ----
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
---- "template" with a name for your design.                      ----
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
use std.textio.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;
-- < Template info: add more libraries here, if needed >

entity tb_template2 is
  generic (
    G_CLK_PERIOD  : time := 10 ns; -- < Template info: change value if needed >
    G_SKIPTESTS   : std_logic_vector := (
                      '0', -- Dummy
                      '0', -- Test 1
                      '0'  -- Test 2
                           -- ... etc
                    );
    -- < Template info: add more generics here if needed >    
  );
end entity tb_template2;

architecture bhv of tb_template2 is

  -- Simulation status- and control signals
  -- for accessing .stop_sim and for viewing in waveform window
  signal pltbs          : pltbs_t := C_PLTBS_INIT;
  
  -- DUT stimuli and response signals
  signal clk            : std_logic;
  signal rst            : std_logic;
  -- < Template info: add more DUT stimuli and response signals here. >
  
begin

  dut0 : entity work.template
    generic map (
      -- < Template info: add DUT generics here, if any. >      
    )
    port map (
      clk_i             => clk, -- Template example
      rst_i             => rst, -- Template example
      -- < Template info: add more DUT ports here. >
    );
    
  clkgen0 : pltbutils_clkgen
    generic map(
      G_PERIOD          => G_CLK_PERIOD
    )
    port map(
      clk_o             => clk,
      stop_sim_i        => pltbs.stop_sim
    );
   
  tc0 : entity work.tc_template2
    generic map (
      G_SKIPTESTS       => G_SKIPTESTS
      -- < Template info: add more generics for testcase component here, if needed. >
    )
    port map(
      clk               => clk, -- Template example
      rst               => rst, -- Template example
      -- < Template info: add more ports for testcase component here. >
    );
  
end architecture bhv;
