----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Fuctions and Procedures Package                    ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file defines fuctions and procedures for controlling    ----
---- stimuli to a DUT and checking response.                      ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Per Larsson, pela@opencores.org                            ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2013-2014 Authors and OPENCORES.ORG            ----
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
use std.textio.all;
use work.txt_util.all;
use work.pltbutils_type_pkg.all; -- Use for VHDL-2002, comment out for VHDL-93
use work.pltbutils_user_cfg_pkg.all;

package pltbutils_func_pkg is

  -- See the package body for a description of the functions and procedures.
  constant C_PLTBUTILS_STRLEN  : natural := 80;
  constant C_PLTBUTILS_TIMEOUT : time    := 10 sec;
  constant C_WAIT_BEFORE_STOP_TIME : time := 1 us;
  
  -- Counters for number of checks and number of errors
  -- VHDL-2002:
  shared variable v_pltbutils_testcase_name : pltbutils_p_string_t;
  shared variable v_pltbutils_testcase_name_len : pltbutils_p_integer_t;
  shared variable v_pltbutils_test_num  : pltbutils_p_integer_t;
  shared variable v_pltbutils_test_name : pltbutils_p_string_t;
  shared variable v_pltbutils_test_name_len : pltbutils_p_integer_t;
  shared variable v_pltbutils_info      : pltbutils_p_string_t;
  shared variable v_pltbutils_info_len  : pltbutils_p_integer_t;
  shared variable v_pltbutils_test_cnt  : pltbutils_p_integer_t;
  shared variable v_pltbutils_chk_cnt   : pltbutils_p_integer_t;
  shared variable v_pltbutils_err_cnt   : pltbutils_p_integer_t;
  shared variable v_pltbutils_chk_cnt_in_test : pltbutils_p_integer_t;
  shared variable v_pltbutils_err_cnt_in_test : pltbutils_p_integer_t;
  shared variable v_pltbutils_stop_sim  : pltbutils_p_std_logic_t;
  -- VHDL-1993:
  --shared variable v_pltbutils_testcase_name : string(1 to C_PLTBUTILS_STRLEN) := (others => ' ');
  --shared variable v_pltbutils_testcase_name_len : integer := 1;
  --shared variable v_pltbutils_test_num  : natural := 0;
  --shared variable v_pltbutils_test_name : string(1 to C_PLTBUTILS_STRLEN) := (others => ' ');
  --shared variable v_pltbutils_test_name_len : integer := 1;
  --shared variable v_pltbutils_info      : string(1 to C_PLTBUTILS_STRLEN) := (others => ' ');
  --shared variable v_pltbutils_info_len  : integer := 1;
  --shared variable v_pltbutils_test_cnt  : natural := 0;
  --shared variable v_pltbutils_chk_cnt   : natural := 0;
  --shared variable v_pltbutils_err_cnt   : natural := 0;
  --shared variable v_pltbutils_chk_cnt_in_test : natural := 0;
  --shared variable v_pltbutils_err_cnt_in_test : natural := 0;
  --shared variable v_pltbutils_stop_sim  : std_logic := '0';
  
  -- Global status- and control signal
  type pltbutils_sc_t is 
    record 
      test_num  : natural;
      test_name : string(1 to C_PLTBUTILS_STRLEN);
      info      : string(1 to C_PLTBUTILS_STRLEN);
      chk_cnt   : natural;
      err_cnt   : natural;
      stop_sim  : std_logic;
    end record;
  signal pltbutils_sc : pltbutils_sc_t;
 
  -- startsim 
  procedure startsim(
    constant testcase_name      : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  
  -- endsim
  procedure endsim(
    signal   pltbutils_sc        : out pltbutils_sc_t;
    constant show_success_fail   : in   boolean := false;
    constant force               : in boolean := false
  );
  
  -- starttest
  procedure starttest(
    constant num                : in    integer := -1;
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure starttest(
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );

  -- testname (depricated)
  procedure testname(
    constant num                : in    integer := -1;
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure testname(
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  
  -- endtest
  procedure endtest(
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );

  -- print, printv, print2
  procedure print(
    constant active             : in    boolean;
    signal   s                  : out   string;
    constant txt                : in    string
  );
  procedure print(
    signal   s                  : out   string;
    constant txt                : in    string
  );
  procedure printv(
    constant active             : in    boolean;
    variable s                  : out   string;
    constant txt                : in    string
  );
  procedure printv(
    variable s                  : out   string;
    constant txt                : in    string
  );
  procedure printv(
    constant active             : in    boolean;
    variable s                  : inout pltbutils_p_string_t;
    constant txt                : in    string
  );
  procedure printv(
    variable s                  : inout pltbutils_p_string_t;
    constant txt                : in    string
  );
  procedure print(
    constant active             : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  );
  procedure print(
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  );
  procedure print2(
    constant active             : in    boolean;
    signal   s                  : out   string;
    constant txt                : in    string
  );
  procedure print2(
    signal   s                  : out   string;
    constant txt                : in    string
  );
  procedure print2(
    constant active             : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  );
  procedure print2(
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  );

  -- waitclks
  procedure waitclks(
    constant N                  : in    natural;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  
  -- waitsig
  procedure waitsig(
    signal   s                  : in    integer;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    std_logic;
    constant value              : in    std_logic;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    std_logic;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );  
  procedure waitsig(
    signal   s                  : in    std_logic_vector;
    constant value              : in    std_logic_vector;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    std_logic_vector;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    unsigned;
    constant value              : in    unsigned;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );  
  procedure waitsig(
    signal   s                  : in    unsigned;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    signed;
    constant value              : in    signed;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );
  procedure waitsig(
    signal   s                  : in    signed;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  );  
  
  -- check
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    integer;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic;
    constant expected           : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    std_logic_vector;
    constant mask               : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    integer;
    constant mask               : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    unsigned;
    constant expected           : in    unsigned;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    unsigned;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    signed;
    constant expected           : in    signed;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    signed;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );  
  procedure check(
    constant rpt                : in    string;
    constant expr               : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
   procedure check(
    constant rpt                : in    string;
    constant expr               : in    boolean;
    constant actual             : in    string;
    constant expected           : in    string;
    constant mask               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );
  
  -- to_ascending
  function to_ascending(
    constant s                  : std_logic_vector
  ) return std_logic_vector;
  function to_ascending(
    constant s                  : unsigned
  ) return unsigned;
  function to_ascending(
    constant s                  : signed
  ) return signed;

  -- to_descending
  function to_descending(
    constant s                  : std_logic_vector
  ) return std_logic_vector;
  function to_descending(
    constant s                  : unsigned
  ) return unsigned;
  function to_descending(
    constant s                  : signed
  ) return signed;
  
  -- hxstr
  function hxstr(
    constant s                  : std_logic_vector;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string;
  function hxstr(
    constant s                  : unsigned;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string;
  function hxstr(
    constant s                  : signed;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string;

  -- pltbutils internal procedure(s), do not call from user's code
  procedure pltbutils_sc_update(
    signal pltbutils_sc : out pltbutils_sc_t
  );

  procedure startsim_msg(
    constant testcase_name      : in string;
    constant timestamp          : in time
  );
  
  procedure endsim_msg(
    constant testcase_name      : in string;
    constant timestamp          : in time;
    constant num_tests          : in integer;
    constant num_checks         : in integer;
    constant num_errors         : in integer;
    constant show_success_fail  : in boolean
  );
  
  procedure starttest_msg(
    constant test_num           : in integer;
    constant test_name          : in string;
    constant timestamp          : in time
  );
  
  procedure endtest_msg(
    constant test_num           : in integer;
    constant test_name          : in string;
    constant timestamp          : in time;
    constant num_checks_in_test : in integer;
    constant num_errors_in_test : in integer
  );  
  
  procedure check_msg(
    constant rpt                : in string;
    constant expr               : in boolean;    
    constant actual             : in string;
    constant expected           : in string;
    constant mask               : in string;
    constant test_num           : in integer;      
    constant test_name          : in string;
    constant check_num          : in integer;
    constant err_cnt_in_test    : in integer
  );
  
  procedure pltbutils_error(
    constant rpt                : in string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  );

  procedure error_msg(
    constant rpt                : in string;
    constant timestamp          : in time;
    constant test_num           : in integer;      
    constant test_name          : in string;
    constant err_cnt_in_test    : in integer
  );
  
  procedure stopsim(
    constant timestamp          : in time
  );
    
end package pltbutils_func_pkg;

package body pltbutils_func_pkg is

  ----------------------------------------------------------------------------
  -- startsim
  --
  -- procedure startsim(
  --   constant testcase_name      : in    string;
  --   signal   pltbutils_sc       : out   pltbutils_sc_t
  -- )
  --
  -- Displays a message at start of simulation message, and initializes
  -- PlTbUtils' global status and control signal.
  -- Call startsim() only once.
  --
  -- Arguments:
  --   testcase_name            Name of the test case, e.g. "tc1".
  --
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  -- NOTE:
  -- The start-of-simulation message is not only intended to be informative
  -- for humans. It is also intended to be searched for by scripts,
  -- e.g. for collecting results from a large number of regression tests.
  -- For this reason, the message must be consistent and unique.
  --
  -- DO NOT MODIFY the message "--- START OF SIMULATION ---".
  -- DO NOT OUTPUT AN IDENTICAL MESSAGE anywhere else.
  --
  -- Example:
  -- startsim("tc1", pltbutils_sc);
  ----------------------------------------------------------------------------
  procedure startsim(
    constant testcase_name      : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
    variable dummy : integer;
    variable timestamp : time;
  begin
    timestamp := now;
    if C_PLTBUTILS_USE_STD_STARTSIM_MSG then
      startsim_msg(testcase_name, timestamp);
    end if;
    if C_PLTBUTILS_USE_CUSTOM_STARTSIM_MSG then
      custom_startsim_msg(testcase_name, timestamp);
    end if;
    printv(v_pltbutils_info, testcase_name);
    -- VHDL-2002:
    v_pltbutils_testcase_name.set(testcase_name);
    v_pltbutils_testcase_name_len.set(testcase_name'length);
    v_pltbutils_stop_sim.clr;
    v_pltbutils_test_num.clr;
    v_pltbutils_test_name.set("START OF SIMULATION");
    v_pltbutils_test_name_len.set(19);
    v_pltbutils_chk_cnt.clr;
    v_pltbutils_err_cnt.clr;
    v_pltbutils_chk_cnt_in_test.clr;
    v_pltbutils_err_cnt_in_test.clr;
    pltbutils_sc_update(pltbutils_sc);
    -- VHDL-1993:
    --v_pltbutils_stop_sim := '0';
    --v_pltbutils_test_num := 0;
    --printv(v_pltbutils_test_name, "START OF SIMULATION");
    --v_pltbutils_test_name_len := 19;
    --v_pltbutils_chk_cnt := 0;
    --v_pltbutils_err_cnt := 0;
    --v_pltbutils_chk_cnt_in_test := 0;
    --v_pltbutils_err_cnt_in_test := 0;
    --pltbutils_sc_update(pltbutils_sc);
  end procedure startsim;

  ----------------------------------------------------------------------------
  -- endsim
  --
  -- procedure endsim(
  --   signal   pltbutils_sc       : out pltbutils_sc_t;
  --   constant show_success_fail  : in  boolean := false;
  --   constant force              : in  boolean := false
  -- )
  --
  -- Displays a message at end of simulation message, presents the simulation
  -- results, and stops the simulation. 
  -- Call endsim() it only once.
  --
  -- Arguments: 
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  --   show_success_fail        If true, endsim() shows "*** SUCCESS ***", 
  --                            "*** FAIL ***", or "*** NO CHECKS ***".
  --                            Optional, default is false.
  --
  --   force                    If true, forces the simulation to stop using an
  --                            assert failure statement. Use this option only
  --                            if the normal way of stopping the simulation
  --                            doesn't work (see below).
  --                            Optional, default is false.
  --
  -- The testbench should be designed so that all clocks stop when endsim()
  -- sets the signal stop_sim to '1'. This should stop the simulator.
  -- In some cases, that doesn't work, then set the force argument to true, which
  -- causes a false assert failure, which should stop the simulator.
  -- Scripts searching transcript logs for errors and failures, should ignore
  -- the failure with "--- FORCE END OF SIMULATION ---" as part of the report.
  --
  -- NOTE:
  -- The end-of-simulation messages and success/fail messages are not only
  -- intended to be informative for humans. They are also intended to be
  -- searched for by scripts, e.g. for collecting results from a large number
  -- of regression tests.
  -- For this reason, the message must be consistent and unique.
  --
  -- DO NOT MODIFY the messages "--- END OF SIMULATION ---", 
  -- "*** SUCCESS ***", "*** FAIL ***", "*** NO CHECKS ***".
  -- DO NOT OUTPUT IDENTICAL MESSAGES anywhere else.
  --
  -- Examples:
  -- endsim(pltbutils_sc);
  -- endsim(pltbutils_sc, true);
  -- endsim(pltbutils_sc, true, true);
  ----------------------------------------------------------------------------
  procedure endsim(
    signal   pltbutils_sc       : out pltbutils_sc_t;
    constant show_success_fail  : in  boolean := false;
    constant force              : in  boolean := false
  ) is
    variable timestamp : time;
    variable name_len  : integer;
  begin
    timestamp := now;
    name_len := v_pltbutils_testcase_name_len.value; -- VHDL-2002
    --name_len : v_pltbutils_sc_testcase_name_len; -- VHDL-1993
    if C_PLTBUTILS_USE_STD_ENDSIM_MSG then
      -- VHDL-2002:
      endsim_msg(v_pltbutils_testcase_name.value(1 to name_len),
        timestamp, v_pltbutils_test_cnt.value, v_pltbutils_chk_cnt.value,
        v_pltbutils_err_cnt.value, show_success_fail);
      -- VHDL-1993:
      --endsim_msg(v_pltbutils_testcase_name(1 to name_len),
      --  timestamp, v_pltbutils_test_cnt, v_pltbutils_chk_cnt,
      --  v_pltbutils_err_cnt, show_success_fail);
    end if;
    if C_PLTBUTILS_USE_CUSTOM_ENDSIM_MSG then
      -- VHDL-2002:
      custom_endsim_msg(v_pltbutils_testcase_name.value(1 to name_len),
        timestamp, v_pltbutils_test_cnt.value, v_pltbutils_chk_cnt.value,
        v_pltbutils_err_cnt.value, show_success_fail);
      -- VHDL-1993:
      --custom_endsim_msg(v_pltbutils_testcase_name(1 to name_len),
      --  timestamp, v_pltbutils_test_cnt, v_pltbutils_chk_cnt,
      --  v_pltbutils_err_cnt, show_success_fail);
    end if;
    printv(v_pltbutils_info, "");
    -- VHDL-2002:
    v_pltbutils_stop_sim.set('1');
    v_pltbutils_test_num.clr;
    v_pltbutils_test_name.set("END OF SIMULATION");
    v_pltbutils_test_name_len.set(17);
    -- VHDL-1993:
    --v_pltbutils_stop_sim := '1';
    --v_pltbutils_test_num := 0;
    --printv(v_pltbutils_test_name, "END OF SIMULATION");
    --v_pltbutils_test_name_len := 17;
    pltbutils_sc_update(pltbutils_sc);
    wait for C_WAIT_BEFORE_STOP_TIME;
    if force then
      if C_PLTBUTILS_USE_STD_STOPSIM then
        stopsim(now);
      end if;
      if C_PLTBUTILS_USE_CUSTOM_STOPSIM then
        custom_stopsim(now);
      end if;
    end if;
    wait;
  end procedure endsim;

  ----------------------------------------------------------------------------
  -- starttest
  --
  -- procedure starttest(
  --   constant num                : in    integer := -1;
  --   constant name               : in    string;
  --   signal   pltbutils_sc       : out   pltbutils_sc_t
  -- ) 
  --
  -- Sets a number (optional) and a name for a test. The number and name will
  -- be printed to the screen, and displayed in the simulator's waveform
  -- window. 
  -- The test number and name is also included if there errors reported by the
  -- check() procedure calls.
  --
  -- Arguments: 
  --   num                      Test number. Optional, default is to increment
  --                            the current test number.
  --
  --   name                     Test name.
  --
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  -- If the test number is omitted, a new test number is automatically
  -- computed by incrementing the current test number. 
  -- Manually setting the test number may make it easier to find the test code
  -- in the testbench code, though.
  --
  -- Examples:
  -- starttest("Reset test", pltbutils_sc);
  -- starttest(1, "Reset test", pltbutils_sc);
  ----------------------------------------------------------------------------
  procedure starttest(
    constant num                : in    integer := -1;
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
    variable timestamp : time;
  begin
    timestamp := now;
    -- VHDL-2002:
    if num = -1 then
      v_pltbutils_test_num.inc;
    else
      v_pltbutils_test_num.set(num);
    end if;
    v_pltbutils_test_cnt.inc;
    v_pltbutils_test_name.set(name);
    v_pltbutils_test_name_len.set(name'length);
    v_pltbutils_err_cnt_in_test.clr;
    pltbutils_sc_update(pltbutils_sc);
    if C_PLTBUTILS_USE_STD_STARTTEST_MSG then
      starttest_msg(v_pltbutils_test_num.value, name, timestamp);
    end if;
    if C_PLTBUTILS_USE_CUSTOM_STARTTEST_MSG then
      custom_starttest_msg(v_pltbutils_test_num.value, name, timestamp);
    end if;
    
    -- VHDL-1993:
    --if num = -1 then
    --  b_pltbutils_test_num := v_pltbutils_test_num + 1;
    --else
    --  v_pltbutils_test_num  := num;
    --end if;
    --v_pltbutils_test_cnt := v_pltbutils_test_cnt + 1;
    --printv(v_pltbutils_test_name, name);
    --v_pltbutils_test_name_len := name'length;
    --v_pltbutils_err_cnt_in_test := 0;
    --pltbutils_sc_update(pltbutils_sc);
    --if C_PLTBUTILS_USE_STD_STARTTEST_MSG then
    --  starttest_msg(v_pltbutils_test_num, name, timestamp);
    --end if;
    --if C_PLTBUTILS_USE_CUSTOM_STARTTEST_MSG then
    --  custom_starttest_msg(v_pltbutils_test_num, name, timestamp);
    --end if;
  end procedure starttest;
  
  procedure starttest(
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    starttest(-1, name, pltbutils_sc);
  end procedure starttest;
  
  -- Depricated. Will be removed. Use starttest() instead.
  procedure testname(
    constant num                : in    integer := -1;
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    starttest(num, name, pltbutils_sc);
  end procedure testname;
  
  -- Depricated. Will be removed. Use starttest() instead.
  procedure testname(
    constant name               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    testname(-1, name, pltbutils_sc);
  end procedure testname;
  
  ----------------------------------------------------------------------------
  -- endtest
  --
  -- procedure endtest(
  --   signal   pltbutils_sc       : out   pltbutils_sc_t
  -- ) 
  --
  -- Prints an end-of-test message to the screen.
  --
  -- Arguments: 
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  -- Example:
  -- endtest(pltbutils_sc);
  ----------------------------------------------------------------------------
  procedure endtest(
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
    variable timestamp : time;
    variable v_name_len : integer;
  begin
    timestamp := now;
    -- Uncommented for VHDL-2002 Protected types, otherwise commented:
    v_name_len := v_pltbutils_test_name_len.value; -- VHDL-2002
    if C_PLTBUTILS_USE_STD_ENDTEST_MSG then
      endtest_msg(v_pltbutils_test_num.value, v_pltbutils_test_name.value(1 to v_name_len),
        timestamp, v_pltbutils_chk_cnt_in_test.value, v_pltbutils_err_cnt_in_test.value);
    end if;  
    if C_PLTBUTILS_USE_CUSTOM_ENDTEST_MSG then
      custom_endtest_msg(v_pltbutils_test_num.value, v_pltbutils_test_name.value(1 to v_name_len),
        timestamp, v_pltbutils_chk_cnt_in_test.value, v_pltbutils_err_cnt_in_test.value);
    end if;  
    -- Uncommented for not using VHDL-2002 Protected Types, otherwise commented:
    --name_len := v_pltbutils_test_name_len; -- VHDL-1993
    --if C_PLTBUTILS_USE_STD_ENDTEST_MSG then
    --  endtest_msg(v_pltbutils_test_num, v_pltbutils_test_name(1 to v_name_len),
    --    timestamp, v_pltbutils_chk_cnt_in_test, v_pltbutils_err_cnt_in_test);
    --end if;  
    --if C_PLTBUTILS_USE_CUSTOM_ENDTEST_MSG then
    --  custom_endtest_msg(v_pltbutils_test_num, v_pltbutils_test_name(1 to v_name_len),
    --    timestamp, v_pltbutils_chk_cnt_in_test, v_pltbutils_err_cnt_in_test);
    --end if;  

    printv(v_pltbutils_test_name, " ");
    pltbutils_sc_update(pltbutils_sc);
  end procedure endtest;
  
  ----------------------------------------------------------------------------
  -- print printv print2
  --
  -- procedure print(   
  --   signal   s                  : out   string;
  --   constant txt                : in    string
  -- ) 
  --
  -- procedure print(   
  --   constant active             : in    boolean;
  --   signal   s                  : out   string;
  --   constant txt                : in    string
  -- ) 
  --
  -- procedure print(
  --   signal   pltbutils_sc       : out   pltbutils_sc_t;
  --   constant txt                : in    string
  -- )
  --
  -- procedure print(
  --   constant active             : in    boolean;
  --   signal   pltbutils_sc       : out   pltbutils_sc_t;
  --   constant txt                : in    string
  -- )
  --
  -- procedure printv(
  --   variable s                  : out   string;
  --   constant txt                : in    string
  -- )
  --
  -- procedure printv(
  --   constant active             : in    boolean;
  --   variable s                  : out   string;
  --   constant txt                : in    string
  -- )
  --
  -- procedure print2(    
  --   signal   s                  : out   string;
  --   constant txt                : in    string
  -- )
  --
  -- procedure print2(    
  --   constant active             : in    boolean;
  --   signal   s                  : out   string;
  --   constant txt                : in    string
  -- )
  --
  -- procedure print2(    
  --   signal   pltbutils          : out   pltbutils_sc_t;
  --   constant txt                : in    string
  -- )
  --
  -- procedure print2(    
  --   constant active             : in    boolean;
  --   signal   pltbutils          : out   pltbutils_sc_t;
  --   constant txt                : in    string
  -- )
  --
  -- print() prints text messages to a signal for viewing in the simulator's
  -- waveform window. printv() does the same thing, but to a variable instead.
  -- print2() prints both to a signal and to the transcript window. 
  -- The type of the output can be string or pltbutils_sc_t.
  -- If the type is pltbutils_sc_t, the name can be no other than pltbutils_sc.
  --
  -- Arguments: 
  --   s                        Signal or variable of type string to be 
  --                            printed to.
  --
  --   txt                      The text.
  --
  --   active                   The text is only printed if active is true.
  --                            Useful for debug switches, etc.
  --
  --   pltbutils_sc             PlTbUtils' global status- and control signal 
  --                            of type pltbutils_sc_t. 
  --                            The name must be no other than pltbutils_sc.
  --
  -- If the string txt  is longer than the signal s, the text will be truncated.
  -- If txt  is shorter, s will be padded with spaces.
  --
  -- Examples:
  -- print(msg, "Hello, world"); -- Prints to signal msg
  -- print(G_DEBUG, msg, "Hello, world"); -- Prints to signal msg if 
  --                                      -- generic G_DEBUG is true
  -- printv(v_msg, "Hello, world"); -- Prints to variable msg
  -- print(pltbutils_sc, "Hello, world"); -- Prints to "info" in waveform window
  -- print2(msg, "Hello, world"); -- Prints to signal and transcript window 
  -- print(pltbutils_sc, "Hello, world"); -- Prints to "info" in waveform and
  --                                      -- transcript windows
  ----------------------------------------------------------------------------
  procedure print(
    constant active             : in    boolean;
    signal   s                  : out   string;
    constant txt                : in    string
  ) is
    variable j : positive := txt 'low;
  begin
    if active then
      for i in s'range loop
        if j <= txt 'high then
          s(i) <= txt (j);
        else
          s(i) <= ' ';
        end if;
        j := j + 1;
      end loop;
    end if;
  end procedure print;
  
  procedure print(
    signal   s                  : out   string;
    constant txt                : in    string
  ) is
  begin
    print(true, s, txt);
  end procedure print;
  
  procedure printv(
    constant active             : in    boolean;
    variable s                  : out   string;
    constant txt                : in    string
  ) is
    variable j : positive := txt 'low;
  begin
    if active then
      for i in s'range loop
        if j <= txt 'high then
          s(i) := txt (j);
        else
          s(i) := ' ';
        end if;
        j := j + 1;
      end loop;
    end if;
  end procedure printv;
  
  procedure printv(
    variable s                  : out   string;
    constant txt                : in    string
  ) is
  begin
    printv(true, s, txt);
  end procedure printv;  
  
  -- VHDL-2002:
  procedure printv(
    constant active             : in    boolean;
    variable s                  : inout pltbutils_p_string_t;
    constant txt                : in    string
  ) is
    variable j : positive := txt 'low;
  begin
    if active then
      s.set(txt);
    end if;
  end procedure printv;
  
  procedure printv(
    variable s                  : inout pltbutils_p_string_t;
    constant txt                : in    string
  ) is
  begin
    printv(true, s, txt);
  end procedure printv;  

  -- Print to info element in pltbutils_sc, which shows up in waveform window
  procedure print(
    constant active             : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  ) is
    variable j : positive := txt 'low;
  begin
    if active then
      printv(v_pltbutils_info, txt );
      pltbutils_sc_update(pltbutils_sc);
    end if;
  end procedure print;

  procedure print(
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  ) is
  begin
    print(true, pltbutils_sc, txt);
  end procedure print;  
  
  procedure print2(
    constant active             : in    boolean;
    signal   s                  : out   string;
    constant txt                : in    string
  ) is
  begin
    if active then 
      print(s, txt );
      print(txt);
    end if;
  end procedure print2;

  procedure print2(
    signal   s                  : out   string;
    constant txt                : in    string
  ) is
  begin
    print(true, s, txt);
  end procedure print2;  
  
  procedure print2(
    constant active             : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  ) is
  begin
    print(pltbutils_sc, txt );
    print(txt);
  end procedure print2;

  procedure print2(
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant txt                : in    string
  ) is
  begin
    print(true, pltbutils_sc, txt);
  end procedure print2;  

  ----------------------------------------------------------------------------
  -- waitclks
  --
  -- procedure waitclks(
  --   constant n                  : in    natural;
  --   signal   clk                : in    std_logic;
  --   signal   pltbutils_sc       : out   pltbutils_sc_t;
  --   constant falling            : in    boolean := false;
  --   constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  -- )
  --
  -- Waits specified amount of clock cycles of the specified clock.
  -- Or, to be more precise, a specified number of specified clock edges of
  -- the specified clock.
  --
  -- Arguments: 
  --   n                        Number of rising or falling clock edges to wait.
  --
  --   clk                      The clock to wait for.
  --
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  --   falling                  If true, waits for falling edges, otherwise
  --                            rising edges. Optional, default is false.
  --
  --   timeout                  Timeout time, in case the clock is not working.
  --                            Optional, default is C_PLTBUTILS_TIMEOUT.  
  --
  -- Examples:
  -- waitclks(5, sys_clk, pltbutils_sc);
  -- waitclks(5, sys_clk, pltbutils_sc, true);
  -- waitclks(5, sys_clk, pltbutils_sc, true, 1 ms);
  ----------------------------------------------------------------------------
  procedure waitclks(
    constant n                  : in    natural;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable i                  : natural := n;
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    while i > 0 loop
      if falling then
        wait until falling_edge(clk) for timeout / n;
      else
        wait until rising_edge(clk)  for timeout / n;
      end if;
      i := i - 1;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitclks() timeout", pltbutils_sc);
    end if;
  end procedure waitclks;
    
  ----------------------------------------------------------------------------
  -- waitsig
  --
  -- procedure waitsig(
  --   signal   s                  : in    integer|std_logic|std_logic_vector|unsigned|signed;
  --   constant value              : in    integer|std_logic|std_logic_vector|unsigned|signed;
  --   signal   clk                : in    std_logic;
  --   signal   pltbutils_sc       : out   pltbutils_sc_t;
  --   constant falling            : in    boolean := false;
  --   constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  -- )
  --
  -- Waits until a signal has reached a specified value after specified clock
  -- edge.
  --
  -- Arguments: 
  --   s                        The signal to test.
  --                            Supported types: integer, std_logic, 
  --                            std_logic_vector, unsigned, signed.
  --
  --   value                    Value to wait for.
  --                            Same type as data or integer.
  --
  --   clk                      The clock.
  --
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to pltbutils_sc.
  --
  --   falling                  If true, waits for falling edges, otherwise
  --                            rising edges. Optional, default is false.
  --
  --   timeout                  Timeout time, in case the clock is not working.
  --                            Optional, default is C_PLTBUTILS_TIMEOUT.  
  --
  -- Examples:
  -- waitsig(wr_en, '1', sys_clk, pltbutils_sc);
  -- waitsig(rd_en,   1, sys_clk, pltbutils_sc, true);
  -- waitclks(full, '1', sys_clk, pltbutils_sc, true, 1 ms);
  ---------------------------------------------------------------------------- 
  procedure waitsig(
    signal   s                  : in    integer;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    l1 : loop
      waitclks(1, clk, pltbutils_sc, falling, timeout); 
      exit l1 when s = value or now >= v_timeout_time;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;

  procedure waitsig(
    signal   s                  : in    std_logic;
    constant value              : in    std_logic;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    l1 : loop
      waitclks(1, clk, pltbutils_sc, falling, timeout); 
      exit l1 when s = value or now >= v_timeout_time;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;
  
  procedure waitsig(
    signal   s                  : in    std_logic;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_value            : std_logic;
    variable v_timeout_time     : time;
  begin
    case value is
      when 0      => v_value := '0';
      when 1      => v_value := '1';
      when others => v_value := 'X';
    end case;
    if v_value /= 'X' then
      waitsig(s, v_value, clk, 
              pltbutils_sc, falling, timeout);
    else
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;  
  
  procedure waitsig(
    signal   s                  : in    std_logic_vector;
    constant value              : in    std_logic_vector;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    l1 : loop
      waitclks(1, clk, pltbutils_sc, falling, timeout); 
      exit l1 when s = value or now >= v_timeout_time;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;  

  procedure waitsig(
    signal   s                  : in    std_logic_vector;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    waitsig(s, std_logic_vector(to_unsigned(value, s'length)), clk, 
            pltbutils_sc, falling, timeout);
  end procedure waitsig;  
  
  procedure waitsig(
    signal   s                  : in    unsigned;
    constant value              : in    unsigned;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    l1 : loop
      waitclks(1, clk, pltbutils_sc, falling, timeout); 
      exit l1 when s = value or now >= v_timeout_time;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;  
  
  procedure waitsig(
    signal   s                  : in    unsigned;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    waitsig(s, to_unsigned(value, s'length), clk, 
            pltbutils_sc, falling, timeout);
  end procedure waitsig;  
 
  procedure waitsig(
    signal   s                  : in    signed;
    constant value              : in    signed;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    v_timeout_time := now + timeout;
    l1 : loop
      waitclks(1, clk, pltbutils_sc, falling, timeout); 
      exit l1 when s = value or now >= v_timeout_time;
    end loop;
    if now >= v_timeout_time then
      pltbutils_error("waitsig() timeout", pltbutils_sc);
    end if;
  end procedure waitsig;  

  procedure waitsig(
    signal   s                  : in    signed;
    constant value              : in    integer;
    signal   clk                : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t;
    constant falling            : in    boolean := false;
    constant timeout            : in    time    := C_PLTBUTILS_TIMEOUT
  ) is
    variable v_timeout_time     : time;
  begin
    waitsig(s, to_signed(value, s'length), clk, 
            pltbutils_sc, falling, timeout);
  end procedure waitsig;  
 
  ----------------------------------------------------------------------------
  -- check
  --
  -- procedure check(
  --  constant rpt              : in    string;
  --  constant actual           : in    integer|std_logic|std_logic_vector|unsigned|signed;
  --  constant expected         : in    integer|std_logic|std_logic_vector|unsigned|signed;
  --  signal   pltbutils_sc     : out   pltbutils_sc_t
  --  )
  --
  -- procedure check(
  --  constant rpt              : in    string;
  --  constant actual           : in    std_logic_vector;
  --  constant expected         : in    std_logic_vector;
  --  constant mask             : in    std_logic_vector;
  --  signal   pltbutils_sc     : out   pltbutils_sc_t
  --  )
  --
  -- procedure check(
  --   constant rpt            : in    string;
  --   constant expr           : in    boolean;
  --   signal   pltbutils_sc   : out   pltbutils_sc_t
  -- )
  --
  -- Checks that the value of a signal or variable is equal to expected.
  -- If not equal, displays an error message and increments the error counter.
  --
  -- Arguments: 
  --   rpt                      Report message to be displayed in case of 
  --                            mismatch. 
  --                            It is recommended that the message is unique
  --                            and that it contains the name of the signal
  --                            or variable being checked. 
  --                            The message should NOT contain the expected 
  --                            value, becase check() prints that 
  --                            automatically.
  --
  --   actual                   The signal or variable to be checked.
  --                            Supported types: integer, std_logic, 
  --                            std_logic_vector, unsigned, signed.
  --
  --   expected                 Expected value. 
  --                            Same type as data or integer.
  --
  --   mask                     Bit mask and:ed to data and expected 
  --                            before comparison.
  --                            Optional if data is std_logic_vector.
  --                            Not allowed for other types.
  --
  --   expr                     boolean expression for checking.
  --                            This makes it possible to check any kind of
  --                            expresion, not just equality.
  -- 
  --   pltbutils_sc             PlTbUtils' global status- and control signal.
  --                            Must be set to the name pltbutils_sc.
  --
  -- Examples:
  -- check("dat_o after reset", dat_o, 0, pltbutils_sc);
  -- -- With mask:
  -- check("Status field in reg_o after start", reg_o, x"01", x"03", pltbutils_sc);
  -- -- Boolean expression:
  -- check("Counter after data burst", cnt_o > 10, pltbutils_sc);
  ----------------------------------------------------------------------------
  -- check integer
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    integer;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual = expected, str(actual), str(expected), "", pltbutils_sc);
  end procedure check;

  -- check std_logic
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic;
    constant expected           : in    std_logic;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual = expected, str(actual), str(expected), "", pltbutils_sc);
  end procedure check;
  
  -- check std_logic against integer
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
   -- variable v_expected : std_logic;
    --variable equal : boolean;   
  begin
    check(rpt, ((actual = '0' and expected = 0) or (actual = '1' and expected = 1)),
          str(actual), str(expected), "", pltbutils_sc);
  end procedure check;  
        
  -- check std_logic_vector
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual = expected, hxstr(actual, "0x"), hxstr(expected, "0x"), "", pltbutils_sc);
  end procedure check;
  
  -- check std_logic_vector with mask
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    std_logic_vector;
    constant mask               : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, (actual and mask) = (expected and mask),
          hxstr(actual, "0x"), hxstr(expected, "0x"), hxstr(mask, "0x"), pltbutils_sc);
  end procedure check;  
  
  -- check std_logic_vector against integer
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual, std_logic_vector(to_signed(expected, actual'length)), pltbutils_sc);
  end procedure check;

  -- check std_logic_vector with mask against integer
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    std_logic_vector;
    constant expected           : in    integer;
    constant mask               : in    std_logic_vector;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual, std_logic_vector(to_signed(expected, actual'length)), mask, pltbutils_sc);
  end procedure check;
  
  -- check unsigned
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    unsigned;
    constant expected           : in    unsigned;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual = expected, hxstr(actual, "0x"), hxstr(expected, "0x"), "", pltbutils_sc);
  end procedure check;
  
  -- check unsigned against integer
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    unsigned;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual, to_unsigned(expected, actual'length), pltbutils_sc);
  end procedure check;  
  
  -- check signed
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    signed;
    constant expected           : in    signed;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual = expected, hxstr(actual, "0x"), hxstr(expected, "0x"), "", pltbutils_sc);    
  end procedure check;
  
  -- check signed against integer
  -- TODO: find the bug reported by tb_pltbutils when expected  is negative (-1):
  --       ** Error: (vsim-86) numstd_conv_unsigned_nu: NATURAL arg value is negative (-1)
  procedure check(
    constant rpt                : in    string;
    constant actual             : in    signed;
    constant expected           : in    integer;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, actual, to_signed(expected, actual'length), pltbutils_sc);
  end procedure check;  
  
  -- check with boolean expression
  -- Check signal or variable with a boolean expression as argument C_EXPR.
  -- This allowes any kind of check.
  procedure check(
    constant rpt                : in    string;
    constant expr               : in    boolean;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    check(rpt, expr, "", "", "", pltbutils_sc);    
  end procedure check;  
  
  procedure check(
    constant rpt                : in    string;
    constant expr               : in    boolean;
    constant actual             : in    string;
    constant expected           : in    string;
    constant mask               : in    string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
    variable v_test_name_len    : integer := 1;
    variable actual_str         : string(1 to 32) := (others => ' ');
    variable actual_str_len     : integer := 1;
    variable expected_str       : string(1 to 32) := (others => ' ');
    variable expected_str_len   : integer := 1;
    variable mask_str           : string(1 to 32) := (others => ' ');
    variable mask_str_len       : integer := 1;
  begin
    v_pltbutils_chk_cnt.inc; -- VHDL-2002
    --v_pltbutils_chk_cnt := v_pltbutils_chk_cnt + 1; -- VHDL-1993
    if not expr then
      v_pltbutils_err_cnt.inc; -- VHDL-2002
      v_pltbutils_err_cnt_in_test.inc; -- VHDL-2002
      --v_pltbutils_err_cnt := v_pltbutils_err_cnt + 1; -- VHDL-1993
      --v_pltbutils_err_cnt_in_test := v_pltbutils_err_cnt_in_test + 1; -- VHDL-1993
    end if;
    v_test_name_len := v_pltbutils_test_name_len.value;
    if C_PLTBUTILS_USE_STD_CHECK_MSG then
      check_msg(rpt, expr, actual, expected, mask, v_pltbutils_test_num.value,
        v_pltbutils_test_name.value(1 to v_test_name_len), v_pltbutils_chk_cnt.value, 
        v_pltbutils_err_cnt_in_test.value); -- VHDL-2002
      --check_msg(rpt, actual, expected, mask, v_pltbutils_test_num,
      --  v_pltbutils_test_name(1 to v_test_name_len), v_pltbutils_chk_cnt,
      --  v_pltbutils_err_cnt_in_test); -- VHDL-2002
    end if;
    if C_PLTBUTILS_USE_CUSTOM_CHECK_MSG then
      -- VHDL-2002:
      custom_check_msg(rpt, expr, actual, expected, mask, v_pltbutils_test_num.value,
        v_pltbutils_test_name.value(1 to v_test_name_len), v_pltbutils_chk_cnt.value, 
        v_pltbutils_err_cnt_in_test.value);
      -- VHDL-1993:
      --custom_check_msg(rpt, actual, expected, mask, v_pltbutils_test_num,
      --  v_pltbutils_test_name(1 to v_test_name_len), v_pltbutils_chk_cnt,
      --  v_pltbutils_err_cnt_in_test);
    end if;
    pltbutils_sc_update(pltbutils_sc);
  end procedure check;
  
  ----------------------------------------------------------------------------
  -- to_ascending
  --
  -- function to_ascending(
  --  constant s                  : std_logic_vector
  -- ) return std_logic_vector;
  --
  -- function to_ascending(
  --  constant s                  : unsigned
  -- ) return unsigned
  --
  -- function to_ascending(
  --  constant s                  : signed
  -- ) return signed;
  --
  -- Converts a signal or variable to ascending range ("to-range").
  -- The argument s can have ascending or descending range.
  ----------------------------------------------------------------------------
  function to_ascending(
    constant s                  : std_logic_vector
  ) return std_logic_vector is
    variable r : std_logic_vector(s'low to s'high);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_ascending;

  function to_ascending(
    constant s                  : unsigned
  ) return unsigned is
    variable r : unsigned(s'low to s'high);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_ascending;

  function to_ascending(
    constant s                  : signed
  ) return signed is
    variable r : signed(s'low to s'high);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_ascending;

  ----------------------------------------------------------------------------
  -- to_descending
  --
  -- function to_descending(
  --  constant s                  : std_logic_vector
  -- ) return std_logic_vector;
  --
  -- function to_descending(
  --  constant s                  : unsigned
  -- ) return unsigned
  --
  -- function to_descending(
  --  constant s                  : signed
  -- ) return signed;
  --
  -- Converts a signal or variable to descending range ("downto-range").
  -- The argument s can have ascending or descending range.
  ----------------------------------------------------------------------------
  function to_descending(
    constant s                  : std_logic_vector
  ) return std_logic_vector is
    variable r : std_logic_vector(s'high downto s'low);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_descending;
  
  function to_descending(
    constant s                  : unsigned
  ) return unsigned is
    variable r : unsigned(s'high downto s'low);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_descending;

  function to_descending(
    constant s                  : signed
  ) return signed is
    variable r : signed(s'high downto s'low);
  begin
    for i in r'range loop
      r(i) := s(i);
    end loop;
    return r;
  end function to_descending;
  
  ----------------------------------------------------------------------------
  -- hxstr
  -- function hxstr(
  --  constant s                  : std_logic_vector;
  --  constant prefix             : string := "";
  --  constant postfix            : string := ""
  -- ) return string;
  --
  -- function hxstr(
  --  constant s                  : unsigned;
  --  constant prefix             : string := "";
  --  constant postfix            : string := ""
  -- ) return string;
  --
  -- function hxstr(
  --  constant s                  : signed;
  --  constant prefix             : string := "";
  --  constant postfix            : string := ""
  -- ) return string;
  --
  -- Converts a signal to a string in hexadecimal format.
  -- An optional prefix can be specified, e.g. "0x".
  --
  -- The signal can have ascending range ( "to-range" ) or descending range 
  -- ("downto-range").
  --
  -- hxstr is a wrapper function for hstr in txt_util.
  -- hstr only support std_logic_vector with descending range.
  --
  -- Examples:
  -- print("value=" & hxstr(s));
  -- print("value=" & hxstr(s, "0x"));
  ----------------------------------------------------------------------------
  function hxstr(
    constant s                  : std_logic_vector;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string is
  begin
    return prefix & hstr(to_descending(s)) & postfix;
  end function hxstr;
  
  function hxstr(
    constant s                  : unsigned;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string is
  begin
    return prefix & hstr(to_descending(std_logic_vector(s))) & postfix;
  end function hxstr;
  
  function hxstr(
    constant s                  : signed;
    constant prefix             : string := "";
    constant postfix            : string := ""
  ) return string is
  begin
    return prefix & hstr(to_descending(std_logic_vector(s))) & postfix;
  end function hxstr;
  
  ----------------------------------------------------------------------------
  -- pltbutils internal procedure(s), called from other pltbutils procedures.
  -- Do not to call this/these from user's code.
  -- This/these procedures are undocumented in the specification on purpose.
  ----------------------------------------------------------------------------
  procedure pltbutils_sc_update(
              signal pltbutils_sc : out pltbutils_sc_t
            ) is
  begin
    -- VHDL-2002:
    pltbutils_sc.test_num   <= v_pltbutils_test_num.value;
    print(pltbutils_sc.test_name, v_pltbutils_test_name.value);
    print(pltbutils_sc.info, v_pltbutils_info.value);
    pltbutils_sc.chk_cnt    <= v_pltbutils_chk_cnt.value;
    pltbutils_sc.err_cnt    <= v_pltbutils_err_cnt.value;
    pltbutils_sc.stop_sim   <= v_pltbutils_stop_sim.value;    
    -- VHDL-1993:
    --pltbutils_sc.test_num   <= v_pltbutils_test_num;
    --print(pltbutils_sc.test_name, v_pltbutils_test_name);
    --print(pltbutils_sc.info, v_pltbutils_info);
    --pltbutils_sc.chk_cnt    <= v_pltbutils_chk_cnt;
    --pltbutils_sc.err_cnt    <= v_pltbutils_err_cnt;
    --pltbutils_sc.stop_sim   <= v_pltbutils_stop_sim;
  end procedure pltbutils_sc_update;
  
  procedure startsim_msg(
    constant testcase_name      : in string;
    constant timestamp          : in time
  ) is
  begin
    print(lf & "--- START OF SIMULATION ---");
    print("Testcase: " & testcase_name);
    print(time'image(timestamp));
  end procedure startsim_msg;

  procedure endsim_msg(
    constant testcase_name      : in string;
    constant timestamp          : in time;
    constant num_tests          : in integer;
    constant num_checks         : in integer;
    constant num_errors         : in integer;
    constant show_success_fail  : in boolean
  ) is
    variable l : line;
  begin
    print(lf & "--- END OF SIMULATION ---");
    print("Note: the results presented below are based on the PlTbUtil's check() procedure calls."); 
    print("      The design may contain more errors, for which there are no check() calls.");
    write(l, timestamp, right, 14);
    writeline(output, l);
    write(l, num_tests, right, 11);
    write(l, string'(" Tests"));
    writeline(output, l);
    write(l, num_checks, right, 11);
    write(l, string'(" Checks"));
    writeline(output, l);
    write(l, num_errors, right, 11);
    write(l, string'(" Errors"));
    writeline(output, l);
    if show_success_fail then
      if num_errors = 0 and num_checks > 0 then
        print("*** SUCCESS ***");
      elsif num_checks > 0 then
        print("*** FAIL ***");
      else
        print("*** NO CHECKS ***");
      end if;
    end if;    
  end procedure endsim_msg;
  
  procedure starttest_msg(
    constant test_num           : in integer;
    constant test_name          : in string;
    constant timestamp          : in time
  ) is
  begin
    print(lf & "Test " & str(test_num) & ": " & test_name & " (" & time'image(timestamp) & ")");    
  end procedure starttest_msg;
  
  procedure endtest_msg(
    constant test_num           : in integer;
    constant test_name          : in string;
    constant timestamp          : in time;
    constant num_checks_in_test : in integer;
    constant num_errors_in_test : in integer
  ) is
  begin
    print("Done with test " & str(test_num) & ": " & test_name & " (" & time'image(timestamp) & ")");
  end procedure endtest_msg;
  
  procedure check_msg(
    constant rpt                : in string;
    constant expr               : in boolean;    
    constant actual             : in string;
    constant expected           : in string;
    constant mask               : in string;
    constant test_num           : in integer;      
    constant test_name          : in string;
    constant check_num          : in integer;
    constant err_cnt_in_test    : in integer
  ) is
    variable comparison_str     : string(1 to 32) := (others => ' ');
    variable comparison_str_len : integer := 1;
    variable actual_str         : string(1 to 32) := (others => ' ');
    variable actual_str_len     : integer := 1;
    variable expected_str       : string(1 to 32) := (others => ' ');
    variable expected_str_len   : integer := 1;
    variable mask_str           : string(1 to 32) := (others => ' ');
    variable mask_str_len       : integer := 1;
  begin
    if not expr then -- Output message only if the check fails
      if actual /= "" then
        actual_str_len := 8 + actual'length;
        actual_str(1 to actual_str_len) := " Actual=" & actual;
      end if;        
      if expected /= "" then
        expected_str_len := 10 + expected'length;
        expected_str(1 to expected_str_len) := " Expected=" & expected;
      end if;        
      if mask /= "" then
        mask_str_len := 6 + mask'length;
        mask_str(1 to mask_str_len) := " Mask=" & mask;
      end if;        
      assert false
        report "Check " & str(check_num) & "; " & rpt & "; " &
               actual_str(1 to actual_str_len) & 
               expected_str(1 to expected_str_len) &
               mask_str(1 to mask_str_len) &
               "  in test " & str(test_num) & " " & test_name
        severity error;
    end if;
  end procedure check_msg;  
  
  procedure pltbutils_error(
    constant rpt                : in string;
    signal   pltbutils_sc       : out   pltbutils_sc_t
  ) is
  begin
    -- VHDL-2002:
    v_pltbutils_err_cnt.inc;
    if C_PLTBUTILS_USE_STD_ERROR_MSG then
      error_msg(rpt, now, 
        v_pltbutils_test_num.value, 
        v_pltbutils_test_name.value(1 to v_pltbutils_test_name_len.value),
        v_pltbutils_err_cnt_in_test.value);
    end if;
    if C_PLTBUTILS_USE_CUSTOM_ERROR_MSG then
      custom_error_msg(rpt, now, 
        v_pltbutils_test_num.value, 
        v_pltbutils_test_name.value(1 to v_pltbutils_test_name_len.value),
        v_pltbutils_err_cnt_in_test.value);
    end if;
    -- VHDL-1993:
    --v_pltbutils_err_cnt := v_pltbutils_err_cnt + 1;
    --if C_PLTBUTILS_USE_STD_ERROR_MSG then
    --  error_msg(rpt, now, 
    --    v_pltbutils_test_num, 
    --    v_pltbutils_test_name(1 to v_pltbutils_test_name_len),
    --    v_pltbutils_err_cnt_in_test);
    --end if;
    --if C_PLTBUTILS_USE_CUSTOM_ERROR_MSG then
    --  custom_error_msg(rpt, now, 
    --    v_pltbutils_test_num, 
    --    v_pltbutils_test_name(1 to v_pltbutils_test_name_len),
    --    v_pltbutils_err_cnt_in_test);
    --end if;
    pltbutils_sc_update(pltbutils_sc);  
  end procedure pltbutils_error;
  
  procedure error_msg(
    constant rpt                : in string;
    constant timestamp          : in time;
    constant test_num           : in integer;      
    constant test_name          : in string;
    constant err_cnt_in_test    : in integer
  ) is
  begin
    assert false
    report rpt & " in test " & str(test_num) & ": " & test_name
    severity error;
  end procedure error_msg;
  
  procedure stopsim(
    constant timestamp          : in time
  ) is
  begin
    assert false
    report "--- FORCE END OF SIMULATION ---" &
           " (ignore this false failure message, it's not a real failure)"
    severity failure;    
  end procedure stopsim;  
    
end package body pltbutils_func_pkg;