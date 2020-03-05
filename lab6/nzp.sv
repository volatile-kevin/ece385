module nzp(
    input logic Clk, Reset,
    input logic [15:0] bus_data,
    input logic [2:0] IR,
    input logic LD_CC,
    input logic LD_BEN,
    output logic BEN
);

logic n, z, p;
logic [15:0] temp;
logic [2:0] nzp_compare;
logic ben;


    always_comb
        begin
				n = 1'b0;
				z = 1'b0;
				p = 1'b0;
            if(bus_data[15])
                begin
                    n = 1'b1;
                end
            else  if (!bus_data)
                begin
                    z = 1'b1;
                end
            else 
                begin
                    p = 1'b1;
                end
        end
    

    always_comb
			begin
			ben = 1'b0;
        
            if((IR[2] & nzp_compare[2]))
                begin
                    ben = 1'b1;
                end
            else if((IR[1] & nzp_compare[1]))
                begin
                    ben = 1'b1;
                end
            else if((IR[0] & nzp_compare[0]))
                begin
                    ben = 1'b1;
                end
        end

register3 nzp_reg(
    .Clk(Clk), .Reset(Reset), .Load_Enable(LD_CC), .data_in({n,z,p}), 
    .data_out(nzp_compare)
);

register1 ben_reg(
    .Clk(Clk), .Reset(Reset), .Load_Enable(LD_BEN), .data_in(ben), 
    .data_out(BEN)
);



endmodule

module register3 (input logic Clk, Reset, Load_Enable,
						 input logic [2:0] data_in,
						 output logic [2:0] data_out);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				data_out <= 3'b000;
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
				data_out <= 1'b0;
			else if (Load_Enable)
				data_out <= data_in;
		end
		
endmodule


