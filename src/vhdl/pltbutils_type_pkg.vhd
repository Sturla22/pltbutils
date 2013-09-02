----------------------------------------------------------------------
----                                                              ----
---- PlTbUtils Types Package                                      ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file defines types used by PlTbUtils, mainly protected  ----
---- types.                                                       ----
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
---- Copyright (C) 2009 Authors and OPENCORES.ORG                 ----
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

package pltbutils_type_pkg is

  constant C_PLTBUTILS_SC_STRLEN : integer := 80;

  type pltbutils_p_integer_t is protected
    procedure clr;
    procedure inc;
    procedure dec;
    procedure set(x : integer);
    impure function value return integer;
  end protected pltbutils_p_integer_t;

  type pltbutils_p_std_logic_t is protected
    procedure clr;
    procedure set(x : std_logic);
    impure function value return std_logic;
  end protected pltbutils_p_std_logic_t;

  type pltbutils_p_string_t is protected
    procedure clr;
    procedure set(s : string);
    impure function value return string;
  end protected pltbutils_p_string_t;

  end package pltbutils_type_pkg;

package body pltbutils_type_pkg is
  ----------------------------------------------------------------------------
  type pltbutils_p_integer_t is protected body
    variable val : integer := 0;
    
    procedure clr is
    begin
      val := 0;
    end procedure clr;
    
    procedure inc is
    begin
      val := val + 1;
    end procedure inc;
    
    procedure dec is
    begin
      val := val - 1;
    end procedure dec;

    procedure set(x : integer) is
    begin
      val := x;
    end procedure set;
    
    impure function value return integer is
    begin 
      return val;
    end function value;    
  end protected body pltbutils_p_integer_t;
  ----------------------------------------------------------------------------
  type pltbutils_p_std_logic_t is protected body
    variable val : std_logic := '0';
    
    procedure clr is
    begin
      val := '0';
    end procedure clr;

    procedure set(x : std_logic) is
    begin
      val := x;
    end procedure set;
    
    impure function value return std_logic is
    begin 
      return val;
    end function value;    
  end protected body pltbutils_p_std_logic_t;
  ----------------------------------------------------------------------------
  type pltbutils_p_string_t is protected body
    variable str : string(1 to C_PLTBUTILS_SC_STRLEN) := (others => '0');
    
    procedure clr is
    begin
      str := (others => ' ');
    end procedure clr;
    
    procedure set(s : string) is
      variable j : positive := s'low;
    begin
      for i in str'range loop
        if j <= s'high then
          str(i) := s(j);
        else
          str(i) := ' ';
        end if;
        j := j + 1;
      end loop;
    end procedure set;

    impure function value return string is
    begin 
      return str;
    end function value;
  end protected body pltbutils_p_string_t;
  ----------------------------------------------------------------------------  
end package body pltbutils_type_pkg;