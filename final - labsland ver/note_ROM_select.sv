module note_ROM_select (clk, reset, ID, addr, dout); // note_ROM_select
  input logic clk;
  input logic reset;
  input logic [2:0] ID; 
  input logic [15:0] addr;
  output logic [23:0] dout;
  logic [23:0] dout_A, dout_B, dout_C, dout_D, dout_E, dout_F, dout_G;
  
  parameter [2:0] A_ID = 3'b001;
  parameter [2:0] B_ID = 3'b010;
  parameter [2:0] C_ID = 3'b011;
  parameter [2:0] D_ID = 3'b100;
  parameter [2:0] E_ID = 3'b101;
  parameter [2:0] F_ID = 3'b110;
  parameter [2:0] G_ID = 3'b111;  
  
  //instantiate note ROMS A,B,C,D,E,F,G
    A4_ROM A4 (.address(addr), .clock(clk), .q(dout_A));
    B4_ROM B4 (.address(addr), .clock(clk), .q(dout_B));
    C4_ROM C4 (.address(addr), .clock(clk), .q(dout_C));
    D4_ROM D4 (.address(addr), .clock(clk), .q(dout_D));
    E4_ROM E4 (.address(addr), .clock(clk), .q(dout_E));
    F4_ROM F4 (.address(addr), .clock(clk), .q(dout_F));
    G4_ROM G4 (.address(addr), .clock(clk), .q(dout_G));
  
  //case statement: select dout based on ID
  always_comb begin
  
	case(ID)
		
		A_ID: dout = dout_A;
		B_ID: dout = dout_B;
   	    C_ID: dout = dout_C;
 		D_ID: dout = dout_D;
 		E_ID: dout = dout_E;
 		F_ID: dout = dout_F;
 		G_ID: dout = dout_G;
		
		default: dout = 0;
		
	endcase
  
  end
  
  

endmodule // note_ROM_select