# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./note_input_tb.sv"
vlog "./note_input_datapath.sv"
vlog "./note_input_controller.sv"
vlog "./note_input.sv"
vlog "./noise_gen.sv"
vlog "./DE1_SoC.sv"
vlog "./clock_generator.v"
vlog "./audio_codec.v"
vlog "./clock_divider_8.sv"
vlog "./clock_divider_8_tb.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work note_input_tb -Lf altera_mf_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do note_input_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
