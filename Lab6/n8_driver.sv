module n8_driver
(
    input clk,
    input data_in,
    output reg latch,
    output reg pulse,
//    output reg up,
//    output reg down,
//    output reg left,
//    output reg right,
//    output reg select,
//    output reg start,
//    output reg a,
//    output reg b
	 output reg A,
	 output reg B,
	 output reg C,
	 output reg D,
	 output reg E,
	 output reg F,
	 output reg G
);

    reg[7:0] data_out;
    

    serial_driver #(.BITS(8)) driver (
        .clk(clk),
        .data_in(data_in),
        .latch(latch),
        .pulse(pulse),
        .data_out(data_out)
    );
    
    assign C  = ~data_out[0];
    assign A  = ~data_out[1];
    assign B  = ~data_out[2];
    //assign up     = ~data_out[3];
    assign E  = ~data_out[4];
    assign D  = ~data_out[5];
    assign F  = ~data_out[6];
    assign G  = ~data_out[7];
    
endmodule