# PlTbUtils

@tableofcontents

*Author: Per Larsson, pela.opencores\@gmail.com*

### Features

-   Simulation status printed in transcript windows as well as in waveform window (error count, checks count, number and name of current test, etc).

-   Check procedures which output meaningful information when a check fails.

-   Clear SUCCESS/FAIL message at end of simulation.

-   Easy to locate point in time of bugs, by studying increments of the error counter in the waveform window.

-   User-defined information messages in the waveform window about what is currently going on.

-   Transcript outputs prepared for parsing by scripts, e.g. in regression tests.

-   Configurable status messages for use in continuous integration environments, e.g. TeamCity.

-   Reduces amount of code in tests, which makes them faster to write and easier to read.

-   Tests can easily be included or skipped in a test run.

-   Supports VHDL-93 and later.

-   Supports most popular VHDL simulators, including ModelSim and ISim.

It is intended that PlTbUtils will constantly expand by adding more and more functions, procedures and testbench components. Comments, feedback and suggestions are welcome to [pela.opencores\@gmail.com](mailto:pela.opencores@gmail.com?subject=PlTbUtils).


Project web page: <http://opencores.org/project,pltbutils>

Subversion repository URL: <http://opencores.org/ocsvn/pltbutils/pltbutils/trunk>

Subversion export command: `svn export http://opencores.org/ocsvn/pltbutils/pltbutils/trunk pltbutils`

Github repository URL: <https://github.com/Sturla22/pltbutils>


### Revision History

| **Rev.** | **Date** | **Author** | **Description** |
|-----:|:----------:|:-----------:|:-----------------------------------------------|
| 0.1 | 09/02/2013 | Per Larsson | First draft |
| 0.2 | 11/10/2013 | Per Larsson | Added sections Acknowledgements and Language. Added reference section on waitsig().<br>Updated reference section on print() and pltbutils\_clkgen.|
| 0.3 | 01/05/2013 | Per Larsson | Added sections User Configuration, Configuring Simulation Halt, Configuring Messages for Integration Environments.<br>In reference section added starttest, endtest, removed testname. Updated figures and feature bullets.|
| 0.4 | 01/09/2013 | Per Larsson | Updates for alpha0006: Text modified in numerous places to reflect that PlTbUtils is now using the variable pltbv and<br>the signal pltbs for control and status, instead of the previous shared variable and global signals.|
| 0.5 | 13/01/2014 | Per Larsson | Updates for alpha0007: added example testbench where the testcase process is instantiated in the <br> testbench top (tb\_example1).<br>The old example where the testcase process is located in a VHDL component of its own, is now called example\_tb2.|
| 0.6 | 02/02/2015 | Per Larsson | Updates for beta0002: added description of to\_ascending(), to\_descending(), hxstr(), functions and procedures in txt\_util.vhd.|
| 0.7 | 23/11/2015 | Per Larsson | Updates for beta0003: added to VHDL versions and simulators to feature list.<br>Added check() for boolean and for time with tolerance. In section User Configuration, added info on pltbutils\_files.lst|
| 0.8 | 03/01/2016 | Per Larsson | Updates for beta0004: updated feature list, added Skipping tests, updated figures.|
| 1.0 | 26/01/2016 | Per Larsson | Updates for pltbutils v1.0: minor corrections. |
| 1.1 | 14/08/2018 | Per Larsson | Corrected handling of skipped tests.|
| | 15/08/2018 | Per Larsson | Added XSim to list of supported simulators.|
| 1.2 | 12/04/2020 | Per Larsson | Added check\_binfile(), check\_txtfile(), check\_datfile(), and other new functions and procedures.|
| 1.3 | 12/05/2020 | Per Larsson | Updated private procedure to make check\_datfile() get correct functionality with XSim.|



### Acknowledgements

PlTbUtils contains the file txt\_util.vhd by Stefan Doll and James F.  Frenzel.

Thanks to Stefan Eriksson for suggestions and feedback.

### Language

PlTbUtils complies with VHDL-1993 and later, so it works with most VHDL simulators.

It is possible to configure the way a simulation stops, by taking advantage of the VHDL-2008 keywords stop and finish. If your simulator supports stop and/or finish, see Configuring Simulation Halt on page 19.

### A quick look

\image html "doc/src/media/image3.png"

During a simulation, the waveform window shows current test number, test name, user-defined info, accumulated number of checks and errors. When the error counter increments, a bug has been found in that point in time.

\image html "doc/src/media/image4.png"

The transcript window clearly shows points in time where the simulation starts, ends, and where errors are detected. The simulation stops with a clear SUCCESS/FAIL message, specifically formatted for parsing by scripts.

\image html "doc/src/media/image5.png"

The testcase code is compact and to the point, which results in less code to write, and makes the code easier to read, as in the following example.

```vhdl
-- NOTE: The purpose of the following code is to demonstrate some of the
-- features in PlTbUtils, not to do a thorough verification.

p_tc1 : process
    variable pltbv : pltbv_t := C_PLTBV_INIT;
begin
    startsim("tc1", "", pltbv, pltbs);
    rst <= '1';
    carry_in <= '0';
    x <= (others => '0');
    y <= (others => '0');

    starttest(1, "Reset test", pltbv, pltbs);
    waitclks(2, clk, pltbv, pltbs);
    check("Sum during reset", sum, 0, pltbv, pltbs);
    check("Carry out during reset", carry_out, '0', pltbv, pltbs);
    rst <= '0';
    endtest(pltbv, pltbs);

    starttest(2, "Simple sum test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum", sum, 3, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    endtest(pltbv, pltbs);

    starttest(3, "Simple carry in test", pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "Bug here somewhere");
    carry_in <= '1';
    x <= std_logic_vector(to_unsigned(1, x'length));
    y <= std_logic_vector(to_unsigned(2, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum", sum, 4, pltbv, pltbs);
    check("Carry out", carry_out, '0', pltbv, pltbs);
    print(G_DISABLE_BUGS=0, pltbv, pltbs, "");
    endtest(pltbv, pltbs);

    starttest(4, "Simple carry out test", pltbv, pltbs);
    carry_in <= '0';
    x <= std_logic_vector(to_unsigned(2**G_WIDTH-1, x'length));
    y <= std_logic_vector(to_unsigned(1, x'length));
    waitclks(2, clk, pltbv, pltbs);
    check("Sum", sum, 0, pltbv, pltbs);
    check("Carry out", carry_out, '1', pltbv, pltbs);
    endtest(pltbv, pltbs);

    endsim(pltbv, pltbs, true);
    wait;
end process p_tc1;

```

### PlTbUtils files

The PlTbUtils files are located in \ref src/vhdl/ .

The files needed to be compiled are listed in compile order in
pltbutils\_files.lst .

See example testbenches using PlTbUtils in \ref examples/vhdl/ .

This code can be simulated from \ref sim/modelsim\_tb\_example1/run/ and
\ref sim/modelsim\_tb\_example2/run/ .

Template code is available in \ref templates/vhdl/ .

### See also

- [Tutorial](doc/tutorial.md)
- txt\_util
- pltbutils\_func\_pkg
- pltbutils\_clkgen
- pltbutils\_user\_cfg\_pkg
- [Reference](doc/reference.md)
