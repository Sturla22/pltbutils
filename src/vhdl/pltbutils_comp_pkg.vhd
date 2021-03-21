----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Component Declarations                             ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file declares testbench components, which are defined   ----
---- in pltbutils_comp.vhd .                                      ----
---- "use" this file in your testbech, e.g.                       ----
----   use work.pltbutils_comp_pkg.all;                           ----
----                                                              ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Per Larsson, pela.opencores@gmail.com                      ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2013-2020 Authors and OPENCORES.ORG            ----
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

package pltbutils_comp_pkg is

  -- See pltbutils_comp.vhd for a description of the components.

  component pltbutils_clkgen is
    generic (
      G_PERIOD        : time := 10 ns;
      G_INITVALUE     : std_logic := '0'
    );
    port (
      clk_o           : out std_logic;
      clk_n_o         : out std_logic;      
      stop_sim_i      : in  std_logic
    );
  end component pltbutils_clkgen;
  
  -- Instansiation template 
  -- (copy to your own file and remove the comment characters):
  --pltbutils_clkgen0 : pltbutils_clkgen
  --  generic map (
  --    G_PERIOD        => G_PERIOD,
  --    G_INITVALUE     => '0'
  --  )
  --  port map (
  --    clk_o           => clk,
  --    clk_n_o         => clk_n,
  --    stop_sim_i      => pltbs.stop_sim
  --  );

  component pltbutils_time_measure is
    generic (
      G_VERBOSITY     : integer := 0;
      G_RPT_LABEL     : string  := "pltbutils_time_measure" 
    );
    port (
      t_hi_o          : out time;             -- High time
      t_lo_o          : out time;             -- Low time
      t_per_o         : out time;             -- Period time
      s_i             : in  std_logic         -- Signal to measure
    );
  end component pltbutils_time_measure;

  -- Instansiation template
  -- (copy to your own file and remove the comment characters):
  --pltbutils_time_measure0 : pltbutils_time_measure
  --  generic map (
  --    G_VERBOSITY     => G_VERBOSITY
  --    G_RPT_LABEL     => "sig" 
  --  )
  --  port map (
  --    t_hi_o          => sig_t_hi,
  --    t_lo_o          => sig_t_lo,
  --    t_per_o         => sig_t_per,
  --    s_i             => sig
  --  );

  component pltbutils_diff_check is
    generic (
      G_VERBOSITY     : integer := 0;
      G_RPT_LABEL     : string  := "pltbutils_diff_check" 
    );
    port (
      diff_error_o    : out std_logic;        -- High when diff error detected
      diff_errors_o   : out integer;          -- Number of diff errors detected
      s_i             : in  std_logic;        -- Pos half of diff pair to check
      s_n_i           : in  std_logic := '0'; -- Neg half of diff pair to check
      rst_errors_i    : in  std_logic := '0'  -- High resets diff error counter
    );
  end component pltbutils_diff_check;

  -- Instansiation template
  -- (copy to your own file and remove the comment characters):
  --pltbutils_diff_check0 : pltbutils_diff_check
  --  generic map (
  --    G_VERBOSITY     => G_VERBOSITY
  --    G_RPT_LABEL     => "sig" 
  --  )
  --  port map (
  --    diff_error      => sig_diff_error,
  --    diff_errors     => sig_diff_errors,
  --    s_i             => sig,
  --    s_n_i           => sig_n,
  --    rst_errors_i    => sig_rst_errors
  --  );

end package pltbutils_comp_pkg;


