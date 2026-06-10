module write_pulse (clk, reset, write, pulse);

	input logic clk, reset;
	input logic write;
	output logic pulse;
	
	logic prev;
	
	always_ff @(posedge clk) begin
		pulse <= write && !prev;
		prev <= write;
	end


endmodule 