----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Testbench                                          ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description                                                  ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This is a testbench file, which is used to verify            ----
---- - pltbutils_func_pkg                                         ----
---- - pltbutils_comp                                           ----
---- This testbench is NOT selfchecking or automatic.             ----
---- Manually check the transcript and waveform, when simulating. ----
---- It prints some informative text in the transcript, to help   ----
---- with the manual inspection.                                  ----
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
use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;

entity tb_pltbutils is
  generic (
    G_SKIPTESTS                 : std_logic_vector := (
                                    '0', -- Dummy
                                    '0', -- Test 1
                                    '0', -- Test 2
                                    '0', -- Test 3
                                    '0', -- Test 4: NonSkipTest 
                                    '1'  -- Test 5: SkipTest
                                  );
    G_CLK_PERIOD                : time := 10 ns;
    G_CHECKFILE_VERBOSITY       : integer := 10;
    G_BINTESTFILE_HEADER        : string := "Bintestfile R   ";
    G_BINTESTFILE_LEN           : integer := 528;
    G_BINTESTFILE_REFERENCE     : string := "../../../bench/testfiles/bintestfile_reference.bin";
    G_BINTESTFILE_CORRECT       : string := "../../../bench/testfiles/bintestfile_correct.bin";
    G_BINTESTFILE_ERROR         : string := "../../../bench/testfiles/bintestfile_error.bin";
    G_BINTESTFILE_SHORTER       : string := "../../../bench/testfiles/bintestfile_shorter.bin";
    G_BINTESTFILE_LONGER        : string := "../../../bench/testfiles/bintestfile_longer.txt";
    G_TEXTTESTFILE_REFERENCE    : string := "../../../bench/testfiles/texttestfile_reference.txt";
    G_TEXTTESTFILE_CORRECT      : string := "../../../bench/testfiles/texttestfile_correct.txt";
    G_TEXTTESTFILE_ERROR        : string := "../../../bench/testfiles/texttestfile_error.txt";
    G_TEXTTESTFILE_SHORTER      : string := "../../../bench/testfiles/texttestfile_shorter.txt";
    G_TEXTTESTFILE_LONGER       : string := "../../../bench/testfiles/texttestfile_longer.txt";
    G_DATTESTFILE_REFERENCE     : string := "../../../bench/testfiles/dattestfile_reference.dat";
    G_DATTESTFILE_CORRECT       : string := "../../../bench/testfiles/dattestfile_correct.dat";
    G_DATTESTFILE_ERROR         : string := "../../../bench/testfiles/dattestfile_error.dat";
    G_DATTESTFILE_SHORTER       : string := "../../../bench/testfiles/dattestfile_shorter.dat";
    G_DATTESTFILE_LONGER        : string := "../../../bench/testfiles/dattestfile_longer.dat"
  );
end entity tb_pltbutils;

architecture bhv of tb_pltbutils is

  -- Simulation status- and control signals
  -- for accessing .stop_sim and for viewing in waveform window
  signal pltbs          : pltbs_t := C_PLTBS_INIT;

  -- Expected number of checks and number of errors to be reported
  -- by pltbutils. The counting is made by variables, but the
  -- variables are copied to these signals for easier viewing in
  -- the simulator's waveform window.
  signal expected_checks_cnt : integer := 0;
  signal expected_errors_cnt : integer := 0;
  
  -- DUT stimuli and response signals
  signal clk            : std_logic;
  signal clk_cnt        : integer := 0;
  signal clk_cnt_clr    : boolean := false;
  signal s_i            : integer;
  signal s_sl           : std_logic;
  signal s_slv          : std_logic_vector(7 downto 0);
  signal s_u            : unsigned(7 downto 0);
  signal s_s            : unsigned(7 downto 0);
  signal s_b            : boolean;
  signal s_time         : time;
  signal s_str_exp      : string(1 to 44);
  signal s_str1         : string(1 to 44);    
  signal s_str2         : string(1 to 44);    
  signal s_str3         : string(1 to 43);    
  signal s_str4         : string(1 to 45);   


  constant C_EXPECTED_SUCCESS : boolean := false;
  constant C_EXPECTED_FAIL    : boolean := true;

  procedure check_cnt (
    constant C_EXPECT_FAIL    : boolean;
    variable v_checks_cnt   : inout integer;
    variable v_errors_cnt   : inout integer;
    signal   checks_cnt     : out   integer;
    signal   errors_cnt     : out   integer
  ) is
  begin
    v_checks_cnt := v_checks_cnt + 1;
    if C_EXPECT_FAIL then
      v_errors_cnt := v_errors_cnt + 1;
    end if;
    checks_cnt <= v_checks_cnt;
    errors_cnt <= v_errors_cnt;
  end procedure check_cnt;
  
begin
      
  -- Clock generator
  clkgen0 : pltbutils_clkgen
    generic map(
      G_PERIOD      => G_CLK_PERIOD
    )
    port map(
      clk_o         => clk,
      stop_sim_i    => pltbs.stop_sim
    );
    
  -- Clock cycle counter
  p_clk_cnt : process (clk_cnt_clr, clk)
  begin
    if clk_cnt_clr then
      clk_cnt <= 0;
    elsif rising_edge(clk) then
      clk_cnt <= clk_cnt + 1;
    end if;
  end process p_clk_cnt;
   
  -- Testcase
  p_tc1 : process
    variable pltbv                 : pltbv_t := C_PLTBV_INIT;
    variable v_expected_tests_cnt  : integer := 0;
    variable v_expected_skiptests_cnt : integer := 0;
    variable v_expected_checks_cnt : integer := 0;
    variable v_expected_errors_cnt : integer := 0;
    variable v_expected_data       : integer;
    variable v_actual_data         : integer;
    variable f_status              : file_open_status;
    file     txtfile               : text;
    type     charfile              is file of character;
    file     binfile               : charfile;
    variable l                     : line;
    variable c                     : character;
    variable i                     : integer;
    variable v_errcnt              : integer;
    variable msg                   : line;
    variable line_num              : integer := 0;
  begin
  
    print(lf & "<Testing startsim()>");
    startsim("tc1", G_SKIPTESTS, pltbv, pltbs);
    wait until rising_edge(clk);
    assert (pltbv.test_num = 0) and (pltbs.test_num  = 0)
      report "test_num after startsim() incorrect"
      severity error;
    print("<Done testing startsim()>");
   
    print(lf & "<Testing starttest() with auto-incrementing test_num>");   
    starttest("StartTest1", pltbv, pltbs);
    v_expected_tests_cnt := v_expected_tests_cnt + 1;    
    wait until rising_edge(clk);
    assert (pltbv.test_num = 1) and (pltbs.test_num  = 1)
      report "test_num after starttest() incorrect"
      severity error;
    print("<Done testing starttest() with auto-incrementing test_num()>");

    print(lf & "<Testing endtest()>");   
    endtest(pltbv, pltbs);    
    print("<Done testing endtest()>");

    print(lf & "<Testing starttest() with explicit test_num>");   
    starttest(3, "StartTest2", pltbv, pltbs);
    v_expected_tests_cnt := v_expected_tests_cnt + 1;        
    wait until rising_edge(clk);
    assert (pltbv.test_num = 3) and (pltbs.test_num  = 3)
      report "test_num after startsim() incorrect"
      severity error;
    print("<Done testing starttest() with explicit test_num>");

    print(lf & "<Testing starttest() and is_test_active() for non-skipped test>");   
    starttest(4, "NoSkipTest", pltbv, pltbs);
    if is_test_active(pltbv) then
      v_expected_tests_cnt := v_expected_tests_cnt + 1;        
      wait until rising_edge(clk);
    else 
      v_expected_skiptests_cnt := v_expected_skiptests_cnt + 1;
      wait until rising_edge(clk);
      assert false
        report "Executing test that should have been skipped"
        severity error;
    end if;
    endtest(pltbv, pltbs);
    print("<Done testing starttest() and is_test_active() for non-skipped test>");

    print(lf & "<Testing starttest() and is_test_active() for skipped test>");   
    starttest(5, "SkipTest", pltbv, pltbs);
    if is_test_active(pltbv) then
      v_expected_tests_cnt := v_expected_tests_cnt + 1;
      wait until rising_edge(clk);
      assert false
        report "Executing test that should have been skipped"
        severity error;
    else 
      --check("Checking if check() detects that it should not be called in skipped test", false, pltbv, pltbs);
      v_expected_skiptests_cnt := v_expected_skiptests_cnt + 1;
    end if;
    endtest(pltbv, pltbs);
    print("<Done testing starttest() and is_test_active() for skipped test>");
    
    print(lf & "<Testing waitclks()>"); 
    clk_cnt_clr <= true;
    wait until rising_edge(clk);
    clk_cnt_clr <= false;
    wait until rising_edge(clk);
    waitclks(10, clk, pltbv, pltbs);   
    assert clk_cnt = 10
      report "clk_cnt after waitclks() incorrect:" & integer'image(clk_cnt) &
             " expected:" & integer'image(10)
      severity error;
    print("<Done testing waitclks()>");

    print(lf & "<Testing check() integer>");
    s_i <= 0;    
    wait until rising_edge(clk);
    check("Testing correct integer = 0", s_i, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_i <= 1;    
    wait until rising_edge(clk);
    check("Testing correct integer = 1", s_i, 1, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_i <= 17;    
    wait until rising_edge(clk);
    check("Testing incorrect integer = 17", s_i, 18, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_i <= -1;    
    wait until rising_edge(clk);
    check("Testing negative integer = -1", s_i, -1, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() integer>");
    
    print(lf & "<Testing check() std_logic>");
    s_sl <= '0';    
    wait until rising_edge(clk);
    check("Testing correct std_logic = '0'", s_sl, '0', pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_sl <= '1';    
    wait until rising_edge(clk);
    check("Testing correct std_logic = '1'", s_sl, '1', pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_sl <= 'X';    
    wait until rising_edge(clk);
    check("Testing incorrect std_logic = '1'", s_sl, '1', pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic>");
    
    print(lf & "<Testing check() std_logic against integer>");
    s_sl <= '0';    
    wait until rising_edge(clk);
    check("Testing correct std_logic = '0'", s_sl, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_sl <= '1';    
    wait until rising_edge(clk);
    check("Testing correct std_logic = '1'", s_sl, 1, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_sl <= 'X';    
    wait until rising_edge(clk);
    check("Testing incorrect std_logic = '1'", s_sl, 1, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_sl <= '1';    
    wait until rising_edge(clk);
    check("Testing std_logic = '1' with incorrect expected", s_sl, 2, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic against integer>");
    
    print(lf & "<Testing check() std_logic_vector>");
    s_slv <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct std_logic_vector = x'00'", s_slv, x"00", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct std_logic_vector = x'47'", s_slv, x"47", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect std_logic_vector = x'11'", s_slv, x"10", pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic_vector>");

    print(lf & "<Testing check() std_logic_vector with mask>");
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing std_logic_vector = x'47' with correct nibble mask", s_slv, x"57", x"0F", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing std_logic_vector = x'47' with incorrect nibble mask", s_slv, x"57", x"F0", pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic_vector with mask>");
        
    print(lf & "<Testing check() std_logic_vector against integer>");
    s_slv <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct std_logic_vector = x'00'", s_slv, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct std_logic_vector = x'47'", s_slv, 16#47#, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect std_logic_vector = x'11'", s_slv, 16#10#, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"FF";    
    wait until rising_edge(clk);
    check("Testing negative std_logic_vector = x'FF'", s_slv, -1, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic_vector against integer>");

    print(lf & "<Testing check() std_logic_vector with mask against integer>");
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing std_logic_vector = x'47' with correct nibble mask", s_slv, 16#57#, x"0F", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_slv <= x"47";    
    wait until rising_edge(clk);
    check("Testing std_logic_vector = x'47' with incorrect nibble mask", s_slv, 16#57#, x"F0", pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() std_logic_vector with mask against integer>");    
    
    print(lf & "<Testing check() unsigned>");
    s_u <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct unsigned = x'00'", s_u, x"00", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_u <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct unsigned = x'47'", s_u, x"47", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_u <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect unsigned = x'11'", s_u, x"10", pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() unsigned>");
        
    print(lf & "<Testing check() unsigned against integer>");
    s_u <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct unsigned = x'00'", s_u, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_u <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct unsigned = x'47'", s_u, 16#47#, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_u <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect unsigned = x'11'", s_u, 16#10#, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() unsigned against integer>");
    
    print(lf & "<Testing check() signed>");
    s_s <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct signed = x'00'", s_s, x"00", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct signed = x'47'", s_s, x"47", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect signed = x'11'", s_s, x"10", pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"FF";    
    wait until rising_edge(clk);
    check("Testing negative signed = x'FF'", s_s, x"FF", pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);    
    print("<Done testing check() signed>");
        
    print(lf & "<Testing check() signed against integer>");
    s_s <= x"00";    
    wait until rising_edge(clk);
    check("Testing correct signed = x'00'", s_s, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"47";    
    wait until rising_edge(clk);
    check("Testing correct signed = x'47'", s_s, 16#47#, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"11";    
    wait until rising_edge(clk);
    check("Testing incorrect signed = x'11'", s_s, 16#10#, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"FF";    
    wait until rising_edge(clk);
    print("NOTE: Skipping test with negative signed. There seem to be a bug in ModelSim.");
    --print("The following check fails in ModelSim for unknown reason." &
    --      " It causes mismatch between expected number of errors" &
    --      " and the number presented by endsim()");
    --check("Testing negative signed = x'FF'", s_s, -1, pltbv, pltbs);
    --check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);    
    print("<Done testing check() signed against integer>");    

    print(lf & "<Testing check() boolean>");
    s_b <= false;    
    wait until rising_edge(clk);
    check("Testing correct boolean = false", s_b, false, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_b <= true;    
    wait until rising_edge(clk);
    check("Testing correct boolean = true", s_b, true, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_b <= false;    
    wait until rising_edge(clk);
    check("Testing incorrect boolean = true", s_b, true, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() boolean>");
    
    print(lf & "<Testing check() boolean against integer>");
    s_b <= false;    
    wait until rising_edge(clk);
    check("Testing correct boolean = false", s_b, 0, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_b <= true;    
    wait until rising_edge(clk);
    check("Testing correct boolean = true", s_b, 1, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_b <= false;    
    wait until rising_edge(clk);
    check("Testing incorrect boolean = true", s_b, 1, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_b <= true;    
    wait until rising_edge(clk);
    check("Testing boolean = true with incorrect expected", s_b, 2, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() boolean against integer>");

    print(lf & "<Testing check() time>");
    s_time <= 0 sec;    
    wait until rising_edge(clk);
    check("Testing correct time = 0 sec", s_time, 0 sec, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_time <= 47 ns;    
    wait until rising_edge(clk);
    check("Testing correct time = 47 ns", s_time, 47 ns, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_time <= 11 us;    
    wait until rising_edge(clk);
    check("Testing incorrect time = 10 us", s_time, 10 us, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() time>");
        
    print(lf & "<Testing check() time with tolerance>");
    s_time <= 0 sec;    
    wait until rising_edge(clk);
    check("Testing correct unsigned = 0 sec +/- 0 sec", s_time, 0 sec, 0 sec, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_time <= 47 ns - 3 ns;    
    wait until rising_edge(clk);
    check("Testing correct time = 47 ns +/- 5 ns", s_time, 47 ns, 5 ns, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_time <= 10 us + 7 us;    
    wait until rising_edge(clk);
    check("Testing incorrect time = 10 us +/- 5 us", s_time, 10 us, 5 us, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() time with tolerance>");

    print(lf & "<Testing check() string>");
    s_str_exp   <= string'("The quick brown fox jumps over the lazy dog.");
    s_str1      <= string'("The quick brown fox jumps over the lazy dog.");    
    s_str2      <= string'("The quick brown dog jumps over the lazy fox.");    
    s_str3      <= string'("The quick brown fox jumps over the lazy dog");    
    s_str4      <= string'("The quick brown fox jumps over the lazy dog..");    
    wait until rising_edge(clk);
    check("Testing correct string", s_str1, s_str_exp, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"47";    
    wait until rising_edge(clk);
    check("Testing incorrect string with correct length", s_str2, s_str_exp, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_s <= x"11";    
    wait until rising_edge(clk);
    check("Testing too short string", s_str3, s_str_exp, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    wait until rising_edge(clk);
    check("Testing too long string", s_str4, s_str_exp, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() string>");
    
    print(lf & "<Testing check() boolean expression>");
    s_i <= 0;    
    wait until rising_edge(clk);
    check("Testing correct boolean expression 0 = 16#00#", s_i = 16#00#, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    s_i <= 47;    
    wait until rising_edge(clk);
    check("Testing incorrect boolean expression 47 < 16#10#", s_i < 16#10#, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check() boolean expresson>");

    print(lf & "<Test readline() behaviour of the current simulator>");
    print("Some simulators seem to handle CR and LF differently from others.");
    file_open(f_status, txtfile, G_TEXTTESTFILE_REFERENCE, read_mode);
    print("DEBUG: file_open_status: " & file_open_status'image(f_status));
    if f_status /= open_ok then
      print("Failed to open " & G_TEXTTESTFILE_REFERENCE & " for reading: " & file_open_status'image(f_status));
    else
      while not endfile(txtfile) loop
        readline(txtfile, l);
        line_num := line_num + 1;
        write(msg, "Line " & str(line_num) & ": " & str(l'length) & " characters: ");
        for i in l'range loop
          write(msg, character'pos(l(i)));
          write(msg, string'(" "));
        end loop;
        writeline(output, msg);
      end loop;
    end if;
    print("<Done testing readline() behaviour>");

    print(lf & "<Test reading binary files>");
    -- Check if the current simulator running on the current operating system supports
    -- reading binary files as file of character.
    -- That is a requirement for check_binfile().
    file_open(f_status, binfile, G_BINTESTFILE_REFERENCE, read_mode);
    print("DEBUG: file_open_status: " & file_open_status'image(f_status));
    --check("Status of opening binary file", f_status = open_ok, file_open_status'image(f_status), "open_ok", pltbv, pltbs);
    --check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    if f_status = open_ok then
      i := 0;
      v_errcnt := 0;
      while not endfile(binfile) loop
        read(binfile, c);
        v_actual_data := character'pos(c);
        if i < G_BINTESTFILE_HEADER'length then
          v_expected_data := character'pos(G_BINTESTFILE_HEADER(i+1));
        else 
          v_expected_data := (i - G_BINTESTFILE_HEADER'length) mod 256;
        end if;
        if v_actual_data /= v_expected_data then
          v_errcnt := v_errcnt + 1;
          print("Error at offset " & str(i) & ": actual " & str(v_actual_data) & " expected " & str(v_expected_data));
        end if;
        i := i + 1;
      end loop;
      file_close(binfile);
      check("Number of errors while reading binary file", v_errcnt, 0, pltbv, pltbs);
      check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
      check("Number of bytes read from binary file", i, G_BINTESTFILE_LEN, pltbv, pltbs);
      check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    end if;
    print("<Done testing reading binary files>");

    print(lf & "<Testing check_binfile()");
    check_binfile("Testing correct binary file", G_BINTESTFILE_CORRECT, G_BINTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_binfile("Testing binary file with error", G_BINTESTFILE_ERROR, G_BINTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_binfile("Testing shorter binary file", G_BINTESTFILE_SHORTER, G_BINTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_binfile("Testing longer binary file", G_BINTESTFILE_LONGER, G_BINTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check_binfile()");

    print(lf & "<Testing check_txtfile()");
    check_txtfile("Testing correct text file", G_TEXTTESTFILE_CORRECT, G_TEXTTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_txtfile("Testing text file with error", G_TEXTTESTFILE_ERROR, G_TEXTTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_txtfile("Testing shorter text file", G_TEXTTESTFILE_SHORTER, G_TEXTTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_txtfile("Testing longer text file", G_TEXTTESTFILE_LONGER, G_TEXTTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check_txtfile()");

    print(lf & "<Testing check_datfile()");
    check_datfile("Testing correct data file", G_DATTESTFILE_CORRECT, G_DATTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_SUCCESS, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_datfile("Testing data file with error", G_DATTESTFILE_ERROR, G_DATTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_datfile("Testing shorter data file", G_DATTESTFILE_SHORTER, G_DATTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    check_datfile("Testing longer data file", G_DATTESTFILE_LONGER, G_DATTESTFILE_REFERENCE, G_CHECKFILE_VERBOSITY, pltbv, pltbs);
    check_cnt(C_EXPECTED_FAIL, v_expected_checks_cnt, v_expected_errors_cnt, expected_checks_cnt, expected_errors_cnt);
    print("<Done testing check_datfile()");

    print(lf & "<Testing endtest()>");   
    endtest(pltbv, pltbs);    
    print("<Done testing endtest()>");
    
    wait until rising_edge(clk);
    print(lf & "<Testing endsim()>");
    print("");
    print("Expected number of tests:         " & str(v_expected_tests_cnt));
    print("Expected number of skipped tests: " & str(v_expected_skiptests_cnt));
    print("Expected number of checks:        " & str(v_expected_checks_cnt));
    print("Expected number of errors:        " & str(v_expected_errors_cnt));
    if v_expected_errors_cnt = 0 then
      print("Expected result:                  SUCCESS");
    else 
      print("Expected result:                  FAIL");
    end if; 
    wait until rising_edge(clk);
    endsim(pltbv, pltbs, true);
    wait until rising_edge(clk);
    print("<Done testing endsim()>");

    wait;
  end process p_tc1;  
end architecture bhv;
