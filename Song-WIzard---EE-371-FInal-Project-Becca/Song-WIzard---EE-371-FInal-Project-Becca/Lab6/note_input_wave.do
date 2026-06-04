onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /note_input_tb/clk
add wave -noupdate /note_input_tb/reset
add wave -noupdate /note_input_tb/A
add wave -noupdate /note_input_tb/B
add wave -noupdate /note_input_tb/C
add wave -noupdate /note_input_tb/D
add wave -noupdate /note_input_tb/E
add wave -noupdate /note_input_tb/F
add wave -noupdate /note_input_tb/G
add wave -noupdate /note_input_tb/stop
add wave -noupdate /note_input_tb/full
add wave -noupdate /note_input_tb/RAM_wren
add wave -noupdate /note_input_tb/RAM_addr
add wave -noupdate /note_input_tb/RAM_din
add wave -noupdate /note_input_tb/dut/ni_c/clk
add wave -noupdate /note_input_tb/dut/ni_c/reset
add wave -noupdate /note_input_tb/dut/ni_c/start
add wave -noupdate /note_input_tb/dut/ni_c/note_press_A
add wave -noupdate /note_input_tb/dut/ni_c/note_press_B
add wave -noupdate /note_input_tb/dut/ni_c/note_press_C
add wave -noupdate /note_input_tb/dut/ni_c/note_press_D
add wave -noupdate /note_input_tb/dut/ni_c/note_press_E
add wave -noupdate /note_input_tb/dut/ni_c/note_press_F
add wave -noupdate /note_input_tb/dut/ni_c/note_press_G
add wave -noupdate /note_input_tb/dut/ni_c/addr_eq_max
add wave -noupdate /note_input_tb/dut/ni_c/still_pressed
add wave -noupdate /note_input_tb/dut/ni_c/reset_wren
add wave -noupdate /note_input_tb/dut/ni_c/set_din_A
add wave -noupdate /note_input_tb/dut/ni_c/set_din_B
add wave -noupdate /note_input_tb/dut/ni_c/set_din_C
add wave -noupdate /note_input_tb/dut/ni_c/set_din_D
add wave -noupdate /note_input_tb/dut/ni_c/set_din_E
add wave -noupdate /note_input_tb/dut/ni_c/set_din_F
add wave -noupdate /note_input_tb/dut/ni_c/set_din_G
add wave -noupdate /note_input_tb/dut/ni_c/set_wren
add wave -noupdate /note_input_tb/dut/ni_c/song_full
add wave -noupdate /note_input_tb/dut/ni_c/incr_addr
add wave -noupdate /note_input_tb/dut/ni_c/ps
add wave -noupdate /note_input_tb/dut/ni_c/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {136 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {0 ps} {1522 ps}
