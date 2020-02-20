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
							 output logic X);
				
	
	enum logic[1:0] {start, compute_A, compute_B, halt} state, next_state;
	logic [6:0] AhexU_comb, AhexL_comb, BhexU_comb, BhexL_comb;
	
	always_ff @(posedge Clk) begin
		if (!Reset) begin
			Aval <= 8'h00;
			Bval <= 8'h00;
			X <= 1'b0;
		end else if (!ClearA_LoadB) begin
			Aval <= 8'h00;
			X <= 1'b0;
			Bval <= S;
		end else begin
			Aval <= S;
		end
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