module n8_driver
(
    input logic clk,
    input logic data_in,
	 output logic latch, pulse,
    output logic A,B,C,D,E,F,G
	 
);

    logic[7:0] data_out;
	 
    logic up;
    logic down;
    logic left;
    logic right;
    logic select;
    logic start;
    logic a;
    logic b;
    

    serial_driver #(.BITS(8)) driver (
        .clk(clk),
        .data_in(data_in),
        .latch(latch),
        .pulse(pulse),
        .data_out(data_out)
    );
    
    assign right  = ~data_out[0];
    assign left   = ~data_out[1];
    assign down   = ~data_out[2];
    assign up     = ~data_out[3];
    assign start  = ~data_out[4];
    assign select = ~data_out[5];
    assign b      = ~data_out[6];
    assign a      = ~data_out[7];
	 
	 // Note mapping
	 assign C = left;   //A key
	 assign D = down;   //S key
	 assign E = right;  //D key
	 assign F = select; //H key
	 assign G = start;  //J key
	 assign A = b;      //K key
	 assign B = a;      //L key
    
endmodule