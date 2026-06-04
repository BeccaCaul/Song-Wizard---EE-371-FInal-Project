/* Testbench for line drawer */
module note_input_tb (); //line_drawer_tb
	logic clk, reset, A, B, C, D, E, F, G, stop;
	logic full, RAM_wren;
   logic [6:0] RAM_addr;
   logic [2:0] RAM_din;

  //instantiate line_drawer as dut
  note_input dut(.*);
  
  // simulated clock
	 parameter period = 100;
	 initial begin
		clk <= 0;
		forever
			#(period/2)
			clk <= ~clk;
	end // initial clock
	
	integer i;
	initial begin // initial
		A<=0; B<=0; C<=0; D<=0; 
		E<=0; F<=0; G<=0;
		reset <= 1; stop <= 0;@(posedge clk);
		reset <= 0; 			 @(posedge clk);
		A <= 1;					 @(posedge clk);
		A <= 0; B <= 1;		 @(posedge clk);
		B <= 0; C <= 1;		 @(posedge clk);
		C <= 0; D <= 1;		 @(posedge clk);
		D <= 0; E <= 1;		 @(posedge clk);
		E <= 0; F <= 1;		 @(posedge clk);
		F <= 0; G <= 1;		 @(posedge clk);
		G <= 0;					 @(posedge clk);
		A <= 1;     repeat(50)@(posedge clk);
		A <= 0; reset <= 1;	 @(posedge clk);
		
		$stop;																				
	
	end //initial

	
	
endmodule  // note_input_tb