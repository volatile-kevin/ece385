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
							 output logic shift_registers,
							 output logic add_registers
);
				
	
	enum logic[4:0] {start,sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7,add0,add1,add2,add3,add4,add5,add6, add7} state, next_state;
	logic [6:0] AhexU_comb, AhexL_comb, BhexU_comb, BhexL_comb;
	logic carryout;
//	logic [7:0]AdderBuffer = 8'h00;
	logic start_pin = 1'b1;
	logic [7:0] tempA;
	
//	shift_registers = 1'b0;
	
	always_ff @(posedge Clk) begin
		if (Reset) begin
			state <= start;
		end else if (ClearA_LoadB) begin
			state <= start;
		end else if (Run) begin
			if (state == start)
				state <= sh0;
			else
				state <= next_state;
		end
		else
			state <= next_state;
		end
	
	//next state logic
	always_comb begin 
		next_state = state;
		
		unique case (state)
			start : if (Run) next_state = add0;
			add0 : next_state = sh0;
			sh0 : next_state = add1;
			
			add1 : next_state = sh1;
			sh1 : next_state = add2;
			add2 : next_state = sh2;
			sh2 : next_state = add3;
			add3 : next_state = sh3;
			sh3 : next_state = add4;
			add4 : next_state = sh4;
			sh4 : next_state = add5;
			add5 : next_state = sh5;
			sh5 : next_state = add6;
			add6 : next_state = sh6;
			sh6 : next_state = add7;
			add7 : next_state = sh7;
			
			sh7 : if (!Run) next_state = start;
		endcase
		
		//state logic	
		unique case (state)
			start : begin
				shift_registers = 1'b0;
				add_registers = 1'b0;
			end
			sh0, sh1, sh2, sh3, sh4, sh5, sh6: begin
				shift_registers = 1'b1;
				add_registers = 1'b0;
			end
			add0,add1,add2,add3,add4,add5,add6,add7 : begin
				shift_registers = 1'b0;
				add_registers = Bval[0];
			end
		endcase
	end
	
	
	
	
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
		
		adder_9bit adder9bit
		(
			.A({Aval[7],Aval[7:0]}),
			.B({S[7],S[7:0]}),
			.Sum({X,tempA}),
			.CO({carryout})
		);
		 
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
		
		registerA regA
		(
			.Clk,
			.Reset,
			.Shift_In(X),
			.Load_Zeroes(ClearA_LoadB),
			.Shift_En(shift_registers),
			.Parallel_Load(add_registers),
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
			.Shift_En(shift_registers),
			.Data_In(S),
			.Data_Out(Bval),
			.Shift_Out()
		);
		
endmodule