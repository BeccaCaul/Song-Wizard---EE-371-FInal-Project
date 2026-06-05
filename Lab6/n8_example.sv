//module n8_example (
//    input CLOCK_50,
//    inout [35:0] V_GPIO,
//    output [9:0] LEDR);
//    
//	 //wires
//	 logic A;
//	 logic B;
//	 logic C;
//	 logic D;
//	 logic E;
//	 logic F;
//	 logic G;
//	 
////	 assign A_out = A;
////	 assign B_out = B;
////	 assign C_out = C;
////	 assign D_out = D;
////	 assign E_out = E;
////	 assign F_out = F;
////	 assign G_out = G;
//	 
//	 logic latch;
//	 logic pulse;
//		
//    assign V_GPIO[27] = pulse;
//    assign V_GPIO[26] = latch;
//    
//    assign LEDR[0] = pulse;
//    assign LEDR[1] = latch;
//    
//    assign LEDR[2] = V_GPIO[28];
//    assign LEDR[3] = V_GPIO[29]; // gpio 19 of RPico
//    assign LEDR[4] = V_GPIO[30]; // gpio 20 of RPico
//    
//    assign LEDR[5] = V_GPIO[10]; // sw5; for debugging
//    assign LEDR[6] = V_GPIO[11]; // sw6; for debugging
//    assign LEDR[7] = V_GPIO[12]; // sw7; for debugging
//
//
//    n8_driver driver(
//        .clk(CLOCK_50),
//        .data_in(V_GPIO[28]),
//        .latch(latch),
//        .pulse(pulse),
//        .A(A),
//		  .B(B),
//		  .C(C),
//		  .D(D),
//		  .E(E),
//		  .F(F),
//		  .G(G)
//    );
//
//
//
//
//endmodule