//FIR filter module applying moving average techniques to a FIFO buffer system
//Filters out noise in external and internal audio inputs
module FIR_filter (clk, reset, r_enable, w_enable, din, dout);
	
	parameter n = 8;
	parameter w = 24;
	
	input logic clk, reset, r_enable, w_enable; 
	input logic [w-1:0] din;
	output logic [w-1:0] dout;
	
	
	logic [w-1:0] divided;
	assign divided = {{n{din[w-1]}}, din[w-1:n]};
	
	//instantiate for accumulator
	logic [w-1:0] accum; //accumulator
	logic [w-1:0] x_buffered; //output from fifo queue
	logic [w-1:0] sum1;
	
	//instantiate for buffer
	localparam ADDR_WIDTH = $clog2(n); //get log of n
	logic [ADDR_WIDTH-1:0] w_addr, r_addr;
   logic buff_full;
	
	//instantiate fifo and registers
   fifo_ctrl #(ADDR_WIDTH) c_unit (.clk(clk),.reset (reset), .rd (r_enable),.wr(w_enable),
        .empty(),.full(buff_full),.w_addr (w_addr),.r_addr (r_addr));
   reg_file #(w, ADDR_WIDTH) r_unit (.clk(clk),.w_data (divided),.w_en(w_enable),.w_addr(w_addr),
        .r_addr (r_addr),.r_data (x_buffered));
	
  //add datain/N and buffered datain/N
  assign sum1 = divided - x_buffered;

  //accumulator of output
  always @(posedge clk or posedge reset) begin
      if (reset)
          accum <= '0; 
      else if (r_enable)
          accum <= accum + sum1; // Accumulate output + sum1
  end
  
  assign dout = accum;
endmodule //FIR_filter