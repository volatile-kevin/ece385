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
                2'b11 : data_out = 4'h0000;
            endcase
	    end
endmodule

module sext_16(
                input logic [4:0] in,
                output logic [15:0] out
);
    always_comb
        begin
            out = { {11{in[4]}}, in};
        end
        
endmodule
