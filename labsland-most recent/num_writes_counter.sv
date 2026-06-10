
/* num_writes counter
* inputs: write, full
* outputs: RAM_read_addr, all_done
*
*/

module num_writes_counter (clk, reset, full, write, addr, all_done); //num_writes_counter
  input logic clk;
  input logic reset; 
  input logic write;
  input logic full;
  output logic [6:0] addr;
  output logic all_done;
  logic [13:0] num_writes;
  //parameter MAX_NUM_WRITES = 6250;
  parameter MAX_NUM_WRITES = 12500;
  parameter MAX_RAM_ADDR = 119;
  

  always_ff @(posedge clk or posedge reset) begin //always_ff
    if (reset) begin
      addr <= 7'b0000000; //reset to 0
		num_writes <= 0;
		all_done <= 0;
    end else if (full) begin
		 if (addr <= MAX_RAM_ADDR) begin
			if (write && !(num_writes == MAX_NUM_WRITES-1)) begin
				num_writes <= num_writes + 1;
			end else if (write && (num_writes == MAX_NUM_WRITES-1)) begin
				num_writes <= 0;
				addr <= addr + 1;
			end
		 end else begin
		   all_done <= 1;
		 end
	 end
  end //always_ff
  
	 
endmodule //num_writes_counter