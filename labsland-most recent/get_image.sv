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
     input  logic        A,
     input  logic        B,
     input  logic        C,
     input  logic        D,
     input  logic        E,
     input  logic        F,
     input  logic        G,
     input  logic        full,
     input  logic        all_done,

     // VGA outputs
     output logic [7:0]  VGA_R, VGA_G, VGA_B,
     output logic        VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
    logic [9:0] x;
    logic [8:0] y;
    logic [7:0] red, green, blue;

    video_driver #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) vd ( .CLOCK_50, .reset, .x, .y, .CLOCK_25,
        .r(red), .g(green), .b(blue), .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, 
		  .VGA_VS);

    logic [9:0] x_next;
    logic [8:0] y_next;

    always_ff @(posedge CLOCK_25) begin  
        x_next <= x;
        y_next <= y;
    end
    
    logic [WIDTH-1:0] bg_q, a_q, b_q, c_q, d_q, e_q, f_q, g_q, done_q, load_q;
    logic [WIDTH-1:0] rom_q;

    logic rom_pixel;
    assign rom_pixel = rom_q[WIDTH - 1 - x_next]; 
    logic [$clog2(HEIGHT)-1:0] rom_addr;
    assign rom_addr = y_next;

    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("background_sw.mif")) background ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (bg_q));
        
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("anote_sw.mif")) a_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (a_q));

    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("bnote_sw.mif")) b_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (b_q));
        
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("cnote_sw.mif")) c_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (c_q));
      
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("dnote_sw.mif")) d_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (d_q));  
    
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("enote_sw.mif")) e_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (e_q));
        
     background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("fnote_sw.mif")) f_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (f_q));
        
     background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("gnote_sw.mif")) g_note ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (g_q));
        
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("done_sw.mif")) done ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (done_q));
        
    background_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE("load_sw.mif")) load ( .clk  (CLOCK_25),
        .addr (rom_addr), .data (load_q));
        
    logic in_rect;
    

    always_comb begin
        if (reset) begin
            rom_q = bg_q; 
            in_rect = 1'b0;
        end else if (all_done) begin
            rom_q = done_q;
            in_rect = 1'b0;
        end else if (full) begin
            rom_q = load_q;
            in_rect = 1'b0;
        end else if (A) begin
            rom_q = a_q;
            in_rect = (x_next >= 10'd428) && (x_next < 10'd498) &&
                  (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (B) begin
            rom_q = b_q;
            in_rect = (x_next >= 10'd502) && (x_next < 10'd579) &&
                  (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (C) begin
            rom_q = c_q;
            in_rect = (x_next >= 10'd52) && (x_next < 10'd130) &&
                 (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (D) begin
            rom_q = d_q;
            in_rect = (x_next >= 10'd134) && (x_next < 10'd204) &&
                 (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (E) begin
            rom_q = e_q;
            in_rect = (x_next >= 10'd208) && (x_next < 10'd275) &&
                 (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (F) begin
            rom_q = f_q;
            in_rect = (x_next >= 10'd280) && (x_next < 10'd353) &&
                  (y_next >= 9'd385) && (y_next < 9'd453);
        end else if (G) begin
            rom_q = g_q;
            in_rect = (x_next >= 10'd357) && (x_next < 10'd424) &&
                  (y_next >= 9'd385) && (y_next < 9'd453);
        end else begin
            rom_q = bg_q; 
            in_rect = 1'b0;
        end
    end

    always_comb begin
        red   = 8'h00;
        green = 8'h00;
        blue  = 8'h00;
        if(in_rect) begin
            if(A) begin
                red = 8'd195; 
                blue = 8'd216;
                green = 8'd125; 
            end else if (B) begin
                red = 8'd233;
                blue = 8'd163; 
                green = 8'd103;
            end else if (C) begin
                red   = 8'd253;
                green = 8'd94;
                blue  = 8'd94;
            end else if (D) begin
                red = 8'd255;
                green = 8'd165;
                blue = 8'd75;
            end else if (E) begin
                red = 8'd255;
                green = 8'd236;
                blue = 8'd131;
            end else if (F) begin
                red = 8'd107;
                green = 8'd224;
                blue = 8'd144;
            end else if (G) begin
                red = 8'd118;
                green = 8'd184;
                blue = 8'd248;
            end
        end
        else if (rom_pixel) begin ///change later to handle color
            red = 8'hFF;
            green = 8'hFF;
            blue = 8'hFF;
        end
        else begin
            red = 8'd58;
            green = 8'd30;
            blue = 8'd67;
        end
    end
    

endmodule