module addr_unit(
    input logic [15:0] IR,
    input logic [15:0] SR1,
    input logic [15:0] PC,
    input logic [1:0] ADDR2MUX_select,
    input logic ADDR1MUX,
    output logic [15:0] addr_out
);

logic [15:0] ADDR2MUX_0, ADDR2MUX_1, ADDR2MUX_2, ADDR2_OUT, ADDR1_OUT;

sext_6_16 sext0(
    .in(IR[5:0]), .out(ADDR2MUX_2)
);

sext_9_16 sext1(
    .in(IR[8:0]), .out(ADDR2MUX_1)
);

sext_11_16 sext2(
    .in(IR[10:0]), .out(ADDR2MUX_0)
);

mux4_16 addr2mux(
    .select(ADDR2MUX_select), .data_in_3(ADDR2MUX_2), .data_in_2(ADDR2MUX_1), .data_in_1(ADDR2MUX_0),
    .data_out(ADDR2_OUT)
);

mux2_16 addr1mux(
    .select(), .data_in_1(SR1), .data_in_2(PC), 
    .data_out(ADDR1_OUT)
);

assign addr_out = ADDR1_OUT + ADDR2_OUT;

endmodule