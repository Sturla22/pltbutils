--! \file pltbutils_comp.vhd
--! \brief PlTbUtils Components, defines testbench components.
--!
--! This file is part of the PlTbUtils project
--! http://opencores.org/project,pltbutils
--!
--! \author Per Larsson, pela.opencores@gmail.com
--!
--! \copyright Copyright (C) 2013-2020 Authors and OPENCORES.ORG
--!
--! \licenseblock
--! This source file may be used and distributed without
--! restriction provided that this copyright statement is not
--! removed from the file and that any derivative work contains
--! the original copyright notice and the associated disclaimer.
--!
--! This source file is free software; you can redistribute it
--! and/or modify it under the terms of the GNU Lesser General
--! Public License as published by the Free Software Foundation;
--! either version 2.1 of the License, or (at your option) any
--! later version.
--!
--! This source is distributed in the hope that it will be
--! useful, but WITHOUT ANY WARRANTY; without even the implied
--! warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
--! PURPOSE. See the GNU Lesser General Public License for more
--! details.
--!
--! You should have received a copy of the GNU Lesser General
--! Public License along with this source; if not, download it
--! from http://www.opencores.org/lgpl.shtml
--! \endlicenseblock

library ieee;
  use ieee.std_logic_1164.all;

--! \brief Creates a clock for use in a testbench.
--!
--! A non-inverted as well as an inverted output is available,
--! use one or both depending on if you need a single-ended or
--! differential clock.
--! The clock stops when input port stop_sim goes '1'.
--! This makes the simulator stop (unless there are other infinite
--! processes running in the simulation).
--!
--! **Instantiation template**
--!
--! (copy to your own file and remove the comment characters):
--!
--! ```vhdl
--! pltbutils_clkgen0 : pltbutils_clkgen
--!  generic map (
--!    G_PERIOD        => G_PERIOD,
--!    G_INITVALUE     => '0'
--!  )
--!  port map (
--!    clk_o           => clk,
--!    clk_n_o         => clk_n,
--!    stop_sim_i      => stop_sim
--!  );
--! ```
entity pltbutils_clkgen is
  generic (
    G_PERIOD    : time      := 10 ns; --! Clock period.
    G_INITVALUE : std_logic := '0'    --! Initial value of the clock.
  );
  port (
    clk_o      : out   std_logic; --! Clock output.
    clk_n_o    : out   std_logic; --! Inverted clock for differential clocks.
    stop_sim_i : in    std_logic  --! Stops the clock when '1'.
  );
end entity pltbutils_clkgen;

architecture bhv of pltbutils_clkgen is

  constant C_HALF_PERIOD : time := G_PERIOD / 2;
  signal   clk           : std_logic := G_INITVALUE;

begin

  clk     <= not clk and not stop_sim_i after C_HALF_PERIOD;
  clk_o   <= clk;
  clk_n_o <= not clk;

end architecture bhv;


library ieee;
  use ieee.std_logic_1164.all;

--! \brief Measures high-time, low-time and period of a signal, usually a
--! clock.
--!
--! Setting G_VERBOSITY to at least 20 reports measures times.
--! Set G_RPT_LABEL to a prefix used in reports, typically the name
--! of the signal being measured.
--!
--! **Instantiation template**
--!
--! (copy to your own file and remove the comment characters):
--!
--! ```vhdl
--!pltbutils_time_measure0 : pltbutils_time_measure
--!  generic map (
--!    G_VERBOSITY     => G_VERBOSITY
--!    G_RPT_LABEL     => "sig"
--!  )
--!  port map (
--!    t_hi_o          => sig_t_hi,
--!    t_lo_o          => sig_t_lo,
--!    t_per_o         => sig_t_per,
--!    s_i             => sig
--!  );
--! ```
entity pltbutils_time_measure is
  generic (
    G_VERBOSITY     : integer := 0;
    G_RPT_LABEL     : string  := "pltbutils_time_measure"
  );
  port (
    t_hi_o          : out time;             --! High time
    t_lo_o          : out time;             --! Low time
    t_per_o         : out time;             --! Period time
    s_i             : in  std_logic         --! Signal to measure
  );
end entity pltbutils_time_measure;

architecture bhv of pltbutils_time_measure is
  signal   t_hi         : time := 0 ns;
  signal   t_lo         : time := 0 ns;
  signal   t_per        : time := 0 ns;
begin

  measure_p : process (s_i)
    variable last_rising_edge  : time := -1 ns;
    variable last_falling_edge : time := -1 ns;
  begin
    if rising_edge(s_i) then
      if last_falling_edge >= 0 ns then
        t_lo <= now - last_falling_edge;
      end if;
      if last_rising_edge >= 0 ns then
        t_per <= now - last_rising_edge;
      end if;
      last_rising_edge := now;
    end if;

    if falling_edge(s_i) then
      if last_rising_edge >= 0 ns then
        t_hi <= now - last_rising_edge;
      end if;
      last_falling_edge := now;
    end if;
  end process measure_p;

  assert not (G_VERBOSITY >  20 and t_lo'event)
    report G_RPT_LABEL & ": t_lo=" & time'image(t_lo)
    severity note;

  assert not (G_VERBOSITY >  20 and t_hi'event)
    report G_RPT_LABEL & ": t_hi=" & time'image(t_hi)
    severity note;

  assert not (G_VERBOSITY >  20 and t_per'event)
    report G_RPT_LABEL & ": t_hi=" & time'image(t_per)
    severity note;

  t_hi_o        <= t_hi;
  t_lo_o        <= t_lo;
  t_per_o       <= t_per;

end architecture bhv;

library ieee;
  use ieee.std_logic_1164.all;

--! \brief Checks that the negative half of a diff pair is the
--! always the complement of the positive half.
--!
--! Setting G_VERBOSITY to at least 100 reports number of diff errors.
--! Set G_RPT_LABEL to a prefix used in reports, typically the name
--! of the signal being measured.
--!
--! **Instantiation template**
--!
--! (copy to your own file and remove the comment characters):
--!
--! ```vhdl
--!pltbutils_diff_check0 : pltbutils_diff_check
--!  generic map (
--!    G_VERBOSITY     => G_VERBOSITY
--!    G_RPT_LABEL     => "sig"
--!  )
--!  port map (
--!    diff_error      => sig_diff_error,
--!    diff_errors     => sig_diff_errors,
--!    s_i             => sig,
--!    s_n_i           => sig_n,
--!    rst_errors_i    => sig_rst_errors
--!  );
--! ```
entity pltbutils_diff_check is
  generic (
    G_VERBOSITY     : integer := 0;
    G_RPT_LABEL     : string  := "pltbutils_diff_check"
  );
  port (
    diff_error_o    : out std_logic;        --! High when diff error detected
    diff_errors_o   : out integer;          --! Number of diff errors detected
    s_i             : in  std_logic;        --! Pos half of diff pair to check
    s_n_i           : in  std_logic := '0'; --! Neg half of diff pair to check
    rst_errors_i    : in  std_logic := '0'  --! High resets diff error counter
  );
end entity pltbutils_diff_check;

architecture bhv of pltbutils_diff_check is
  constant C_INTEGER_MAX : integer := (2**30) + ((2**30)-1); -- Equals (2**31)-1 without overflowing;
  signal   diff_error   : std_logic := '0';
  signal   diff_errors  : integer := 0;
begin

  diff_check_p : process (s_i, s_n_i, rst_errors_i)
  -- TODO: allow a small (configurable) timing tolerance between edges of s_i and s_n_i
  begin
    if s_i /= not s_n_i then
      diff_error  <= '1';
      if diff_errors < C_INTEGER_MAX then
        diff_errors <= diff_errors + 1;
      end if;
    else
      diff_error  <= '0';
    end if;
    if rst_errors_i = '1' then
      diff_errors <= 0;
    end if;
  end process diff_check_p;

  assert not (G_VERBOSITY > 100 and diff_errors'event)
    report G_RPT_LABEL & ": diff_errors=" & integer'image(diff_errors)
    severity note;

  diff_error_o  <= diff_error;
  diff_errors_o <= diff_errors;

end architecture bhv;
