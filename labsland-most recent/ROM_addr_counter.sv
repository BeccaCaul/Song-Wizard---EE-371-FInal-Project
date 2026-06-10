
/* address counter, iterating through all read addresses in 1 note period: 0-1328*/

module ROM_addr_counter (clk, reset, write, addr); //addr_counter
  input logic clk;
  input logic reset; 
  input logic write;
  output logic [10:0] addr;
  logic max;
  
  //logic [15:0] count;
  
  assign max = (addr == 11'd1328); //max address before 0 frequency is 1328; should move to 0 at next write
  

  always_ff @(posedge clk or posedge reset) begin //always_ff
    if (reset) begin
      addr <= 11'b00000000000; //reset to 0
    end else if (write && !max) begin
		 addr <= addr + 1'b1;
	 end else if (write && max) begin
		 addr <= 11'b00000000000;
	 end else begin
		 addr <= addr; //if not ready, stay at current address
	 end
  end //always_ff
	 
endmodule //ROM_addr_counter