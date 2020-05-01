module alu(
            input logic [2:0] select,
            input logic [15:0] A, B,
            output logic [15:0] data_out
);
	logic [31:0] mul_out; 
	always_comb 
        begin
		  		data_out = 16'b0;
				if(select == 3'b000)
					data_out = A + B;
				if(select == 3'b001)
					data_out = A & B;
				if(select == 3'b010)
					data_out = ~A;
				if(select == 3'b011)
					data_out = A;
				if(select == 3'b100)
					data_out = mul_out[15:0];
	    end
		 
	WallaceTree mul(
		.MUR(A), .MUD(B), .result(mul_out)
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

