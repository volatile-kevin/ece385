module AddRoundKey(input logic [1407:0] keySched,
						 input logic [127:0] din,
						 input logic [3:0] select,
						 output logic [127:0] dout
						);
	logic [127:0] temp;
	
	always_comb
		begin
			case(select)
				4'b1010:
					temp = keySched[127:0];
				4'b1001:
					temp = keySched[255:128];
				4'b1000:
					temp = keySched[383:256];
				4'b0111:
					temp = keySched[511:384];
				4'b0110:
					temp = keySched[639:512];
				4'b0101:
					temp = keySched[767:640];
				4'b0100:
					temp = keySched[895:768];
				4'b0011:
					temp = keySched[1023:896];
				4'b0010:
					temp = keySched[1151:1024];
				4'b0001:
					temp = keySched[1279:1152];
				4'b0000:
					temp = keySched[1407:1280];
				default:
					temp = 128'h0;
			endcase
		end
	
	assign dout[7:0] = temp[7:0] ^ din[7:0];
	assign dout[15:8] = temp[15:8] ^ din[15:8]; 
	assign dout[23:16] = temp[23:16] ^ din[23:16]; 
	assign dout[31:24] = temp[31:24] ^ din[31:24]; 
	assign dout[39:32] = temp[39:32] ^ din[39:32]; 
	assign dout[47:40] = temp[47:40] ^ din[47:40]; 
	assign dout[55:48] = temp[55:48] ^ din[55:48]; 
	assign dout[63:56] = temp[63:56] ^ din[63:56]; 
	assign dout[71:64] = temp[71:64] ^ din[71:64]; 
	assign dout[79:72] = temp[79:72] ^ din[79:72]; 
	assign dout[87:80] = temp[87:80] ^ din[87:80]; 
	assign dout[95:88] = temp[95:88] ^ din[95:88]; 
	assign dout[103:96] = temp[103:96] ^ din[103:96]; 
	assign dout[111:104] = temp[111:104] ^ din[111:104]; 
	assign dout[119:112] = temp[119:112] ^ din[119:112]; 
	assign dout[127:120] = temp[127:120] ^ din[127:120]; 
	
						
endmodule 