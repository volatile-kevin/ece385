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
						 
						 
						 
						 