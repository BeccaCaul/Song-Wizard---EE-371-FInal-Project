// image_display.sv
// Reads from a ROM, overrides a rectangular region when trigger is high.
module get_image
    #(parameter WIDTH  = 640,
      parameter HEIGHT = 480,
      // Rectangle to override (in image pixels)
      parameter RECT_X0 = 100,
      parameter RECT_Y0 = 100,
      parameter RECT_X1 = 200,  
      parameter RECT_Y1 = 200,   
      // Color to paint when triggered
      parameter [7:0] RECT_R = 8'hFF,
      parameter [7:0] RECT_G = 8'hFF,
      parameter [7:0] RECT_B = 8'hFF)
    (input  logic        CLOCK_50,
     input  logic        reset,
     input  logic        trigger,   // when high, paint rectangle

     // VGA outputs
     output logic [7:0]  VGA_R, VGA_G, VGA_B,
     output logic        VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
    logic [9:0] x;
    logic [8:0] y;
    logic [7:0] r, g, b;

    video_driver #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) vd ( .CLOCK_50, .reset, .x, .y, .CLOCK_25,
        .r, .g, .b, .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, 
		  .VGA_VS);

    logic [9:0] x_next;
    logic [8:0] y_next;

    always_ff @(posedge CLOCK_25) begin  
        x_next <= x;
        y_next <= y;
    end

    logic [WIDTH-1:0] rom_q;
    logic rom_pixel;
    assign rom_pixel = rom_q[WIDTH - 1 - x_next]; 
    logic [$clog2(HEIGHT)-1:0] rom_addr;
    assign rom_addr = y_next;

    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("song_wizard_wip.mif")) rom ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (rom_q));

    logic in_rect;
    assign in_rect = (x_next >= RECT_X0) && (x_next < RECT_X1) &&
                 (y_next >= RECT_Y0) && (y_next < RECT_Y1);

    
    always_comb begin
        if(trigger && in_rect) begin
            r = 8'hFF;
            g = 8'h00;
            b = 8'h00;
        end
        else if (rom_pixel) begin ///change later to handle color
            r = 8'hFF;
            g = 8'hFF;
            b = 8'hFF;
        end
        else begin
            r = 8'h00;
            g = 8'h00;
            b = 8'h00;
        end
    end
    

endmodule