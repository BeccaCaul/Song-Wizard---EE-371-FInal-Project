/* This module polls for user note input and loads notes
 * sequentially to a RAM memory to be accessed by the Audio CODEC
 * each note written to memory represents 1/8s of the song
 * The module runs on an 8Hz clock to account for real-time user input
 *
 * Inputs:
 *   clk    - should be connected to an 8 MHz clock in hardware, can be 50MHz in sim
 *   reset  - resets the module and starts over the drawing process
 *	  A, B, C, D, E, F, G - notes pressed on the keyboard (N8 controller)
 *   stop 	- signal to stop loading (even if song not full)
 *
 * Outputs:
 *   full 	  - signals that song is full or user has decided to stop loading (stop)
 *   RAM_addr - address to be accessed in note_RAM
 *   RAM_din  - data to be written to note_RAM
 *	  RAM_wren - write enable for note_RAM
 *
 */
module note_input(clk, reset, A, B, C, D, E, F, G, stop,
						full, RAM_addr, RAM_din, RAM_wren);
	input logic clk, reset, A, B, C, D, E, F, G, stop;
	output logic full, RAM_wren;
	output logic [6:0] RAM_addr;
	output logic [2:0] RAM_din;
	
	//define status and control signals
	//status
	logic start, note_press_A, note_press_B, note_press_C, note_press_D, 
         note_press_E, note_press_F, note_press_G, addr_eq_max, still_pressed, stop_load;
			
	//control
	logic reset_wren, set_din_A, set_din_B, set_din_C, set_din_D, set_din_E, 
			set_din_F, set_din_G, set_wren, song_full, incr_addr, load_regs;
	
	//instantiate controller and datapath
	note_input_controller ni_c (.*);
	note_input_datapath ni_d (.*);
	
endmodule  // note_input