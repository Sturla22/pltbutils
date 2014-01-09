onerror {resume}
quietly virtual signal -install /tb_example {/tb_example/pltbs.test_num  } Test_number
quietly virtual signal -install /tb_example {/tb_example/pltbs.test_name  } Test_name
quietly virtual signal -install /tb_example {/tb_example/pltbs.info  } Info
quietly virtual signal -install /tb_example {/tb_example/pltbs.chk_cnt  } Checks
quietly virtual signal -install /tb_example {/tb_example/pltbs.err_cnt  } Errors
quietly virtual signal -install /tb_example {/tb_example/pltbs.stop_sim  } StopSim
quietly virtual signal -install /tb_example {/tb_example/pltbs.test_num  } TestNumber
quietly virtual signal -install /tb_example {/tb_example/pltbs.test_name  } TestName
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Simulation info}
add wave -noupdate /tb_example/TestNumber
add wave -noupdate /tb_example/TestName
add wave -noupdate /tb_example/Info
add wave -noupdate /tb_example/Checks
add wave -noupdate /tb_example/Errors
add wave -noupdate /tb_example/StopSim
add wave -noupdate -divider Tb
add wave -noupdate /tb_example/clk
add wave -noupdate /tb_example/rst
add wave -noupdate /tb_example/carry_in
add wave -noupdate /tb_example/x
add wave -noupdate /tb_example/y
add wave -noupdate /tb_example/sum
add wave -noupdate /tb_example/carry_out
add wave -noupdate -divider DUT
add wave -noupdate /tb_example/dut0/clk_i
add wave -noupdate /tb_example/dut0/rst_i
add wave -noupdate /tb_example/dut0/carry_i
add wave -noupdate /tb_example/dut0/x_i
add wave -noupdate /tb_example/dut0/y_i
add wave -noupdate /tb_example/dut0/sum_o
add wave -noupdate /tb_example/dut0/carry_o
add wave -noupdate /tb_example/dut0/x
add wave -noupdate /tb_example/dut0/y
add wave -noupdate /tb_example/dut0/c
add wave -noupdate /tb_example/dut0/sum
add wave -noupdate -divider End
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 133
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {131072 ps}
