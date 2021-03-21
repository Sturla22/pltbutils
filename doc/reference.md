# Reference

If you are reading this markdown file on github, it has been formatted for [doxygen](https://sturla22.github.io/pltbutils/), which might explain some strange symbols.

@tableofcontents

## Functions and procedures

### startsim

```vhdl
procedure startsim(
    constant testcase_name : in string;
    constant skiptests : in std_logic_vector;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```

Displays a message at start of simulation message, and initializes
PlTbUtils' status and control variable and -signal. Call \ref pltbutils\_func\_pkg.startsim() "startsim" only once.

#### Arguments

`testcase_name`: Name of the test case, e.g. `"tc1"`.

`skiptests`: `std_logic_vector` for marking tests that should be skipped.
The leftmost bit has position 0, and position numbers increment to the
right. A '1' indicates that the test with the same number as the
position should be skipped.
Note that there is usually no test which has number 0, so bit zero in
the vector is usually ignored. This argument is normally fed by a
generic. If no tests should be skipped, a zero-length vector is allowed,
(`""`).

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

The start-of-simulation message is not only intended to be informative
for humans. It is also intended to be searched for by scripts, e.g. for
collecting results from a large number of regression tests.

#### Examples

```vhdl
startsim("tc1", "", pltbv, pltbs);
startsim("tc2", G_SKIPTESTS, pltbv, pltbs); -- G_SKIPTESTS is a generic
```

### endsim

```vhdl
procedure endsim(
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant show_success_fail : in boolean := false;
    constant force : in boolean := false
)
```

Displays a message at end of simulation message, presents the simulation
results, and stops the simulation. Call \ref pltbutils\_func\_pkg.endsim() "endsim" only once.

#### Arguments

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

`show_success_fail`: If true, `endsim` shows `*** SUCCESS ***`, `*** FAIL ***`,
or `*** NO CHECKS ***`. Optional, default is `false`.

`force`: If `true`, forces the simulation to stop using an assert failure
statement. Use this option only if the normal way of stopping the
simulation doesn't work (see below). Optional, default is `false`.

The testbench should be designed so that all clocks stop when `endsim`
sets the signal `stop_sim` to '1'. This should stop the simulator.

In some cases, that doesn't work, then set the force argument to true,
which causes a false assert failure, which should stop the simulator.

The end-of-simulation messages and success/fail messages are not only
intended to be informative for humans. They are also intended to be
searched for by scripts, e.g. for collecting results from a large number
of regression tests.

#### Examples

```vhdl
endsim(pltbv, pltbs);
endsim(pltbv, pltbs, true);
endsim(pltbv, pltbs, true, true);
```

### starttest

```
procedure starttest(
    constant num : in integer := -1;
    constant name : in string;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```
\ref pltbutils\_func\_pkg.starttest() "starttest" sets a number (optional) and a name for a test. The number and name will
be printed to the screen, and displayed in the simulator's waveform
window.

The test number and name is also included if there errors reported by
the \ref pltbutils\_func\_pkg.check() "check" procedure calls.

#### Arguments

`num`: Test number. Optional, default is to increment the current test number.

`name`: Test name.

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

If the test number is omitted, a new test number is automatically
computed by incrementing the current test number. Manually setting the
test number may make it easier to find the test code in the testbench code, though.

#### Examples

```vhdl
starttest("Reset test", pltbv, pltbs);
starttest(1, "Reset test", pltbv, pltbs);
```

### is\_test\_active

```vhdl
function is_test_active(
    constant pltbv : in pltbv_t
) return boolean
```
\ref pltbutils_func_pkg.is_test_active() "is_test_active" returns `true` if a test is active (not skipped), otherwise `false`.

#### Arguments

`pltbv`: PlTbUtils' status- and control variable.

#### Example

```vhdl
starttest(3, "Example test", pltbv, pltbs);
if is_test_active(pltbv) then
    ... test code ...
end if;
endtest(pltbv, pltbs);
```

###  endtest

```vhdl
procedure endtest(
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```

\ref pltbutils\_func\_pkg.endtest() "endtest" prints an end-of-test message to the screen.

#### Arguments

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

#### Example

```vhdl
endtest(pltbv, pltbs);
```

### print printv print2

Defined in txt\_util.vhd:

```vhdl
procedure print(
    constant txt : in string
)

procedure print(
    constant active : in boolean;
    constant txt : in string
)
```
Defined in pltbutils\_func\_pkg.vhd:

```vhdl
procedure print(
    signal s : out string;
    constant txt : in string
)

procedure print(
    constant active : in boolean;
    signal s : out string;
    constant txt : in string
)

procedure print(
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant txt : in string
)

procedure print(
    constant active : in boolean;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant txt : in string
)

procedure printv(
    variable s : out string;
    constant txt : in string
)

procedure printv(
    constant active : in boolean;
    variable s : out string;
    constant txt : in string
)

procedure print2(
    signal s : out string;
    constant txt : in string
)

procedure print2(
    constant active : in boolean;
    signal s : out string;
    constant txt : in string
)

procedure print2(
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant txt : in string
)

procedure print2(
    constant active : in boolean;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
    constant txt : in string
)
```
\ref txt_util.print "print" without a signal as argument prints text messages to the
transcript window.

\ref pltbutils_func_pkg.print() "print" with a signal as argument prints text messages to that signal
for viewing in the simulator's waveform window.

\ref pltbutils_func_pkg.printv() "printv" does the same thing, but to a variable instead.

\ref pltbutils_func_pkg.print2() "print2" prints both to a signal and to the transcript window.

The type of the output can be string or `pltbv` + `pltbs`.

#### Arguments

`s`: Signal or variable of type string to be printed to.

`txt`: The text.

`active`: The text is only printed if active is true. Useful for debug
switches,
etc.

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal. The
text will be printed to "info" in the waveform window.

If the string `txt` is longer than the signal `s`, the text will be
truncated. If `txt` is shorter, `s` will be padded with spaces.

#### Examples

```vhdl
print("Hello, world"); -- Prints to transcript window

print(msg, "Hello, world"); -- Prints to signal msg

print(G_DEBUG, msg, "Hello, world"); -- Prints to signal msg if
                                      -- generic G_DEBUG is true

printv(v_msg, "Hello, world"); -- Prints to variable msg

print(pltbv, pltbs, "Hello, world"); -- Prints to "info" in waveform
                                     -- window

print2(msg, "Hello, world"); -- Prints to signal and transcript window

print(pltbv, pltbs, "Hello, world"); -- Prints to "info" in waveform and
                                     -- transcript windows
```

### waitclks

```vhdl
procedure waitclks(
    constant n : in natural;
    signal clk : in std_logic;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant falling : in boolean := false;
    constant timeout : in time := C_PLTBUTILS_TIMEOUT
)
```
\ref pltbutils_func_pkg.waitclks() "waitclks" waits specified amount of clock cycles of the specified clock. Or, to be
more precise, a specified number of specified clock edges of the
specified clock.

#### Arguments

n Number of rising or falling clock edges to wait.

`clk`: The clock to wait for.

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

`falling`: If true, waits for falling edges, otherwise rising edges.
Optional, default is false.

`timeout`: Timeout time, in case the clock is not working.
Optional, default is `C_PLTBUTILS_TIMEOUT`.

#### Examples

```vhdl
waitclks(5, sys_clk, pltbv, pltbs);
waitclks(5, sys_clk, pltbv, pltbs, true);
waitclks(5, sys_clk, pltbv, pltbs, true, 1 ms);
```

### waitsig

```
procedure waitsig(
    signal s : in integer|std_logic|std_logic_vector|unsigned|signed;
    constant value : in integer|std_logic|std_logic_vector|unsigned|signed;
    signal clk : in std_logic;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t;
    constant falling : in boolean := false;
    constant timeout : in time := C_PLTBUTILS_TIMEOUT)
```
\ref pltbutils_func_pkg.waitsig() "waitsig" waits until a signal has reached a specified value after specified clock
edge.

#### Arguments

`s`: The signal to test.
Supported types: integer, std\_logic, std\_logic\_vector, unsigned,
signed.

`value`: Value to wait for.
Same type as data or integer.

`clk`: The clock.

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

`falling`: If true, waits for falling edges, otherwise rising edges.
Optional, default is false.

`timeout`: Timeout time, in case the clock is not working.
Optional, default is C\_PLTBUTILS\_TIMEOUT.

#### Examples

```vhdl
waitsig(wr_en, '1', sys_clk, pltbv, pltbs);
waitsig(rd_en, 1, sys_clk, pltbv, pltbs, true);
waitclks(full, '1', sys_clk, pltbv, pltbs, true, 1 ms);
```

### check

```
procedure check(
    constant rpt : in string;
    constant data : in integer | std_logic | std_logic_vector | unsigned | signed | boolean | time | string;
    constant expected : in integer | std_logic | std_logic_vector | unsigned | signed | boolean | time | string;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```
```vhdl
procedure check(
    constant rpt : in string;
    constant data : in std_logic_vector;
    constant expected : in std_logic_vector;
    constant mask : in std_logic_vector;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```
```vhdl
procedure check(
    constant rpt : in string;
    constant data : in time;
    constant expected : in time;
    constant tolerance : in time;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```
```vhdl
procedure check(
    constant rpt : in string;
    constant expr : in boolean;
    variable pltbv : inout pltbv_t;
    signal pltbs : out pltbs_t
)
```
\ref pltbutils_func_pkg.check() "check" checks that the value of a signal or variable is equal to expected. If
not equal, displays an error message and increments the error counter.

#### Arguments

`rpt`: Report message to be displayed in case of mismatch.
It is recommended that the message is unique and that it contains
the name of the signal or variable being checked. The message
should NOT contain the expected value, because check() prints
that automatically.

`data`: The signal or variable to be checked.
Supported types: integer, std\_logic, std\_logic\_vector, unsigned,
signed.

`expected`: Expected value. Same type as data, or integer.

`mask`: Bit mask and:ed to data and expected before comparison.
Optional if data is std\_logic\_vector. Not allowed for other types.

`tolerance`: Allowed tolerance. Checks that
expected - tolerance ≤ actual ≤ expected + tolerance
is true.

`expr`: boolean expression for checking.
This makes it possible to check any kind of expresion,
not just equality.

`pltbv, pltbs`: PlTbUtils' status- and control variable and -signal.

#### Examples

```vhdl
check("dat_o after reset", dat_o, 0, pltbv, pltbs);

-- With mask:
check("Status field in reg_o after start", reg_o, x"01", x"03", pltbv, pltbs);

-- Boolean expresson:
check("Counter after data burst", cnt_o > 10, pltbv, pltbs);
```

### to\_ascending

```
function to_ascending(
    constant s : std_logic_vector | unsigned | signed
) return std_logic_vector | unsigned | signed;
```
\ref pltbutils_func_pkg.to_ascending() "to_ascending" converts a vector to ascending range ("to-range").
The argument s can have ascending or descending range.
E.g. an argument defined as a `std_logic_vector(3 downto 1)`
will be returned as a `std_logic_vector(1 to 3)`.

#### Arguments

`s`: Constant, signal or variable to convert

Return value: Converted value

#### Examples

```vhdl
ascending_sig <= to_ascending(descending_sig);
ascending_var := to_ascending(descending_var);
```

### to\_descending

```
function to_descending(
    constant s : std_logic_vector | unsigned | signed
) return std_logic_vector | unsigned | signed;
```
\ref pltbutils_func_pkg.to_descending() "to_descending" converts a vector to descending range ("downto-range").
The argument s can have ascending or descending range.
E.g. an argument defined as a `std_logic_vector(1 to 3)`
will be returned as a `std_logic_vector(3 downto 1)`.

#### Arguments

`s`: Constant, signal or variable to convert

Return value: Converted value

#### Examples

```vhdl
descending_sig <= to_descending(ascending_sig);
descending_var := to_descending(ascending_var);
```

### hxstr

```
function hxstr(
    constant s : std_logic_vector | unsigned | signed;
    constant prefix : string := "";
    constant postfix : string := ""
) return string;
```
\ref pltbutils_func_pkg.hxstr() "hxstr" converts a vector to a string in hexadecimal format.
An optional prefix can be specified, e.g. "0x", as well as a suffix.

The input argument can have ascending range ( "to-range" ) or
descending range ("downto-range"). There is no vector length
limitation.

#### Arguments

`s`: Constant, signal or variable to convert

Return value: Converted value

#### Examples

```vhdl
print("value=" & hxstr(s));
print("value=" & hxstr(s, "0x"));
print("value=" & hxstr(s, "16#", "#"));
```

### More functions and procedures in txt\_util.vhd

- converts std\_logic into a character
```vhdl
function chr(sl: std_logic) return character;
```

- converts std\_logic into a string (1 to 1)
```vhdl
function str(sl: std_logic) return string;
```

- converts std\_logic\_vector into a string (binary base)
```vhdl
function str(slv: std_logic_vector) return string;
```

- converts boolean into a string
```vhdl
function str(b: boolean) return string;
```

- converts an integer into a single character
```vhdl
function chr(int: integer) return character;
```
    (can also be used for hex conversion and other bases)

- converts integer into string using specified base
```vhdl
function str(int: integer; base: integer) return string;
```

- converts integer to string, using base 10
```vhdl
function str(int: integer) return string;
```

- convert std\_logic\_vector into a string in hex format
```vhdl
function hstr(slv: std_logic_vector) return string;
```
    **NOTE**: Argument limited to 32 bits. Consider \ref pltbutils_func_pkg.hxstr() "hxstr"


#### functions to manipulate strings

- convert a character to upper case
```vhdl
function to_upper(c: character) return character;
```

- convert a character to lower case
```vhdl
function to_lower(c: character) return character;
```

- convert a string to upper case
```vhdl
function to_upper(s: string) return string;
```

- convert a string to lower case
```vhdl
function to_lower(s: string) return string;
```

- checks if whitespace (JFF)
```vhdl
function is_whitespace(c: character) return boolean;
```

- remove leading whitespace (JFF)
```vhdl
function strip_whitespace(s: string) return string;
```

- return first nonwhitespace substring (JFF)
```vhdl
function first_string(s: string) return string;
```

- finds the first non-whitespace substring in a string and (JFF) returns both the substring and the original with the substring removed
```vhdl
procedure chomp(variable s: inout string; variable shead: out string);
```


#### functions to convert strings into other formats

- converts a character into std\_logic
```vhdl
function to_std_logic(c: character) return std_logic;
```

- converts a hex character into std\_logic\_vector (JFF)
```vhdl
function chr_to_slv(c: character) return std_logic_vector;
```

- converts a character into int (JFF)
```vhdl
function chr_to_int(c: character) return integer;
```

- converts a binary string into std\_logic\_vector
```vhdl
function to_std_logic_vector(s: string) return std_logic_vector;
```

- converts a hex string into std\_logic\_vector (JFF)
```vhdl
function hstr_to_slv(s: string) return std_logic_vector;
```

- converts a decimal string into an integer (JFF)
```vhdl
function str_to_int(s: string) return integer;
```


#### file I/O

- read variable length string from input file
```vhdl
procedure str_read(file in_file: text; res_string: out string);
```

- print string to a file and start new line
```vhdl
procedure print(file out_file: text; new_string: in string);
```

- print character to a file and start new line
```vhdl
procedure print(file out_file: text; char: in character);
```

\see
txt\_util

## Testbench components

### pltbutils\_clkgen

Creates a clock signal for use in a testbench. The clock stops when
input port stop\_sim goes '1'. This makes the simulator stop (unless
there are other infinite processes running in the simulation).

  **Generic**  |  **Width** |  **Type**  |   **Description**
  --------------| -----------| ------------| -------------------------------------------------
  G\_PERIOD    |  1          | time        | Clock period.
  G\_INITVALUE |  1          | std\_logic  | Initial value of the non-inverted clock output.

  **Port**     |  **Width**  | **Direction**|   **Description**
  -------------|- -----------| ------------|--- ------------------------------------------------------------------------------------
  clk\_o       |  1          | Output      |    Non-inverted clock output. Use this output for single ended or differential clocks.
  clk\_n\_o    |  1          | Output      |    Inverted clock output. Use if a differential clock is needed, leave open if single-ended clock is needed.
  stop\_sim\_i |  1          | Input       |    When '1', stops the clock. This will normally stop the simulation.

\see
pltbutils\_clkgen
