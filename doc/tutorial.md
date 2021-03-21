Tutorial
--------

If you are reading this markdown file on github, it has been formatted for [doxygen](https://sturla22.github.io/pltbutils/), which might explain some strange symbols.

@tableofcontents

### Basics

We will demonstrate how to use PlTbUtils by showing an example. In this
example, we have a DUT (Device Under Test / Design Under Test) with the
following entity.

```vhdl
entity dut_example is
  generic (
    G_WIDTH         : integer := 8;
    G_DISABLE_BUGS  : integer range 0 to 1 := 1
  );
  port (
    clk_i           : in  std_logic;
    rst_i           : in  std_logic;
    carry_i         : in  std_logic;
    x_i             : in  std_logic_vector(G_WIDTH-1 downto 0);
    y_i             : in  std_logic_vector(G_WIDTH-1 downto 0);
    sum_o           : out std_logic_vector(G_WIDTH-1 downto 0);
    carry_o         : out std_logic
  );
end entity dut_example;
```

As you can see, it has a clock- and a reset input port (clk\_i and
rst\_i), three other input ports (x\_i, y\_i, and carry\_i), and two
output ports (sum\_o and carry\_o). There is also a generic, G\_WIDTH,
which sets the number of bits in x\_i, y\_i and sum\_o. The second
generic, G\_DISABLE\_BUGS, is very unusual in real designs, but it is
useful in this example. We will reveal the purpose of this strange
generic later, although some may already be able to guess what it is
for.

To verify this DUT, we want the testbench to apply different stimuli to
the input ports, and check the response of the output ports. The
following code is an example of such a testbench. We will first show all
of the code, and then explain parts of it.
```vhdl
ibrary ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;

entity tb_example1 is
  generic (
    G_WIDTH             : integer := 8;
    G_CLK_PERIOD        : time := 10 ns;
    G_DISABLE_BUGS      : integer range 0 to 1 := 0
  );
end entity tb_example1;

architecture bhv of tb_example1 is

  -- Simulation status- and control signals
  -- for accessing .stop_sim and for viewing in waveform window
  signal pltbs          : pltbs_t := C_PLTBS_INIT;

  -- DUT stimuli and response signals
  signal clk            : std_logic;
  signal rst            : std_logic;
  signal carry_in       : std_logic;
  signal x              : std_logic_vector(G_WIDTH-1 downto 0);
  signal y              : std_logic_vector(G_WIDTH-1 downto 0);
  signal sum            : std_logic_vector(G_WIDTH-1 downto 0);
  signal carry_out      : std_logic;

begin

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
      stop_sim_i        => pltbs.stop_sim
    );

  -- Testcase process
  -- NOTE: The purpose of the following code is to demonstrate some of the
  -- features of PlTbUtils, not to do a thorough verification.
  p_tc1 : process
    variable pltbv  : pltbv_t := C_PLTBV_INIT;
  begin
    startsim("tc1", "", pltbv, pltbs);
    rst         <= '1';
    carry_in    <= '0';
    x           <= (others => '0');
    y           <= (others => '0');

    starttest(1, "Reset test", pltbv, pltbs);
    waitclks(2, clk, pltbv, pltbs);
    check("Sum during reset",       sum,         0, pltbv, pltbs);
    check("Carry out during reset", carry_out, '0', pltbv, pltbs);
    rst         <= '0';
    endtest(pltbv, pltbs);

    starttest(2, "Simple sum test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         3, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    endtest(pltbv, pltbs);

    starttest(3, "Simple carry in test", pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "Bug here somewhere");
    carry_in <= '1';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         4, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "");
    endtest(pltbv, pltbs);

    starttest(4, "Simple carry out test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(2**G_WIDTH-1, x'length));
    y <= std_logic_vector(to_unsigned(1, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         0, pltbv, pltbs);
    check("Carry out", carry_out, '1', pltbv, pltbs);
    endtest(pltbv, pltbs);

    endsim(pltbv, pltbs, true);
    wait;
  end process p_tc1;

end architecture bhv;
```

As the testbench example shows, the following packages are needed (in
addition to the usual std\_logic\_1164, etc):
```vhdl
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
use work.pltbutils_comp_pkg.all;
```

txt\_util contains functions and procedures for handling strings.

pltbutils\_func\_pkg contains type definitions, functions and procedures
for controlling stimuli and checking response.

pltbutils\_comp\_pkg contains component declarations for testbench
components.

PlTbUtils uses a variable called \ref pltbutils\_func\_pkg.pltbv\_t "pltbv", and a signal called \ref pltbutils\_func\_pkg.pltbs\_t "pltbs", for
controlling the simulation and keeping track of status. The pltbs signal
is useful for viewing in the simulator's waveform window. pltbs is a
record containing a number of members which show various information.
Expand pltbs in the simulator's waveform window to expose the members.
To make it prettier, you can make use of ModelSim's Combine Signals
feature. Each member of the pltbs record can be set to be its own
Combined Signal, see the waveform images in this document. Other
simulators usually have similar features.

The DUT is instantiated in the testbench, as well as a clock generator
component from PlTbUtils.

There is also a testcase process, which feeds the DUT with stimuli, and
checks the results.

The testcase process starts with calling the procedure \ref pltbutils\_func\_pkg.startsim() "startsim". This
procedure initializes pltbv and pltbs, and outputs a message to the
transcript and to the waveform window to inform that the simulation now
starts. The first argument to startsim is the name of the testcase. The
second argument is an empty vector in this example. The purpose of this
argument will be explained later.

The last arguments of startsim, and to many other procedures in
PlTbUtils, are pltbv and pltbs.

After initiating stimuli to the DUT, we call the procedure \ref pltbutils\_func\_pkg.starttest() "starttest"
with the number and name for the first test. starttest prints the test
number and test name to the transcript and to the waveform window, and
updates pltbv and pltbs.

Then we need to wait until the DUT has reacted to the stimuli. We do
this by calling the procedure \ref pltbutils\_func\_pkg.waitclks() "waitclks", which waits a specified number
of cycles of the specified clock.

After this, we start checking the results, by examining the outputs from
the DUT. To do this, we use the \ref pltbutils\_func\_pkg.check() "check" procedure. The first argument is
a text string that specifies what we check, the second argument is the
signal or variable that we want to examine, and the third is the
expected value of the signal or variable. If the examined signal holds
the expected value, nothing is printed. But if the value is incorrect,
the string in the first argument is printed, together with the actual
and expected values of the signal. The number and name of the test (as
specified with starttest) is also printed. PlTbUtils' check counter
is incremented for every check procedure call, and the error counter
is incremented in case of error.

After the test, we call \ref pltbutils\_func\_pkg.endtest() "endtest".

We make a number of different tests by calling starttest, setting
stimuli, waiting for the DUT to react with waitclks or some other
means, and checking the outputs with the check procedure, and calling
endtest.

Finally, we call the \ref pltbutils\_func\_pkg.endsim() "endsim" procedure, which prints an
end-of-simulation message to the transcript, and presents the results,
including a SUCCESS or FAIL message.

The start-of-simulation message, end-of-simulation message, and
SUCCESS/FAIL messages have a unique formatting with three dashes or
asterisks before and after the message. This make them easy to search
for by scripts, to simplify collection of simulation status of
regression tests with a lot of different simulations.

Try it out in your simulator! The pltbutils files that need to be
compiled are located in \ref src/vhdl/, and they are listed in compile order
in pltbutils\_files.lst . The example DUT file is located in
\ref examples/vhdl/rtl\_example/, and the example testbench files are located
in \ref examples/vhdl/tb\_example1/. The files are listed in compile order in
example\_dut.lst and tb\_example1\_files.lst .

If you are a ModelSim user, there are .do files available in
\ref sim/modelsim\_tb\_example1/run/ .
To use them, start Start ModelSim, and in the ModelSim Gui select the
menu item File-\>Change directory\... . Navigate to the PlTbUtils
directory `sim/modelsim\_tb\_example1/run/` and click Ok. Then, in the
transcript window, type

```
do run.do
```

The simulation will start, and the transcript from the simulation looks
as follows.

\image html "doc/src/media/image4.png"

The transcript says that one error has been found at 55 ns, in test 3;
Simple carry in test.

The waveform window looks like this.

\image html "doc/src/media/image3.png"

Here we can see the error detected at the point in time where the error
counter increments from 0 to 1. Again, we can that the error is found in
test 3, the Simple carry in test.

Have a look at the DUT code in
examples/vhdl/rtl\_example/dut\_example.vhd . It looks as follows.

```vhdl
  x <= resize(unsigned(x_i), G_WIDTH+1);
  y <= resize(unsigned(y_i), G_WIDTH+1);
  c <= resize(unsigned(std_logic_vector'('0' & carry_i)), G_WIDTH+1);

  p_sum : process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        sum <= (others => '0');
      else
        if G_DISABLE_BUGS = 1 then
          sum <= x + y + c;
        else
          sum <= x + y;
        end if;
      end if;
    end if;
  end process;
```

The code really looks suspicious. If the generic G\_DISABLE\_BUGS is not
one, the carry input is not added to the sum. But we need the carry
input to be added to the sum!

A simple way to disable this bug, is to set the generic G\_DISABLE\_BUGS
to one. In this case, this can be done very easily, without any
modifying of the code.

In the ModelSim transcript window, type

```
do run_bugfixed.do
```

This will run the test again, but now with the generic G\_DISABLE\_BUGS
set to 1.

The transcript and waveform windows will now look like the following
images.

\image html ./doc/src/media/image5.png

\image html ./doc/src/media/image6.png

This tutorial has shown some of the available procedures and testbench
components in PlTbUtils. For a complete list, see the reference section.

When you want to make your own testbenches with PlTbUtils, have a look
at the template files in \ref templates/vhdl/template1/ .

### Different kinds of check()

There are a number of overloaded \ref pltbutils\_func\_pkg.check() "check" procedures for different VHDL
types, e.g. std\_logic, std\_logic\_vector, unsigned, signed, integer,
boolean, time, etc. See the \ref doc/reference.md "reference" section for a complete list. The
check procedures checks equality, i.e. that a signal or variable has
an expected value. They have the form

```vhdl
check(rpt, actual, expected, pltbv, pltbs)
```

where rpt is the string message with info on what is being checked,
actual is the signal or variable to check, and expected is the expected
value. If the check fails, rpt is printed togher with actual and
expected valued. There is no need to include the expected value in the
rpt string, because it is printed anyway.

The is no support for comparisons other than equality, such as greater
than, or not equal. But there is one check procedure that can be used
for composing your own expression:

```vhdl
check(rpt, expr, pltbv, pltbs)
```

Replace expr with your own expression.

```vhdl
check("Counter after data burst", cnt_o > 10, pltbv, pltbs);
```

Note that if the test fails, the actual and expected values will not be
printed (because this check procedure does not get any information on
actual and expected value. You may include that information in the rpt
message if you want to.

```vhdl
check("Counter after data burst: " & str(cnt_o) & " expected > 10", cnt_o > 10, pltbv, pltbs);
```

You can create specialized check procedures in a package file of your
own. Your package file should begin with

```vhdl
use work.txt_util.all;
use work.pltbutils_func_pkg.all;
```

and your own check procedure should call

```vhdl
check(rpt, expr, actual, expected, mask, pltbv, pltbs)
```

where actual, expected and mask are strings.

Example:

```vhdl
  -- check greater than, unsigned
  procedure check_gt(
    constant rpt                : in    string;
    constant actual             : in    unsigned;
    constant expected           : in    unsigned;
    variable pltbv              : inout pltbv_t;
    signal   pltbs              : out   pltbs_t
  ) is
  begin
    check(rpt, actual > expected, str(actual), ">" & str(expected), "", pltbv, pltbs);
  end procedure check_gt;
```

### Testbench with multiple testcases

In some cases, it is more convenient to not include the testcase process
in the testbench top. Instead, we can put the testcase process in its
own VHDL component. Then we can have alternative architectures for this
component, with different testcase processes.

This is practial for large testbenches with a lot of testbench
components and other code, with a requirement for multiple testcases.
Then we don't have to write a new testbench for each testcase.

The following is an example of such a testbench.

\include tb\_example2.vhd

Instead of a testcase process, we instantiate a testcase component
(tc\_example2). This testcase component has an entity defined in one
file, and the architecture defined in another file. This makes it
possible to have several different testcases for the same testbench.
Just compile the testcase architecture that you want to use for a
specific simulation run.

The entity declaration for the testcase looks as follows.

\include tc\_example2.vhd

The ports of the testcase components are the same as for the DUT, but
the mode (direction) of the ports are the opposite, so the testcase
component can drive the inputs of the DUT, and detect the values of the
output of the DUT. The only exception to this rule is the clock, which
is an input, just as for the DUT.

There is also an output port for pltbs, because pltbs is driven from the
tc architecture.

The entity is stored in its' own file.

The architecture contains the testcase process. There can be several
different architecture files. The architecture looks as follows.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.txt_util.all;
use work.pltbutils_func_pkg.all;

-- NOTE: The purpose of the following code is to demonstrate some of the
-- features in PlTbUtils, not to do a thorough verification.
architecture tc1 of tc_example2 is
begin
  p_tc1 : process
    variable pltbv  : pltbv_t := C_PLTBV_INIT;
  begin
    startsim("tc1", "", pltbv, pltbs);
    rst         <= '1';
    carry_in    <= '0';
    x           <= (others => '0');
    y           <= (others => '0');

    starttest(1, "Reset test", pltbv, pltbs);
    waitclks(2, clk, pltbv, pltbs);
    check("Sum during reset",       sum,         0, pltbv, pltbs);
    check("Carry out during reset", carry_out, '0', pltbv, pltbs);
    rst         <= '0';
    endtest(pltbv, pltbs);

    starttest(2, "Simple sum test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         3, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    endtest(pltbv, pltbs);

    starttest(3, "Simple carry in test", pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "Bug here somewhere");
    carry_in <= '1';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         4, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "");
    endtest(pltbv, pltbs);

    starttest(4, "Simple carry out test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(2**G_WIDTH-1, x'length));
    y <= std_logic_vector(to_unsigned(1, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum",       sum,         0, pltbv, pltbs);
    check("Carry out", carry_out, '1', pltbv, pltbs);
    endtest(pltbv, pltbs);

    endsim(pltbv, pltbs, true);
    wait;
  end process p_tc1;
end architecture tc12;
```

Try this too in your simulator. The example testbench files are located
in examples/vhdl/example2/. The files are listed in compile order in
tb\_example2\_files.lst .

If you are a ModelSim user, there are .do files available in
sim/modelsim\_tb\_example2/run/ .\
To use them, start Start ModelSim, and in the ModelSim Gui select the
menu item\
File-\>Change directory\... . Navigate to the PlTbUtils directory
sim/modelsim\_tb\_example2/run/ and click Ok. Then, in the transcript
window, type\
do run\_tc1.do

Also try

`do run_tc1_bugfixed.do`

Template files for this type of testbench is available in
\ref templates/vhdl/template2/

### Skipping tests

PlTbUtils lets you skip tests, if you want to. This is useful while
debugging a failure in a test. You can save simulation time by skipping
the tests before and after the failing test. It is also useful while
developing a test to skip the tests before.

To skip a test, add generic G\_SKIPTESTS to the testbench of type
std\_logic\_vector.

```vhdl
entity tb_example1_skip is
  generic (
    G_WIDTH             : integer := 8;
    G_CLK_PERIOD        : time := 10 ns;
    G_DISABLE_BUGS      : integer range 0 to 1 := 0;
    G_SKIPTESTS         : std_logic_vector := (
                          '0', -- Dummy
                          '0', -- Test 1
                          '0'  -- Test 2
                               -- ... etc
                          )
end entity tb_example1_skip;
```

If a bit in the vector is '1', the corresponding test is skipped. Bits
are counted from 0 and upwards. There is usually no test with number 0,
so bit 0 is usually a dummy. The length of the vector does not have to
match the number of tests. If the vector is shorter, the remaining tests
will not be skipped. If the vector is longer, the excessive bits will be
ignored.

Feed this generic as the second argument of startsim().

`startsim("tc1", G_SKIPTESTS, pltbv, pltbs);`

For each test, add an if-clause that calls is\_test\_active(pltbv) and
executes or skips the test.

```vhdl
starttest(1, "Reset test", pltbv, pltbs);
if is_test_active(pltbv) then
  waitclks(2, clk, pltbv, pltbs);
  check("Sum during reset",       sum,         0, pltbv, pltbs);
  check("Carry out during reset", carry_out, '0', pltbv, pltbs);
  rst         <= '0';
end if; -- is_test_active()
endtest(pltbv, pltbs);
```

If is\_test\_active(pltbv) returns true, the test will be executed as
usual. If it returns false, PlTbUtils outputs a message like the
following, and skips the test.

Skipping Test 1: Reset test

Note that if you forget the if-clause, the "skipping test message" will
be displayed, but the test will be executed anyway. If a check()
procedure is called within a skipped test (if there is no if-clause), an
error message will be displayed, and the error counter will be
incremented.

The skip functionality is included in the templates in
\ref templates/vhdl/template1/ and \ref templates/vhdl/template2/ .

It is of course also possible to define the generic in the following
form:

```vhdl
G_SKIPTESTS : std_logic_vector := "001";
```

This is more compact as it uses only a single line, but it is not
possible to add individual comments for each test.

### User Configuration

It is possible to configure some aspects of PlTbUtils's behaviour, by
modifying the package file pltbutils\_user\_cfg\_pkg.vhd

It is recommended NOT to modify the file directly. Instead, copy it to
another directory and modify the copy. Make the simulator read the
modified copy instead of the original. This makes it easier to update
pltbutils to a later version without destroying the modifications. After
updating, check if anything has changed in the file, and change your
modified copy accordingly.

If your simulation environment (scripts, etc) uses the file
pltbutils\_files.lst , then copy it too, to the other directory. Modify
the contents of the file, by modifying the relative paths to point to
the files from the new location.

### Configuring Simulation Halt

When calling `endsim`, the signal stop\_sim is set to '1'. When set, all
clock generators etc in the testbench and the DUT should stop, so there
will be no further events in the simulation. The simulator will detect
that nothing more will happen, and stops the simulation.

In some cases, it is not possible to stop clock generators, PLL models
etc. In that case, `endsim` can force a simulaton halt, by setting the
force argument to true.

The declaration of `endsim` is

```vhdl
procedure endsim(
    signal pltbutils_sc : out pltbutils_sc_t;
    constant show_success_fail : in boolean := false;
    constant force : in boolean := false
);
```

so to force a simulation halt, call `endsim` with

`endsim(pltbutils_sc, true, true);`

This stops the simulation using an assert-failure. This works in all
versions of VHDL, but it is an ugly way of doing it, since it outputs a
failure message for something which isn't a failure.

You can change the way the simulation stops when the force flag is set
in your copy of pltbutils\_user\_cfg\_pkg.vhd.

Change the constant C\_PLTBUTILS\_USE\_CUSTOM\_STOPSIM to true, and
modify the behavior of the procedure \ref pltbutils\_user\_cfg\_pkg.custom\_stopsim() "custom_stopsim". In VHDL-2008 the
new keywords stop and finish was introduced. Try one of them, if your
simulator supports them.

### Configuring Messages for Integration Environments

It is possible adapt the status messages to suit various continous
integration environments, e.g. TeamCity, by specifying what the messages
should look like.

You can create your own messages printed when starting and stopping a
simulation, starting and stopping a test, for checking, etc.

In your copy of pltbutils\_user\_cfg\_pkg.vhd, set one or more of the
message constants to true, and modify the associated procedure.

The constants are

- C\_PLTBUTILS\_USE\_CUSTOM\_STARTSIM\_MSG
- C\_PLTBUTILS\_USE\_CUSTOM\_ENDSIM\_MSG
- C\_PLTBUTILS\_USE\_CUSTOM\_STARTTEST\_MSG
- C\_PLTBUTILS\_USE\_CUSTOM\_ENDTEST\_MSG
- C\_PLTBUTILS\_USE\_CUSTOM\_CHECK\_MSG
- C\_PLTBUTILS\_USE\_CUSTOM\_ERROR\_MSG

The corresponding procedures already contain examples for TeamCity.
Modify if you use another environment.

You can disable the standard messages by setting the standard constants
to false (C\_PLTBUTILS\_USE\_STD\_STARTSIM\_MSG etc).

### Differences between simulators

Text strings (TestName and Info text) in the waveform window look
different in different simulators. In ModelSim strings look like this:
Example text. In ISim it looks like this: 'E','x','a','m','p','l','e','
','t','e','x','t'.

### See also
- txt\_util
- pltbutils\_func\_pkg
- pltbutils\_clkgen
- pltbutils\_user\_cfg\_pkg
- [Reference](doc/reference.md)
