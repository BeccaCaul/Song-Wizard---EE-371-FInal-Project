module DE1_SoC #(parameter MAX = 3125000) (CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO,
	test_A, test_B, test_C, test_D, test_E, test_F, test_G, test_reset);

	input logic CLOCK_50, CLOCK2_50;
//	input logic [3:0] KEY;
//	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	inout [35:0] V_GPIO;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	//test notes (to avoid testing N8 in sim)
	input logic test_A, test_B, test_C, test_D, test_E, test_F, test_G, test_reset;
	
	// Local wires
//	logic read_ready, write_ready, read, write;
//	logic signed [23:0] readdata_left, readdata_right;
//	logic signed [23:0] writedata_left, writedata_right;
//	logic signed [23:0] task2_left, task2_right, task3_left, task3_right;
//	logic signed [23:0] noisy_left, noisy_right;
	logic reset;
	logic CLOCK_8;
	
	// N8 Controller
	//note presses
	 logic A;
	 logic B;
	 logic C;
	 logic D;
	 logic E;
	 logic F;
	 logic G;
	 
	 logic latch;
	 logic pulse;
		
    assign V_GPIO[27] = pulse;
    assign V_GPIO[26] = latch;
    
    assign LEDR[0] = pulse;
    assign LEDR[1] = latch;
    
    assign LEDR[2] = V_GPIO[28];
    assign LEDR[3] = V_GPIO[29]; // gpio 19 of RPico
    assign LEDR[4] = V_GPIO[30]; // gpio 20 of RPico
    
    assign LEDR[5] = V_GPIO[10]; // sw5; for debugging
    assign LEDR[6] = V_GPIO[11]; // sw6; for debugging
    assign LEDR[7] = V_GPIO[12]; // sw7; for debugging

	 //instantiate driver
    n8_driver driver(
        .clk(CLOCK_50),
        .data_in(V_GPIO[28]),
        .latch(latch),
        .pulse(pulse),
        .A(A),
		  .B(B),
		  .C(C),
		  .D(D),
		  .E(E),
		  .F(F),
		  .G(G)
    );
	
	// Clock divider ------------------------------------------------------
   // Use CLOCK_8 for note_input module
   clock_divider_8 #(.MAX(MAX)) c8 (.clk(CLOCK_50), .reset, .clk_8(CLOCK_8));
	
	// Note Input ASMD ------------------------------------------------------
	logic [6:0] RAM_addr;
	logic [2:0] RAM_din, RAM_dout;
	logic full;
	logic RAM_wren, stop;
	//TODO: assign notes to their N8 controller keys
	assign stop = 0; //UPDATE SW to something other than switches
	
	//for sim
	note_input note_loader_sim (.clk(CLOCK_50), .reset(test_reset), .A(test_A), .B(test_B), .C(test_C), .D(test_D), .E(test_E), .F(test_F), .G(test_G), 
	                            .stop, .full, .RAM_addr, .RAM_din, .RAM_wren);
	//HARDWARE ONLY
	//note_input note_loader (.clk(CLOCK_8), .reset, .A, .B, .C, .D, .E, .F, .G, .stop, .full, .RAM_addr, .RAM_din, .RAM_wren);
	
	// RAM 120x3  -----------------------------------------------------------
	// connected to CLOCK_50 because slow->fast read shouldn't cause issues
	// can synchronize RAM_din, RAM_addr, and RAM_wren with 2xDFF as needed!
	note_ram120x3 user_notes_RAM (.address(RAM_addr), .clock(CLOCK_50), .data(RAM_din), .wren(RAM_wren), .q(RAM_dout));
	// ----------------------------------------------------------------------
	
	
//	logic [23:0] noise;
//	noise_gen noise_generator (.clk(CLOCK_50), .en(read), .rst(reset), .out(noise));
//	assign noisy_left = readdata_left + noise;
//	assign noisy_right = readdata_right + noise;
//	
//	always_comb begin
//		case(KEY[2:0])
//			3'b110: begin // KEY0 outputs noise
//				writedata_left = noisy_left;
//				writedata_right = noisy_right;
//			end
//			3'b101: begin // KEY1 outputs task2 filtered noise
//				writedata_left = task2_left;
//				writedata_right = task2_right;
//			end
//			3'b011: begin // KEY2 outputs task3 filtered noise
//				writedata_left = task3_left;
//				writedata_right = task3_right;
//			end
//			default: begin // default output raw data
//				writedata_left = readdata_left;
//				writedata_right = readdata_right;
//			end
//		endcase
//	end
//
//	assign reset = ~KEY[3];
//	assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
//	assign LEDR = SW;
//	
//	// only read or write when both are possible
//	assign read = read_ready & write_ready;
//	assign write = read_ready & write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
//	clock_generator my_clock_gen(
//		// inputs
//		CLOCK2_50,
//		1'b0,
//
//		// outputs
//		AUD_XCK
//	);
//
//	audio_and_video_config cfg(
//		// Inputs
//		CLOCK_50,
//		1'b0,
//
//		// Bidirectionals
//		FPGA_I2C_SDAT,
//		FPGA_I2C_SCLK
//	);
//
//	audio_codec codec(
//		// Inputs
//		CLOCK_50,
//		1'b0,
//
//		read,	write,
//		writedata_left, writedata_right,
//
//		AUD_ADCDAT,
//
//		// Bidirectionals
//		AUD_BCLK,
//		AUD_ADCLRCK,
//		AUD_DACLRCK,
//
//		// Outputs
//		read_ready, write_ready,
//		readdata_left, readdata_right,
//		AUD_DACDAT
//	);

endmodule


