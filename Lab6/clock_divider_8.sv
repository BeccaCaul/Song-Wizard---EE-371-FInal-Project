/* 8Hz clock divider counter*/
/* For use of note_input module polling for User input */

module clock_divider_8 #(parameter MAX = 3125000) (clk, reset, clk_8); //clock_divider
  input logic clk;
  input logic reset;    
  output logic clk_8;
  
  // 50,000,000 / 8 = 6,250,000. 1 8Hz cycle per 6,250,000 CLOCK_50 cycles
  // Toggle clock every 6,250,000 / 2 cycles = 3,125,000 cycles
  // Need 22 bits to hold 3,125,000 count
  logic [21:0] counter;

  always_ff @(posedge clk or posedge reset) begin //always_ff
    if (reset) begin
      counter <= 22'd0;
      clk_8 <= 1'b0;
    end 
	 else 
		begin
			if (counter == MAX-1) begin
				counter <= 22'd0;
				clk_8 <= ~clk_8;
			end else begin
				counter <= counter + 1'b1;
			end
		end
  end //always_ff

endmodule //read_counter