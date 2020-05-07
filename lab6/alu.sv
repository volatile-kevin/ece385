module alu(
				input logic Clk,
            input logic [2:0] select,
            input logic [15:0] A, B,
				input logic div_start,
            output logic [15:0] data_out,
				output logic [15:0] aux_reg
);
	logic [31:0] mul_out; 
	logic [15:0] div_out, remainder;
	logic [4:0] bullshit;
	always_comb 
        begin
		  		data_out = 16'b0;
				aux_reg = 16'b0;
				if(select == 3'b000)
					data_out = A + B;
				if(select == 3'b001)
					data_out = A & B;
				if(select == 3'b010)
					data_out = ~A;
				if(select == 3'b011)
					data_out = A;
				if(select == 3'b100)
					begin
						data_out = mul_out[15:0];
						aux_reg = mul_out[31:16];
					end
				if(select == 3'b101)
					begin
						data_out = div_out[15:0];
						aux_reg = remainder;
					end
	    end
		 
	WallaceTree mul(
		.MUR(A), .MUD(B), .result(mul_out)
	);
	
	Divider div(
		.Clk(Clk), .start(div_start), .DIVIDER(B), .DIVIDEND(A), 
		.quotient(div_out), .remainder(remainder), .bitt(bullshit)
	);
endmodule

module sext_5_16(
                input logic [4:0] in,
                output logic [15:0] out
);
    always_comb
        begin
            out = { {11{in[4]}}, in};
        end

endmodule

module sext_6_16(
                input logic [5:0] in,
                output logic [15:0] out
);
    always_comb
        begin
            out = { {10{in[5]}}, in};
        end
        
endmodule

module sext_9_16(
                input logic [8:0] in,
                output logic [15:0] out
);
    always_comb
        begin
            out = { {7{in[8]}}, in};
        end
        
endmodule

module sext_11_16(
                input logic [10:0] in,
                output logic [15:0] out
);
    always_comb
        begin
            out = { {5{in[10]}}, in};
        end
        
endmodule

