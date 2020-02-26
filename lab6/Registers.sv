//TODO:
//8 bit register module
//Right shift register
module registerB (input logic Clk, Reset, Shift_In, Load, Shift_En,
						 input logic  [7:0] Data_In,
						 output logic [7:0] Data_Out,
						 output logic Shift_Out);
						 
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				Data_Out <= 8'h0;
			else if (Load)
				Data_Out <= Data_In;
			else if (Shift_En)//might need begin and end
				Data_Out <= {Shift_In, Data_Out[7:1]};
		end
		
		assign Shift_Out = Data_Out[0];
		
endmodule
						 
						 
module registerA (input logic Clk, Reset, Shift_In, Load_Zeroes, Shift_En, Parallel_Load,
						 input logic  [7:0] Data_In,
						 output logic [7:0] Data_Out,
						 output logic Shift_Out);
						 
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				Data_Out <= 8'h0;
			else if (Load_Zeroes)
				Data_Out <= 8'h0;
			else if (Shift_En)//might need begin and end
				Data_Out <= {Shift_In, Data_Out[7:1]};
			else if (Parallel_Load)
				Data_Out <= Data_In;				
		end
		
		assign Shift_Out = Data_Out[0];
		
endmodule	

//16 bit register to communicate with the bus
module register16 (input logic Clk, Reset, Load_Enable,
						 input logic  [15:0] Data_In,
						 output logic [15:0] Data_Out);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				Data_Out <= 16'h0;
			else if (Load_Enable)
				Data_Out <= Data_In;
		end
		
endmodule

module pcmux (input logic[1:0] select,
				  input logic[15:0] Bus_data,
				  input logic[15:0] PC_offset_data,
				  input logic[15:0] Plus_data,
				  output logic[15:0] Data_out);
				  
	always_comb begin
		unique case (select)
			2'b00 : Data_out = Plus_data;
			// might need to change for week 2
			2'b01 : Data_out = PC_offset_data;
			2'b10 : Data_out = Bus_data;
			2'b11 : Data_out = 4'h0000;
		endcase
	end
				
endmodule		

module mdrmux (input logic select,
				  input logic[15:0] Bus_data,
				  input logic[15:0] Data_to_CPU,
				  output logic[15:0] Data_out);
				  
	always_comb begin
		unique case (select)
			1'b0 : Data_out = Data_to_CPU;
			1'b1 : Data_out = Bus_data;
		endcase
	end
				
endmodule			 
						 