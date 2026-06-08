module DE1_SoC #(parameter MAX = 3125000) (CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO,KEY);

	input logic CLOCK_50, CLOCK2_50;
   input logic [3:0] KEY;
   //logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	inout [35:4] V_GPIO;
	
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	//test notes (to avoid testing N8 in sim) - must add back to de1_soc port statement & tb to use
	//input logic test_A, test_B, test_C, test_D, test_E, test_F, test_G, test_reset;
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic reset;
	logic CLOCK_8;
	//logic done;
	logic all_done;
	
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
    
    //assign LEDR[0] = pulse;
    //assign LEDR[1] = latch;
	 //assign LEDR[0] = audio_start;
// 	 assign LEDR[0] = full;
// 	 assign LEDR[1] = all_done;
// 	 assign LEDR[9] = B;
// 	 assign LEDR[8] = (RAM_dout == 3'b010);
    
//     assign LEDR[2] = V_GPIO[28];
//     assign LEDR[3] = V_GPIO[29]; // gpio 19 of RPico
//     assign LEDR[4] = V_GPIO[30]; // gpio 20 of RPico
    
//     assign LEDR[5] = V_GPIO[10]; // sw5; for debugging
//     assign LEDR[6] = V_GPIO[11]; // sw6; for debugging
//     assign LEDR[7] = V_GPIO[12]; // sw7; for debugging
    
	 assign LEDR[1] = full;
	 assign LEDR[0] = all_done;
	 
	 
	 assign LEDR[9] = C;
	 assign LEDR[8] = D;
	 assign LEDR[7] = E;
	 assign LEDR[6] = F;
	 assign LEDR[5] = G;
	 assign LEDR[4] = A;
	 assign LEDR[3] = B;
	 assign LEDR[2] = V_GPIO[28]; // gpio 20 of RPico
	 
	 assign reset = ~KEY[3];
	 assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;

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
	
	// SELECT SIGNALS - dependent on loading vs. output phase ---------------

	// RAM addr: note_in_RAM_addr when !full, RAM_read_addr when full
	logic [6:0] RAM_addr, RAM_read_addr;
	assign RAM_addr = full ? RAM_read_addr : note_in_RAM_addr;
	
	// ROM addr: dout of ROM counter when in audio output phase, otherwise 0
	logic [2:0] note_ROM_ID;
	assign note_ROM_ID = full ? RAM_dout : 3'b000;
	
	// Note Input ASMD ------------------------------------------------------
	logic [6:0] note_in_RAM_addr;
	logic [2:0] RAM_din, RAM_dout;
	logic full;
	logic RAM_wren, stop;

	assign stop = 0; //UPDATE SW to something other than switches
	
	//for sim
	//note_input note_loader_sim (.clk(CLOCK_50), .reset(test_reset), .A(test_A), .B(test_B), .C(test_C), .D(test_D), .E(test_E), .F(test_F), .G(test_G), 
	                            //.stop, .full, .RAM_addr, .RAM_din, .RAM_wren);
	//HARDWARE ONLY
	note_input note_loader (.clk(CLOCK_8), .reset, .A, .B, .C, .D, .E, .F, .G, .stop, .full, .RAM_addr(note_in_RAM_addr), .RAM_din, .RAM_wren);
	
	// RAM 120x3  -----------------------------------------------------------
	// connected to CLOCK_50 because slow->fast read shouldn't cause issues
	// can synchronize RAM_din, RAM_addr, and RAM_wren with 2xDFF as needed!
	note_ram120x3 user_notes_RAM (.address(RAM_addr), .clock(CLOCK_50), .data(RAM_din), .wren(RAM_wren), .q(RAM_dout));
	// ----------------------------------------------------------------------

	//PLAYOUT TEST: make sure CODEC works

//	assign writedata_left = readdata_left;
//	
//	assign writedata_right = readdata_right;
//
//	assign read = read_ready && write_ready;
//	
//	assign write = read_ready && write_ready;
	
	//ROM address counter module
	//address is passed into ROM select - "sample address"
	logic [10:0] ROM_addr;
	ROM_addr_counter ROM_count (.clk(CLOCK_50), .reset, .write, .addr(ROM_addr));
	
	//Note ROM select module
	//instantiates NOTE ROMs and selects dout based on note_ROM_ID output from ASMD
	// inputs: note_ROM_ID (dout of note_RAM), ROM_addr
	// outputs: dout that connects to writedata
	logic [23:0] sample_dout;
	note_ROM_select rom_select (.clk(CLOCK_50), .reset, .ID(note_ROM_ID), .addr(ROM_addr), .dout(sample_dout));
	
	
	//num_writes counter
	/* Handles audio output phase - triggered by full
	*  For each note loaded in RAM, loops through 12500 writes to CODEC
	*  writes are determined by read_ready && write_ready
	* asserts all_done when all writes have completed for all notes
	*/
	num_writes_counter num_writes (.clk(CLOCK_50), .reset, .full, .write, .addr(RAM_read_addr), .all_done);
	
	//CODEC output - begins when full is asserted
	assign read = full ? (read_ready && write_ready) : 1'b0;
	assign write = full ? (read_ready && write_ready) : 1'b0;
	assign writedata_left = sample_dout;
	assign writedata_right = sample_dout;
	
///////////////////////////////////////////////////////////////////////////////
//Audio CODEC interface. 
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
///////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


