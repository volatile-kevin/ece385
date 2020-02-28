module registerUnit(
                    input logic Clk, Reset, LDREG,
                    input logic DR, SR1,
                    input logic [2:0] SR2,
                    input logic [15:0] bus_data,                     input logic [15:0] bus_data, 
                    input logic [15:0] IR, 
                    output logic [15:0] SR1_out, SR2_out
);

logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
logic [2:0] DR_mux_out, SR1_mux_out;
logic ld_r0, ld_r1, ld_r2, ld_r3, ld_r4, ld_r5, ld_r6, ld_r7;

always_comb
    begin
        case(SR2)
        3b'000 : 
            begin
                SR2_out = r0;
            end
        3b'001 : 
            begin
                SR2_out = r1; 
            end
        3b'010 : 
            begin
                SR2_out = r2;    
            end
        3b'011 : 
            begin
                SR2_out = r3; 
            end
        3b'100 : 
            begin
                SR2_out = r4;   
            end
        3b'101 : 
            begin
                SR2_out = r5;   
            end
        3b'110 : 
            begin
                SR2_out = r6;       
            end
        3b'111 : 
            begin
                SR2_out = r7;   
            end
    end
mux2_3 DR_mux(
    .select(DR), .data_in_1(3'b111), .data_in_2(IR[11:9]), 
    .data_out(SR1_mux_out)
);

mux2_3 SR1_mux(
    .select(SR1), .data_in_1(IR[11:9]), .data_in_2(IR[8:6]), 
    .data_out(DR_mux_out)
);

register16 R0(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r0),
	.data_out(r0)
);
register16 R1(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r1),
	.data_out(r1)
);
register16 R2(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r2),
	.data_out(r2)
);
register16 R3(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r3),
	.data_out(r3)
);
register16 R4(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r4),
	.data_out(r4)
);
register16 R5(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r5),
	.data_out(r5)
);
register16 R6(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r6),
	.data_out(r6)
);
register16 R7(
    .Clk(Clk), .Reset(Reset), .data_in(bus_data), .Load_Enable(ld_r7),
	.data_out(r7)
);

endmodule