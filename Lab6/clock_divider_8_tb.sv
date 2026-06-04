module clock_divider_8_tb ();
	parameter MAX_SIM = 5;
	logic clk_8, reset, clk;

  //instantiate as dut
  //connect much smaller count (5) for sim vs. 3125000 in hardware
  clock_divider_8 #(.MAX(MAX_SIM)) dut(.*);
  
  // simulated clock
	 parameter period = 100;
	 initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end // initial clock
	
	integer i;
	initial begin 
			reset = 1; 		   		 @(posedge clk);
			reset = 0;		repeat(20)@(posedge clk);
			reset = 1;					 @(posedge clk);
		@(posedge clk); // extra cycle
		$stop;
	end
endmodule