----------------------------------------------------------------------
----                                                              ----
---- txt_util.vhd                                                 ----
----                                                              ----
---- This file is part of the PlTbUtils project                   ----
---- http://opencores.org/project,pltbutils                       ----
----                                                              ----
---- Description:                                                 ----
---- PlTbUtils is a collection of functions, procedures and       ----
---- components for easily creating stimuli and checking response ----
---- in automatic self-checking testbenches.                      ----
----                                                              ----
---- This file defines useful functions an procedures for text    ----
---- handling text in VHDL.                                       ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Source:                                                      ----
---- http://www.mrc.uidaho.edu/mrc/people/jff/vhdl_info/txt_util.vhd -
---- Thanks to Stefan Doll and James F. Frenzel.                  ----                                                              ----
----------------------------------------------------------------------
--  
--  Disclaimer: Derived from txt_util.vhd on www.stefanvhdl.com
--  
--  Revision History:
--  
--  1.0 URL: http://www.stefanvhdl.com/vhdl/vhdl/txt_util.vhd
--  
--  1.1 Modified str_read() to prevent extra character (JFF)
--  
--  1.2 Added is_whitespace() and strip_whitespace() (JFF)
--  
--  1.3 Added first_string() and chomp() (JFF)
--  
--  1.4 Added hex string and integer string conversion (JFF)
--  
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

package txt_util is

    -- prints a message to the screen
    procedure print(text: string);

    -- prints the message when active
    -- useful for debug switches
    procedure print(active: boolean; text: string);

    -- converts std_logic into a character
    function chr(sl: std_logic) return character;

    -- converts std_logic into a string (1 to 1)
    function str(sl: std_logic) return string;

    -- converts std_logic_vector into a string (binary base)
    function str(slv: std_logic_vector) return string;

    -- converts boolean into a string
    function str(b: boolean) return string;

    -- converts an integer into a single character
    -- (can also be used for hex conversion and other bases)
    function chr(int: integer) return character;

    -- converts integer into string using specified base
    function str(int: integer; base: integer) return string;

    -- converts integer to string, using base 10
    function str(int: integer) return string;

    -- convert std_logic_vector into a string in hex format
    function hstr(slv: std_logic_vector) return string;


    -- functions to manipulate strings
    -----------------------------------

    -- convert a character to upper case
    function to_upper(c: character) return character;

    -- convert a character to lower case
    function to_lower(c: character) return character;

    -- convert a string to upper case
    function to_upper(s: string) return string;

    -- convert a string to lower case
    function to_lower(s: string) return string;
	 
	 -- checks if whitespace (JFF)
	 function is_whitespace(c: character) return boolean;
	 
	 -- remove leading whitespace (JFF)
	 function strip_whitespace(s: string) return string;
    
	 -- return first nonwhitespace substring (JFF)
	 function first_string(s: string) return string;
    
    -- finds the first non-whitespace substring in a string and (JFF)  
	 -- returns both the substring and the original with the substring removed 
	 procedure chomp(variable s: inout string; variable shead: out string);
    

   
    
    -- functions to convert strings into other formats
    --------------------------------------------------
    
    -- converts a character into std_logic
    function to_std_logic(c: character) return std_logic; 
    
    -- converts a hex character into std_logic_vector (JFF)
    function chr_to_slv(c: character) return std_logic_vector; 
    
    -- converts a character into int (JFF)
    function chr_to_int(c: character) return integer; 
    
    -- converts a binary string into std_logic_vector
    function to_std_logic_vector(s: string) return std_logic_vector; 
	 
    -- converts a hex string into std_logic_vector (JFF)
    function hstr_to_slv(s: string) return std_logic_vector;
	 
    -- converts a decimal string into an integer (JFF)
    function str_to_int(s: string) return integer; 


  
    -- file I/O
    -----------
       
    -- read variable length string from input file
    procedure str_read(file in_file: TEXT; 
                       res_string: out string);
        
    -- print string to a file and start new line
    procedure print(file out_file: TEXT;
                    new_string: in  string);
    
    -- print character to a file and start new line
    procedure print(file out_file: TEXT;
                    char:       in  character);
                    
end txt_util;




package body txt_util is




   -- prints text to the screen

   procedure print(text: string) is
     variable msg_line: line;
     begin
       write(msg_line, text);
       writeline(output, msg_line);
   end print;




   -- prints text to the screen when active

   procedure print(active: boolean; text: string)  is
     begin
      if active then
         print(text);
      end if;
   end print;


   -- converts std_logic into a character

   function chr(sl: std_logic) return character is
    variable c: character;
    begin
      case sl is
         when 'U' => c:= 'U';
         when 'X' => c:= 'X';
         when '0' => c:= '0';
         when '1' => c:= '1';
         when 'Z' => c:= 'Z';
         when 'W' => c:= 'W';
         when 'L' => c:= 'L';
         when 'H' => c:= 'H';
         when '-' => c:= '-';
      end case;
    return c;
   end chr;



   -- converts std_logic into a string (1 to 1)

   function str(sl: std_logic) return string is
    variable s: string(1 to 1);
    begin
        s(1) := chr(sl);
        return s;
   end str;



   -- converts std_logic_vector into a string (binary base)
   -- (this also takes care of the fact that the range of
   --  a string is natural while a std_logic_vector may
   --  have an integer range)

   function str(slv: std_logic_vector) return string is
     variable result : string (1 to slv'length);
     variable r : integer;
   begin
     r := 1;
     for i in slv'range loop
        result(r) := chr(slv(i));
        r := r + 1;
     end loop;
     return result;
   end str;


   function str(b: boolean) return string is

    begin
       if b then
          return "true";
      else
        return "false";
       end if;
    end str;


   -- converts an integer into a character
   -- for 0 to 9 the obvious mapping is used, higher
   -- values are mapped to the characters A-Z
   -- (this is usefull for systems with base > 10)
   -- (adapted from Steve Vogwell's posting in comp.lang.vhdl)

   function chr(int: integer) return character is
    variable c: character;
   begin
        case int is
          when  0 => c := '0';
          when  1 => c := '1';
          when  2 => c := '2';
          when  3 => c := '3';
          when  4 => c := '4';
          when  5 => c := '5';
          when  6 => c := '6';
          when  7 => c := '7';
          when  8 => c := '8';
          when  9 => c := '9';
          when 10 => c := 'A';
          when 11 => c := 'B';
          when 12 => c := 'C';
          when 13 => c := 'D';
          when 14 => c := 'E';
          when 15 => c := 'F';
          when 16 => c := 'G';
          when 17 => c := 'H';
          when 18 => c := 'I';
          when 19 => c := 'J';
          when 20 => c := 'K';
          when 21 => c := 'L';
          when 22 => c := 'M';
          when 23 => c := 'N';
          when 24 => c := 'O';
          when 25 => c := 'P';
          when 26 => c := 'Q';
          when 27 => c := 'R';
          when 28 => c := 'S';
          when 29 => c := 'T';
          when 30 => c := 'U';
          when 31 => c := 'V';
          when 32 => c := 'W';
          when 33 => c := 'X';
          when 34 => c := 'Y';
          when 35 => c := 'Z';
          when others => c := '?';
        end case;
        return c;
    end chr;



   -- convert integer to string using specified base
   -- (adapted from Steve Vogwell's posting in comp.lang.vhdl)

   function str(int: integer; base: integer) return string is

    variable temp:      string(1 to 10);
    variable num:       integer;
    variable abs_int:   integer;
    variable len:       integer := 1;
    variable power:     integer := 1;

   begin

    -- bug fix for negative numbers
    abs_int := abs(int);

    num     := abs_int;

    while num >= base loop                     -- Determine how many
      len := len + 1;                          -- characters required
      num := num / base;                       -- to represent the
    end loop ;                                 -- number.

    for i in len downto 1 loop                 -- Convert the number to
      temp(i) := chr(abs_int/power mod base);  -- a string starting
      power := power * base;                   -- with the right hand
    end loop ;                                 -- side.

    -- return result and add sign if required
    if int < 0 then
       return '-'& temp(1 to len);
     else
       return temp(1 to len);
    end if;

   end str;


  -- convert integer to string, using base 10
  function str(int: integer) return string is

   begin

    return str(int, 10) ;

   end str;



   -- converts a std_logic_vector into a hex string.
   function hstr(slv: std_logic_vector) return string is
       variable hexlen: integer;
       variable longslv : std_logic_vector(67 downto 0) := (others => '0');
       variable hex : string(1 to 16);
       variable fourbit : std_logic_vector(3 downto 0);
     begin
       hexlen := (slv'left+1)/4;
       if (slv'left+1) mod 4 /= 0 then
         hexlen := hexlen + 1;
       end if;
       longslv(slv'left downto 0) := slv;
       for i in (hexlen -1) downto 0 loop
         fourbit := longslv(((i*4)+3) downto (i*4));
         case fourbit is
           when "0000" => hex(hexlen -I) := '0';
           when "0001" => hex(hexlen -I) := '1';
           when "0010" => hex(hexlen -I) := '2';
           when "0011" => hex(hexlen -I) := '3';
           when "0100" => hex(hexlen -I) := '4';
           when "0101" => hex(hexlen -I) := '5';
           when "0110" => hex(hexlen -I) := '6';
           when "0111" => hex(hexlen -I) := '7';
           when "1000" => hex(hexlen -I) := '8';
           when "1001" => hex(hexlen -I) := '9';
           when "1010" => hex(hexlen -I) := 'A';
           when "1011" => hex(hexlen -I) := 'B';
           when "1100" => hex(hexlen -I) := 'C';
           when "1101" => hex(hexlen -I) := 'D';
           when "1110" => hex(hexlen -I) := 'E';
           when "1111" => hex(hexlen -I) := 'F';
           when "ZZZZ" => hex(hexlen -I) := 'z';
           when "UUUU" => hex(hexlen -I) := 'u';
           when "XXXX" => hex(hexlen -I) := 'x';
           when others => hex(hexlen -I) := '?';
         end case;
       end loop;
       return hex(1 to hexlen);
     end hstr;



   -- functions to manipulate strings
   -----------------------------------


   -- convert a character to upper case

   function to_upper(c: character) return character is

      variable u: character;

    begin

       case c is
        when 'a' => u := 'A';
        when 'b' => u := 'B';
        when 'c' => u := 'C';
        when 'd' => u := 'D';
        when 'e' => u := 'E';
        when 'f' => u := 'F';
        when 'g' => u := 'G';
        when 'h' => u := 'H';
        when 'i' => u := 'I';
        when 'j' => u := 'J';
        when 'k' => u := 'K';
        when 'l' => u := 'L';
        when 'm' => u := 'M';
        when 'n' => u := 'N';
        when 'o' => u := 'O';
        when 'p' => u := 'P';
        when 'q' => u := 'Q';
        when 'r' => u := 'R';
        when 's' => u := 'S';
        when 't' => u := 'T';
        when 'u' => u := 'U';
        when 'v' => u := 'V';
        when 'w' => u := 'W';
        when 'x' => u := 'X';
        when 'y' => u := 'Y';
        when 'z' => u := 'Z';
        when others => u := c;
    end case;

      return u;

   end to_upper;


   -- convert a character to lower case

   function to_lower(c: character) return character is

      variable l: character;

    begin

       case c is
        when 'A' => l := 'a';
        when 'B' => l := 'b';
        when 'C' => l := 'c';
        when 'D' => l := 'd';
        when 'E' => l := 'e';
        when 'F' => l := 'f';
        when 'G' => l := 'g';
        when 'H' => l := 'h';
        when 'I' => l := 'i';
        when 'J' => l := 'j';
        when 'K' => l := 'k';
        when 'L' => l := 'l';
        when 'M' => l := 'm';
        when 'N' => l := 'n';
        when 'O' => l := 'o';
        when 'P' => l := 'p';
        when 'Q' => l := 'q';
        when 'R' => l := 'r';
        when 'S' => l := 's';
        when 'T' => l := 't';
        when 'U' => l := 'u';
        when 'V' => l := 'v';
        when 'W' => l := 'w';
        when 'X' => l := 'x';
        when 'Y' => l := 'y';
        when 'Z' => l := 'z';
        when others => l := c;
    end case;

      return l;

   end to_lower;



   -- convert a string to upper case

   function to_upper(s: string) return string is

     variable uppercase: string (s'range);

   begin

     for i in s'range loop
        uppercase(i):= to_upper(s(i));
     end loop;
     return uppercase;

   end to_upper;



   -- convert a string to lower case

   function to_lower(s: string) return string is

     variable lowercase: string (s'range);

   begin

     for i in s'range loop
        lowercase(i):= to_lower(s(i));
     end loop;
     return lowercase;

   end to_lower;
	
	
	-- checks if whitespace (JFF)
	
	function is_whitespace(c: character) return boolean is
	
	begin
	
		if (c = ' ') or (c = HT) then
			return true;
		else return false;
		end if;
		
	end is_whitespace;
	
	
	-- remove leading whitespace (JFF)
	
	function strip_whitespace(s: string) return string is
	
	variable stemp : string (s'range);
	variable j, k : positive := 1;
	
	begin
	
	-- fill stemp with blanks
	for i in s'range loop
		stemp(i) := ' ';
	end loop;
	
	-- find first non-whitespace in s
	for i in s'range loop
		if is_whitespace(s(i)) then
			j := j + 1;
		else exit;
		end if;
	end loop;
	-- j points to first non-whitespace
	
	-- copy remainder of s into stemp
	-- starting at 1
	for i in j to s'length loop
		stemp(k) := s(i);
		k := k + 1;
	end loop;	
	
	return stemp;	
	
	end strip_whitespace;


	
	-- return first non-whitespacesubstring (JFF)
	
	function first_string(s: string) return string is
	
	variable stemp, s2 : string (s'range);
	
	begin
	
	-- fill s2 with blanks
	for i in s'range loop
		s2(i) := ' ';
	end loop;
	
	-- remove leading whitespace
	stemp := strip_whitespace(s);
	
	-- copy until first whitespace
	for i in stemp'range loop
		if not is_whitespace(stemp(i)) then
			s2(i) := stemp(i);
		else exit;
		end if;
	end loop;
	
	return s2;

	end first_string;
	
	
	
	-- removes first non-whitespace string from a string (JFF)

	procedure chomp(variable s: inout string; variable shead: out string) is

	variable stemp, stemp2 : string (s'range);
	variable j, k : positive := 1;

	begin
	
	-- fill stemp and stemp2 with blanks
	for i in s'range loop
		stemp(i) := ' '; stemp2(i) := ' ';
	end loop;
	
	stemp := strip_whitespace(s);
	
	shead := first_string(stemp);

	-- find first whitespace in stemp
	for i in stemp'range loop
		if not is_whitespace(stemp(i)) then
			j := j + 1;
		else exit;
		end if;
	end loop;
	-- j points to first whitespace
	
	-- copy remainder of stemp into stemp2
	-- starting at 1
	for i in j to stemp'length loop
		stemp2(k) := stemp(i);
		k := k + 1;
	end loop;
	
	s := stemp2;	
			
	end chomp;



-- functions to convert strings into other types


-- converts a character into a std_logic

function to_std_logic(c: character) return std_logic is 
    variable sl: std_logic;
    begin
      case c is
        when 'U' => 
           sl := 'U'; 
        when 'X' =>
           sl := 'X';
        when '0' => 
           sl := '0';
        when '1' => 
           sl := '1';
        when 'Z' => 
           sl := 'Z';
        when 'W' => 
           sl := 'W';
        when 'L' => 
           sl := 'L';
        when 'H' => 
           sl := 'H';
        when '-' => 
           sl := '-';
        when others =>
           sl := 'X'; 
    end case;
   return sl;
  end to_std_logic;


    -- converts a character into std_logic_vector (JFF)
    function chr_to_slv(c: character) return std_logic_vector is
    variable slv: std_logic_vector(3 downto 0);
    begin
      case c is
        when '0' => 
           slv := "0000";
        when '1' => 
           slv := "0001";
        when '2' => 
           slv := "0010";
        when '3' => 
           slv := "0011";
        when '4' => 
           slv := "0100";
        when '5' => 
           slv := "0101";
        when '6' => 
           slv := "0110";
        when '7' => 
           slv := "0111";
        when '8' => 
           slv := "1000";
        when '9' => 
           slv := "1001";
        when 'A' | 'a' => 
           slv := "1010";
        when 'B' | 'b' => 
           slv := "1011";
        when 'C' | 'c' => 
           slv := "1100";
        when 'D' | 'd' => 
           slv := "1101";
        when 'E' | 'e' => 
           slv := "1110";
        when 'F' | 'f' => 
           slv := "1111";
        when others => null;
    end case;
   return slv;
	 end chr_to_slv; 
    

    -- converts a character into int (JFF)
    function chr_to_int(c: character) return integer is
    variable x: integer;
    begin
      case c is
        when '0' => 
           x := 0;
        when '1' => 
           x := 1;
        when '2' => 
           x := 2;
        when '3' => 
           x := 3;
        when '4' => 
           x := 4;
        when '5' => 
           x := 5;
        when '6' => 
           x := 6;
        when '7' => 
           x := 7;
        when '8' => 
           x := 8;
        when '9' => 
           x := 9;
        when others => null;
    end case;
   return x;
	 end chr_to_int; 
    


-- converts a binary string into std_logic_vector

function to_std_logic_vector(s: string) return std_logic_vector is 
  variable slv: std_logic_vector(s'high-s'low downto 0);
  variable k: integer;
begin
   k := s'high-s'low;
  for i in s'range loop
     slv(k) := to_std_logic(s(i));
     k      := k - 1;
  end loop;
  return slv;
end to_std_logic_vector;                                       
                                       
                                       
    -- converts a hex string into std_logic_vector (JFF)
    function hstr_to_slv(s: string) return std_logic_vector is
  variable slv: std_logic_vector(((s'length*4)-1) downto 0) := (others => '0');
  variable k: integer;
begin
  for i in s'range loop
    slv := slv((slv'length - 5) downto 0) & chr_to_slv(s(i)); 
  end loop;
  return slv;
	 end hstr_to_slv;
	 
    -- converts a decimal string into an integer (JFF)
    function str_to_int(s: string) return integer is
  variable k: integer;
begin
   k := 0;
  for i in s'range loop
     k := (k*10) + chr_to_int(s(i));
  end loop;
  return k;
	 end str_to_int; 
	 
	 

                                       
                                       
                                       
                                       
----------------
--  file I/O  --
----------------



-- read variable length string from input file
     
procedure str_read(file in_file: TEXT; 
                   res_string: out string) is
       
       variable l:         line;
       variable c:         character;
       variable is_string: boolean;
       
   begin
           
     readline(in_file, l);
     -- clear the contents of the result string
     for i in res_string'range loop
         res_string(i) := ' ';
     end loop;   
     -- read all characters of the line, up to the length  
     -- of the results string
     for i in res_string'range loop

-- JFF - new
--
    read(l, c, is_string);
    if is_string then res_string(i) := c;
    else exit;
    end if;

-- JFF - was duplicating the last char if no 
-- space at the end of the line
-- 
--        read(l, c, is_string);
--        res_string(i) := c;
--        if not is_string then -- found end of line
--           exit;
--        end if;

   
     end loop; 
                     
end str_read;


-- print string to a file
procedure print(file out_file: TEXT;
                new_string: in  string) is
       
       variable l: line;
       
   begin
      
     write(l, new_string);
     writeline(out_file, l);
                     
end print;


-- print character to a file and start new line
procedure print(file out_file: TEXT;
                char: in  character) is
       
       variable l: line;
       
   begin
      
     write(l, char);
     writeline(out_file, l);
                     
end print;



-- appends contents of a string to a file until line feed occurs
-- (LF is considered to be the end of the string)

procedure str_write(file out_file: TEXT; 
                    new_string: in  string) is
 begin
      
   for i in new_string'range loop
      print(out_file, new_string(i));
      if new_string(i) = LF then -- end of string
         exit;
      end if;
   end loop;               
                     
end str_write;




end txt_util;




