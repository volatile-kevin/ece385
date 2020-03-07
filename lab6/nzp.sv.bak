module nzp(
    input logic Clk Reset,
    input logic [15:0] bus_data,
    input logic [2:0] IR,
    input logic LD_CC,
    input logic LD_BEN,
    output logic BEN
);

logic n, z, p;
logic [15:0] temp;
logic [2:0] nzp_compare;
logic ben_compare;

assign temp = bus_data | 4'b0000;

    always_comb
        begin
            if(bus_data[15])
                begin
                    n = 1'b1;
                end
            else if (!temp)
                begin
                    z = 1'b1;
                end
            else 
                begin
                    p = 1'b1;
                end
        end
    end

    always_comb
        BEN = 1'b0;
        begin
            if((IR[2] & nzp_compare[2]))
                begin
                    BEN = 1'b1;
                end
            else if((IR[1] & nzp_compare[1]))
                begin
                    BEN = 1'b1;
                end
            else if((IR[0]) & nzp_compare[0]))
                begin
                    BEN = 1'b1;
                end
        end

register3 nzp_reg(
    .Clk(Clk), .Reset(Reset), .Load_Enable(LD_CC), .data_in({n,z,p}), 
    .data_out(nzp_compare)
);

register1 ben_reg(
    .Clk(Clk), .Reset(Reset), .Load_Enable(LD_BEN), .data_in(ben_compare), 
    .data_out(ben))
);



endmodule

module register3 (input logic Clk, Reset, Load_Enable,
						 input logic [2:0] data_in,
						 output logic [2:0] data_out);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				data_out <= 3'h0;
			else if (Load_Enable)
				data_out <= data_in;
		end
		
endmodule

module register1 (input logic Clk, Reset, Load_Enable,
						 input logic data_in,
						 output logic data_out);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				data_out <= 1'h0;
			else if (Load_Enable)
				data_out <= data_in;
		end
		
endmodule


