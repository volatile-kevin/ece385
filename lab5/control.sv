module control(
					input logic Clk, Reset, ClearA_LoadB, Run, M,
					output logic shift_reg,
					add_reg, sub_reg
);

	enum logic[4:0] {start,sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7,add0,add1,add2,add3,add4,add5,add6, add7, stop} state, next_state;
	
	always_ff @(posedge Clk) begin
		if (Reset) begin
			state <= start;
		end 
//		else if (ClearA_LoadB) begin
//			state <= start;
//		end else if (Run) begin
//			if (state == start)
//				state <= sh0;
//			else
//				state <= next_state;
//		end
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
			sh7 : next_state = stop;
			stop : if (~Run) next_state = start;
		endcase
	end
	
	always_comb begin
		case(state)
			stop: 
				begin
					shift_reg = 1'b0;
					add_reg = 1'b0;
					sub_reg = 1'b0;
				end
			start:
				begin
					shift_reg = 1'b0;
					add_reg = 1'b0;
					sub_reg = 1'b0;
				end
			sh0, sh1, sh2, sh3, sh4, sh5, sh6:
				begin
					shift_reg = 1'b1;
					add_reg = 1'b0;
					sub_reg = 1'b0;
				end
			sh7:
				begin
				shift_reg = 1'b1;
					if(M)
						begin
							add_reg = 1'b0;
							sub_reg = 1'b1;
						end
					else
						begin
							add_reg = 1'b0;
							sub_reg = 1'b1;
						end		
				end	
			add0, add1, add2, add3, add4, add5, add6:
				begin
				shift_reg = 1'b0;
					if(M)
						begin
							add_reg = 1'b1;
							sub_reg = 1'b0;
						end
					else
						begin
							add_reg = 1'b0;
							sub_reg = 1'b0;
						end
				end
			add7:
				begin
				shift_reg = 1'b0;
					if(M)
						begin
							add_reg = 1'b0;
							sub_reg = 1'b1;
						end
					else
						begin
							add_reg = 1'b0;
							sub_reg = 1'b0;
						end		
				end	
		endcase
	end
		

endmodule