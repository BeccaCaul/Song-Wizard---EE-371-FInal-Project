module background_rom
    #(parameter WIDTH    = 640,
      parameter HEIGHT   = 480,
      parameter MIF_FILE = "background_sw.mif")
    (input  logic        clk,
     input  logic [18:0] addr,
     output logic [WIDTH-1:0] data);

    altsyncram #(
        .operation_mode         ("ROM"),
        .width_a                (WIDTH),
        .widthad_a              (19),
        .numwords_a             (HEIGHT),
        .init_file              (MIF_FILE),
        .init_file_layout       ("PORT_A"),
        .intended_device_family ("Cyclone V"),
        .lpm_hint               ("ENABLE_RUNTIME_MOD=NO"),
        .lpm_type               ("altsyncram"),
        .outdata_reg_a          ("CLOCK0")
    ) rom_inst (
        .clock0     (clk),
        .address_a  (addr),
        .q_a        (data),       
        .aclr0      (1'b0),   .aclr1        (1'b0),
        .address_b  (1'b1),   .addressstall_a(1'b0), .addressstall_b(1'b0),
        .byteena_a  (1'b1),   .byteena_b    (1'b1),
        .clock1     (1'b1),   .clocken0     (1'b1),
        .clocken1   (1'b1),   .clocken2     (1'b1),  .clocken3(1'b1),
        .data_a     ({24{1'b1}}), .data_b   (1'b1),
        .eccstatus  (),        .q_b         (),
        .rden_a     (1'b1),   .rden_b       (1'b1),
        .wren_a     (1'b0),   .wren_b       (1'b0)
    );

endmodule