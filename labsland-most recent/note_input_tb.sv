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
		
		// TEST 1: add notes A->G, 1 per slot in RAM.
		// Fill remainder of RAM with A, until full signal is asserted
		// When Full is asserted, no new notes will be loaded (wren disabled)
		// Max # notes loaded to RAM is 120 (addr 1110111)
		reset <= 0; A <= 1;   repeat(2)@(posedge clk);
		A <= 0; B <= 1;		 repeat(2)@(posedge clk);
		B <= 0; C <= 1;		 repeat(2)@(posedge clk);
		C <= 0; D <= 1;		 repeat(2)@(posedge clk);
		D <= 0; E <= 1;		 repeat(2)@(posedge clk);
		E <= 0; F <= 1;		 repeat(2)@(posedge clk);
		F <= 0; G <= 1;		 repeat(2)@(posedge clk);
		G <= 0; A <= 1;		 repeat(2)@(posedge clk);
		for(i=0; i<120; i++) begin
			if(full) begin
				$display("DONE LOADING! Full = %0d. Wren = %0d. T = %4t", full, RAM_wren, $time); @(posedge clk);												
				break;
			end
			$display("Loading. Full = %0d. Wren = %0d. T= %4t", full, RAM_wren, $time); @(posedge clk);
		end
		// TEST 2: FUll asserted, no new values should load (din won't update, wren = 0)
		A <= 0; B <= 1;		 @(posedge clk);
		B <= 0; C <= 1;
		C <= 0; reset <= 1;	 @(posedge clk);
		
		// TEST 3: stop loading when stop asserted
		//         even if notes continue to update
		//			  wren should disable and full should assert
		G <= 1; reset <= 0;	@(posedge clk);
		for(i=0; i<50; i++) begin
		   if (i == 25) begin
				stop <= 1;     @(posedge clk);
			end
			if(stop) begin
				$display("DONE LOADING! Stop = %0d. Full = %0d. Wren = %0d. T = %4t", stop, full, RAM_wren, $time); @(posedge clk);												
				break;
			end
			$display("Loading. Full = %0d. Wren = %0d. Stop = %0d. T= %4t", full, RAM_wren, stop, $time); @(posedge clk);
		end
		G <= 0; A <= 1; stop <= 0;   @(posedge clk);
		G <= 0; A <= 0; reset <= 1;  @(posedge clk);
		
		
		// TEST 4: stop loading from unpressed state
		reset <= 0; A <= 1;   repeat(2)@(posedge clk);
		A <= 0; B <= 1;		 repeat(2)@(posedge clk);
		B <= 0; C <= 1;		 repeat(2)@(posedge clk);
		C <= 0; stop <= 1; 
		$display("DONE LOADING! Full = %0d. Wren = %0d. Stop = %0d. T= %4t", full, RAM_wren, stop, $time);
													@(posedge clk);
									 repeat(5)@(posedge clk);
		
		stop <= 0; 				 repeat(3)@(posedge clk);
		reset <= 1;							 @(posedge clk);
		
		// TEST 5: multiple keys pressed at once
		// if keys pressed at the exact same time: LATEST key in ABCDEFG is taken
		$display("TEST 5: Simultaneous key press. T= %4t", $time);
		reset <= 0; A <= 1; B <= 1; C <= 1;   repeat(6)@(posedge clk); // C loads for 3 words
		C <= 0;            	 					  repeat(2)@(posedge clk); // B loads for 1 word
		B <= 0;        		                 repeat(2)@(posedge clk); // A loads for 1 word
		A <= 0; reset <= 1;    		           repeat(2)@(posedge clk);
		
		// TEST 6:
		// if one key already pressed, adding additional key presses will not affect: 
		// first note continues to load until unpressed
		$display("TEST 6: Adding 2nd press when one key pressed. T= %4t", $time);
		reset <= 0; A <= 1; B <= 0; C <= 0;   repeat(6)@(posedge clk); // A loads for 3 words
		B <= 1;            	 					  repeat(2)@(posedge clk); // A continues to load for 2 words despite B being pressed
		A <= 0; B <= 0; reset <= 1;    		           @(posedge clk);
		$stop;																				
	
	end //initial

	
	
endmodule  // note_input_tb