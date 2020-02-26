//Lychewow and Joe
//8-bit multiplier circuit
//function(char a, char b){
//		return a * b;
//}

module top_level (input logic Clk,Reset, Run, ClearA_LoadB,
							 input logic [7:0] S,
							 output logic [6:0] AhexU,
							 output logic [6:0] AhexL,
							 output logic [6:0] BhexU,
							 output logic [6:0] BhexL,
							 output logic [7:0] Aval,
							 output logic [7:0] Bval,
							 output logic X,
							 output logic [8:0] temp, 
							 output logic sub_reg
);
				
	
	logic [6:0] AhexU_comb, AhexL_comb, BhexU_comb, BhexL_comb;
	logic carryout;
//	logic [7:0]AdderBuffer = 8'h00;
	logic start_pin = 1'b1;
	logic [7:0] tempA;
	logic shift, add, sub;
	assign sub_reg = sub;

	
//	shift_registers = 1'b0;
	

	
	
	
	
		/* Decoders for HEX drivers and output registers
		* Note that the hex drivers are calculated one cycle after Sum so
		* that they have minimal interfere with timing (fmax) analysis.
		* The human eye can't see this one-cycle latency so it's OK. */
		always_ff @(posedge Clk) begin
			AhexU <= AhexU_comb;
			AhexL <= AhexL_comb;
			BhexU <= BhexU_comb;
			BhexL <= BhexL_comb;
		end
		
		control control_unit
		(
			.Clk,
			.Reset,
			.ClearA_LoadB,
			.Run,
			.M(Bval[0]),
			.shift_reg(shift),
			.add_reg(add),
			.sub_reg(sub)
		);
		
		adder_9bit adder9bit
		(
			.A({Aval[7],Aval[7:0]}),
			.B({S[7],S[7:0]}),
			.sub(sub),
			.Sum({X,tempA[7:0]}),
			.CO({carryout}),
			.temp(temp)
		);
		 

		
		registerA regA
		(
			.Clk,
			.Reset,
			.Shift_In(X),
			.Load_Zeroes(ClearA_LoadB),
			.Shift_En(shift),
			.Parallel_Load(add || sub),
			.Data_In(tempA),
			.Data_Out(Aval),
			.Shift_Out()
		);
		
		registerB regB
		(
			.Clk,
			.Reset,
			.Shift_In(Aval[0]),
			.Load(ClearA_LoadB),
			.Shift_En(shift),
			.Data_In(S),
			.Data_Out(Bval),
			.Shift_Out()
		);
		
		
//*******************************************************//
		HexDriver Ahex_inst
		(
				.In0(Aval[7:4]),
				.Out0(AhexU_comb)
		);

		HexDriver AhexL_inst
		(
				.In0(Aval[3:0]),
				.Out0(AhexL_comb)
		);

		HexDriver BhexU_inst
		(
				.In0(Bval[7:4]),
				.Out0(BhexU_comb)
		);

		HexDriver BhexL_inst
		(
				.In0(Bval[3:0]),
				.Out0(BhexL_comb)
		);
		
endmodule