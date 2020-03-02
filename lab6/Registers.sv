//16 bit register to communicate with the bus
module register16 (input logic Clk, Reset, Load_Enable,
						 input logic  [15:0] data_in,
						 output logic [15:0] data_out);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				data_out <= 16'h0;
			else if (Load_Enable)
				data_out <= data_in;
		end
		
endmodule

module mux4_16 (input logic[1:0] select,
				  input logic[15:0] data_in_3,
				  input logic[15:0] data_in_2,
				  input logic[15:0] data_in_1,
				  output logic[15:0] data_out);
				  
	always_comb begin
		unique case (select)
			2'b00 : data_out = data_in_1;
			// might need to change for week 2
			2'b01 : data_out = data_in_2;
			2'b10 : data_out = data_in_3;
			2'b11 : data_out = 4'h0000;
		endcase
	end
				
endmodule		

module mux2_16 (input logic select,
				  input logic[15:0] data_in_1,
				  input logic[15:0] data_in_2,
				  output logic[15:0] data_out);
				  
	always_comb begin
		unique case (select)
			1'b0 : data_out = data_in_1;
			1'b1 : data_out = data_in_2;
		endcase
	end
				
endmodule			 
						 

module mux2_3 (input logic select,
				  input logic[2:0] data_in_1,
				  input logic[2:0] data_in_2,
				  output logic[2:0] data_out);
				  
	always_comb begin
		unique case (select)
			1'b0 : data_out = data_in_1;
			1'b1 : data_out = data_in_2;
		endcase
	end
				
endmodule