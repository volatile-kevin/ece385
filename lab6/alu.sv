module alu(
            input logic [1:0] select,
            input logic [15:0] A, B,
            output logic [15:0] data_out
);
	always_comb 
        begin
            unique case (select)
                2'b00 : data_out = A + B;
                2'b01 : data_out = A & B;
                2'b10 : data_out = ~A;
                2'b11 : data_out = A;
            endcase
	    end
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

