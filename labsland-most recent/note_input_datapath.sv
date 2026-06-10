//this is the datapath for the note input module. it takes in control signals
//from the controller and updates status signals accordingly

module note_input_datapath (clk, reset, A, B, C, D, E, F, G, stop,
									 reset_wren, set_din_A, set_din_B, set_din_C, set_din_D, set_din_E, 
									 set_din_F, set_din_G, set_wren, song_full, incr_addr, load_regs,
                            RAM_addr, RAM_din, RAM_wren, full, start, 
									 note_press_A, note_press_B, note_press_C, note_press_D,
									 note_press_E, note_press_F, note_press_G, addr_eq_max, still_pressed, stop_load);
	
	// port definitions
	
	//port definitions
	input logic clk, reset;
	input logic A, B, C, D, E, F, G, stop;
	output logic [6:0] RAM_addr;
	output logic [2:0] RAM_din;
	output logic RAM_wren;
	output logic full;
	output logic start, note_press_A, note_press_B, note_press_C, note_press_D, 
                note_press_E, note_press_F, note_press_G, addr_eq_max, still_pressed, stop_load; //status signals
	//control signals
	input logic reset_wren, set_din_A, set_din_B, set_din_C, set_din_D, set_din_E, set_din_F, set_din_G, 
	            set_wren, song_full, incr_addr, load_regs;
	
	//parameters
	parameter [2:0] A_ID = 3'b001;
	parameter [2:0] B_ID = 3'b010;
	parameter [2:0] C_ID = 3'b011;
	parameter [2:0] D_ID = 3'b100;
	parameter [2:0] E_ID = 3'b101;
	parameter [2:0] F_ID = 3'b110;
	parameter [2:0] G_ID = 3'b111;
	parameter [6:0] MAX_ADDR = 7'b1110111;
	
	// datapath logic
	always_ff @(posedge clk) begin
		if (reset_wren) begin
			RAM_wren <= 0;
		end
		if (set_wren) begin
			RAM_wren <= 1;
		end
		if (set_din_A) begin
			RAM_din <= A_ID;
		end
		if (set_din_B) begin
			RAM_din <= B_ID;
		end
		if (set_din_C) begin
			RAM_din <= C_ID;
		end
		if (set_din_D) begin
			RAM_din <= D_ID;
		end
		if (set_din_E) begin
			RAM_din <= E_ID;
		end
		if (set_din_F) begin
			RAM_din <= F_ID;
		end
		if (set_din_G) begin
			RAM_din <= G_ID;
		end
		if (song_full) begin
			full <= 1;
		end
		if (incr_addr) begin
			RAM_addr <= RAM_addr + 1'b1;
		end
		if (load_regs) begin
			RAM_addr <= 7'b0000000;
			RAM_din <= 3'b000;
			RAM_wren <= 1'b0;
			full <= 0;
		end
	end //always_ff
	
	//assign ouputs
	assign start = !full && !stop;
	assign note_press_A = A;
	assign note_press_B = B;
	assign note_press_C = C;
	assign note_press_D = D;
	assign note_press_E = E;
	assign note_press_F = F;
	assign note_press_G = G;
	assign addr_eq_max = RAM_addr == MAX_ADDR;
	assign still_pressed = (A && RAM_din == A_ID) |
								  (B && RAM_din == B_ID) |
								  (C && RAM_din == C_ID) |
								  (D && RAM_din == D_ID) |
								  (E && RAM_din == E_ID) |
								  (F && RAM_din == F_ID) |
								  (G && RAM_din == G_ID);
	assign stop_load = stop;
	


endmodule 