onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate /DE1_SoC_tb/test_A
add wave -noupdate /DE1_SoC_tb/test_B
add wave -noupdate /DE1_SoC_tb/test_C
add wave -noupdate /DE1_SoC_tb/test_D
add wave -noupdate /DE1_SoC_tb/test_E
add wave -noupdate /DE1_SoC_tb/test_F
add wave -noupdate /DE1_SoC_tb/test_G
add wave -noupdate /DE1_SoC_tb/test_reset
add wave -noupdate /DE1_SoC_tb/dut/RAM_addr
add wave -noupdate /DE1_SoC_tb/dut/RAM_din
add wave -noupdate /DE1_SoC_tb/dut/RAM_wren
add wave -noupdate /DE1_SoC_tb/dut/RAM_dout
add wave -noupdate /DE1_SoC_tb/dut/full
add wave -noupdate /DE1_SoC_tb/dut/note_loader_sim/full
add wave -noupdate /DE1_SoC_tb/dut/note_loader_sim/RAM_wren
add wave -noupdate /DE1_SoC_tb/dut/note_loader_sim/RAM_addr
add wave -noupdate /DE1_SoC_tb/dut/note_loader_sim/RAM_din
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13186 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {252 ps} {1192 ps}
