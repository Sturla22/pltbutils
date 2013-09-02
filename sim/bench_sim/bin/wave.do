onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Simulation info}
add wave -noupdate /tb_pltbutils/info
add wave -noupdate /tb_pltbutils/test_num
add wave -noupdate /tb_pltbutils/test_name
add wave -noupdate /tb_pltbutils/checks
add wave -noupdate /tb_pltbutils/errors
add wave -noupdate /tb_pltbutils/stop_sim
add wave -noupdate -divider {Expected counters}
add wave -noupdate /tb_pltbutils/expected_checks_cnt
add wave -noupdate /tb_pltbutils/expected_errors_cnt
add wave -noupdate -divider Tb
add wave -noupdate /tb_pltbutils/clk
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
WaveRestoreZoom {0 ps} {1590750 ps}
