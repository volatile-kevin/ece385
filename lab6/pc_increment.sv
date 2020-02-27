module pc_increment(
    input logic [15:0] in,
    output logic [15:0] out
);

assign out = in + 1'b1;

endmodule
