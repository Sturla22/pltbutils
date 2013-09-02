onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Simulation info}
add wave -noupdate /tb_example/info
add wave -noupdate /tb_example/test_num
add wave -noupdate /tb_example/test_name
add wave -noupdate /tb_example/checks
add wave -noupdate /tb_example/errors
add wave -noupdate /tb_example/stop_sim
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
WaveRestoreZoom {999992571 ps} {1000000391 ps}
