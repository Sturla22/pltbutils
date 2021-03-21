--! \file tb_template1.vhd
--! \brief PlTbUtils Testbench Template 1
--!
--!  This file is part of the PlTbUtils project
--!  http://opencores.org/project,pltbutils
--!
--!  This file is a template, which can be used as a base when
--!  testbenches which use PlTbUtils.
--!  Copy this file to your preferred location and rename the
--!  copied file and its contents, by replacing the word
--!  "template" with a name for your design.
--!  Also remove informative comments enclosed in < ... > .
--!
--!  \author Per Larsson, pela.opencores@gmail.com
--!
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;
-- < Template info: add more libraries here, if needed >

entity tb_template1 is
  generic (
     G_CLK_PERIOD  : time := 10 ns; -- < Template info: change value if needed >
     G_SKIPTESTS   : std_logic_vector := (
                       '0', -- Dummy
                       '0', -- Test 1
                       '0'  -- Test 2
                           -- ... etc
                     )
    -- < Template info: add more generics here if needed >
  );
end entity tb_template1;

architecture bhv of tb_template1 is

  -- Simulation status- and control signals
  -- for accessing .stop_sim and for viewing in waveform window
  signal pltbs          : pltbs_t := C_PLTBS_INIT;

  -- DUT stimuli and response signals
  signal clk            : std_logic;
  signal rst            : std_logic;
  -- < Template info: add more DUT stimuli and response signals here. >

begin

  dut0 : entity work.template
    -- generic map (
      -- < Template info: add DUT generics here, if any. >
    -- )
    port map (
      clk_i             => clk, -- Template example
      rst_i             => rst -- Template example
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

  -- Testcase process
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
    end if; -- is_test_active
    endtest(pltbv, pltbs);

    starttest(2, "Template test", pltbv, pltbs);
    if is_test_active(pltbv) then
      -- < Template info: set all relevant DUT inputs here. >
      waitclks(2, clk, pltbv, pltbs); -- Template example
      -- < Template info: check all relevant DUT outputs here. >
    end if; -- is_test_active
    endtest(pltbv, pltbs);

    -- < Template info: add more tests here. >

    endsim(pltbv, pltbs, true);
    wait;
  end process p_tc1;

end architecture bhv;
