module registerUnit(
                    input logic Clk, Reset, LD_REG,
                    input logic DR_select, SR1_select,
                    input logic [2:0] SR2,
                    input logic [15:0] bus_data,
                    input logic [15:0] IR, 
                    output logic [15:0] SR1_out, SR2_out
);

logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
logic [2:0] DR_mux_out, SR1_mux_out;
logic ld_r0, ld_r1, ld_r2, ld_r3, ld_r4, ld_r5, ld_r6, ld_r7;

always_comb
    begin
        case(SR2)
        3'b000 : 
            begin
                SR2_out = r0;
            end
        3'b001 : 
            begin
                SR2_out = r1; 
            end
        3'b010 : 
            begin
                SR2_out = r2;    
            end
        3'b011 : 
            begin
                SR2_out = r3; 
            end
        3'b100 : 
            begin
                SR2_out = r4;   
            end
        3'b101 : 
            begin
                SR2_out = r5;   
            end
        3'b110 : 
            begin
                SR2_out = r6;       
            end
        3'b111 : 
            begin
                SR2_out = r7;   
            end
			endcase
    end

always_comb
    begin
        case(SR1_mux_out)
        3'b000 : 
            begin
                SR1_out = r0;
            end
        3'b001 : 
            begin
                SR1_out = r1; 
            end
        3'b010 : 
            begin
                SR1_out = r2;    
            end
        3'b011 : 
            begin
                SR1_out = r3; 
            end
        3'b100 : 
            begin
                SR1_out = r4;   
            end
        3'b101 : 
            begin
                SR1_out = r5;   
            end
        3'b110 : 
            begin
                SR1_out = r6;       
            end
        3'b111 : 
            begin
                SR1_out = r7;   
            end
		endcase
    end

always_comb
    begin
        case(DR_mux_out)
        3'b000 : 
            begin
                ld_r0 = LD_REG;
            end
        3'b001 : 
            begin
                ld_r1 = LD_REG;
            end
        3'b010 : 
            begin
                ld_r2 = LD_REG;
            end
        3'b011 : 
            begin
                ld_r3 = LD_REG;
            end
        3'b100 : 
            begin
                ld_r4 = LD_REG;
            end
        3'b101 : 
            begin
                ld_r5 = LD_REG;
            end
        3'b110 : 
            begin
                ld_r6 = LD_REG;
            end
        3'b111 : 
            begin
                ld_r7 = LD_REG;
            end
			endcase
    end
mux2_3 DR_mux(
    .select(DR_select), .data_in_1(IR[11:9]), .data_in_2(3'b111), 
    .data_out(SR1_mux_out)
);

mux2_3 SR1_mux(
    .select(SR1_select), .data_in_1(IR[8:6]), .data_in_2(IR[11:9]), 
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