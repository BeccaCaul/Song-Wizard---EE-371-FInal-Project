`timescale 1 ps / 1 ps
module DE1_SoC_tb ();
  	parameter MAX = 5;
   
	logic CLOCK_50, CLOCK2_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [9:0] LEDR;
	wire [35:0] V_GPIO;
	
	// I2C Audio/Video config interface
	wire FPGA_I2C_SCLK;
	wire FPGA_I2C_SDAT;
	// Audio CODEC
	wire AUD_XCK;
	wire AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	wire AUD_ADCDAT;
	wire AUD_DACDAT;
	
	//testing note input for sim only
	logic test_A, test_B, test_C, test_D, test_E, test_F, test_G, test_reset;
	
  //instantiate task 1 as dut
  DE1_SoC #(MAX) dut(.*);
  
  // simulated clock
	 parameter period = 100;
	 initial begin
		CLOCK_50 <= 0;
		forever
			#(period/2)
			CLOCK_50 <= ~CLOCK_50;
	end // initial clock
	
	integer i;
	initial begin
	//NOTE INPUT TEST 1
			test_A = 0; test_B = 0; test_C = 0;
			test_D = 0; test_E = 0; test_F = 0; test_G = 0;      @(posedge CLOCK_50);
			test_reset = 1;                   						  @(posedge CLOCK_50); //reset
			
			test_reset = 0; test_A = 1;					  repeat(2)@(posedge CLOCK_50);
			test_A = 0; test_B = 1;							  repeat(2)@(posedge CLOCK_50);
			test_B = 0; test_C = 1;							  repeat(2)@(posedge CLOCK_50);
			test_C = 0; test_D = 1;							  repeat(2)@(posedge CLOCK_50);
			test_D = 0; test_E = 1;							  repeat(2)@(posedge CLOCK_50);
			test_E = 0; test_F = 1;							  repeat(2)@(posedge CLOCK_50);
			test_F = 0; test_G = 1;							  repeat(2)@(posedge CLOCK_50);
			test_G = 0; test_A = 1;							  repeat(200)@(posedge CLOCK_50);
			
		@(posedge CLOCK_50); // extra cycle
		$stop;
	end
endmodule