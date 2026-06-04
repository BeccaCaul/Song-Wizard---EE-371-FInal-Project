//this is the controller for the note input portion of the Song Wizard
//this system operates on an 8Hz clock to appropriately track real time key presses
//The controller module includes:
// status signals (inputs): start, note_press_X, addr_eq_max, still_pressed
// control signals (outputs): reset_wren, set_din, set_wren, song_full
//
module note_input_controller (clk, reset, start, note_press_A, note_press_B, note_press_C, note_press_D, 
                              note_press_E, note_press_F, note_press_G, addr_eq_max, still_pressed,
										reset_wren, set_din_A, set_din_B, set_din_C, set_din_D, set_din_E, set_din_F, set_din_G,
										set_wren, song_full, incr_addr, load_regs);

	//port definitions
	input logic clk, reset;
	input logic start, note_press_A, note_press_B, note_press_C, note_press_D, 
               note_press_E, note_press_F, note_press_G, addr_eq_max, still_pressed; //status signals
	//control signals
	output logic reset_wren, set_din_A, set_din_B, set_din_C, set_din_D, set_din_E, set_din_F, set_din_G, 
	             set_wren, song_full, incr_addr, load_regs;
  
  // define state names and variables
  enum logic [1:0] {S0, S1, S2, S3} ps, ns;

  // next state logic
  always_comb begin
	   case (ps)
			 //S0: ns = start ? S1 : S3;
			 S0: ns = S1;
			 S1:
				if (!start) begin
					ns = S3;
				end else if (!note_press_A && !note_press_B && !note_press_C &&
								 !note_press_D && !note_press_E && !note_press_F && !note_press_G) begin
					ns = S1;
				end else begin
					ns = S2;
				end
			 S2:
				if (addr_eq_max) begin
					ns = S3;
				end else if (still_pressed) begin
					ns = S2;
				end else begin
					ns = S1;
				end
			 S3: ns = S3;
	   endcase
  end //always_comb
  
  	// FSM Outputs - control signals
	assign reset_wren = ((ps == S2) && !addr_eq_max && !still_pressed) | (ps == S3);
	assign set_din_A = (ps == S1) && note_press_A;
	assign set_din_B = (ps == S1) && note_press_B;
	assign set_din_C = (ps == S1) && note_press_C;
	assign set_din_D = (ps == S1) && note_press_D;
	assign set_din_E = (ps == S1) && note_press_E;
	assign set_din_F = (ps == S1) && note_press_F;
	assign set_din_G = (ps == S1) && note_press_G;
	assign set_wren = ((ps == S1) && note_press_A) |
							((ps == S1) && note_press_B) |
							((ps == S1) && note_press_C) |
							((ps == S1) && note_press_D) |
							((ps == S1) && note_press_E) |
							((ps == S1) && note_press_F) |
							((ps == S1) && note_press_G);
	assign song_full = ps == S3;
	assign incr_addr = (ps == S2) && !addr_eq_max;
	assign load_regs = (ps == S0);
	
							
	// controller logic w/ synchronous reset
	always_ff @(posedge clk)
		if (reset)
			ps <= S0;
		else
			ps <= ns;
  
  
endmodule // note_input_controller