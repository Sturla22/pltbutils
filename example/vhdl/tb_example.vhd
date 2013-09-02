----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Example Testbench                                  ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
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
use std.textio.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;

entity tb_example is
  generic (
    G_WIDTH             : integer := 8;
    G_CLK_PERIOD        : time := 10 ns;
    G_DISABLE_BUGS      : integer range 0 to 1 := 0
  );
end entity tb_example;

architecture bhv of tb_example is

  -- Simulation status- and control signals
  signal test_num       : integer;
  -- VHDL-1993:
  --signal test_name      : string(pltbutils_test_name'range);
  --signal info           : string(pltbutils_info'range);
  -- VHDL-2002:
  signal test_name      : string(pltbutils_sc.test_name'range);
  signal info           : string(pltbutils_sc.info'range);

  signal checks         : integer;
  signal errors         : integer;
  signal stop_sim       : std_logic;
  
  -- DUT stimuli and response signals
  signal clk            : std_logic;
  signal rst            : std_logic;
  signal carry_in       : std_logic;
  signal x              : std_logic_vector(G_WIDTH-1 downto 0);
  signal y              : std_logic_vector(G_WIDTH-1 downto 0);
  signal sum            : std_logic_vector(G_WIDTH-1 downto 0);
  signal carry_out      : std_logic;
  
begin

  -- Simulation status and control for viewing in waveform window
  -- VHDL-1993:
  --test_num  <= pltbutils_test_num;
  --test_name <= pltbutils_test_name;
  --checks    <= pltbutils_chk_cnt;
  --errors    <= pltbutils_err_cnt;
  -- VHDL-2002:
  test_num  <= pltbutils_sc.test_num;
  test_name <= pltbutils_sc.test_name;
  info      <= pltbutils_sc.info;
  checks    <= pltbutils_sc.chk_cnt;
  errors    <= pltbutils_sc.err_cnt;
  stop_sim  <= pltbutils_sc.stop_sim;
  
  
  dut0 : entity work.dut_example
    generic map (
      G_WIDTH           => G_WIDTH,
      G_DISABLE_BUGS    => G_DISABLE_BUGS
    )
    port map (
      clk_i             => clk,
      rst_i             => rst,
      carry_i           => carry_in,
      x_i               => x,
      y_i               => y, 
      sum_o             => sum,
      carry_o           => carry_out
    );
    
  clkgen0 : pltbutils_clkgen
    generic map(
      G_PERIOD          => G_CLK_PERIOD
    )
    port map(
      clk_o             => clk,
      stop_sim_i        => stop_sim
    );
   
  tc0 : entity work.tc_example
    generic map (
      G_WIDTH           => G_WIDTH
    )
    port map(
      clk               => clk,
      rst               => rst,
      carry_in          => carry_in,
      x                 => x,
      y                 => y,
      sum               => sum,
      carry_out         => carry_out
    );
  
end architecture bhv;
