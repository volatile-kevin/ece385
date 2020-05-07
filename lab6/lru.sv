module cache(
				input logic CLK, READ, WRITE, RESET,
				input logic [15:0]  addr, 
				input logic [15:0]  write_from_MEM2IO,
				input logic [15:0]  read_from_SRAM,
				output logic [15:0] read_to_MEM2IO,
				output logic [15:0] write_to_SRAM,
				output logic [7:0] hex_hits, hex_misses
				
);
	assign write_to_SRAM = write_from_MEM2IO;
	
//	lru q(
//		.*, .dataIn({addr, WRITE ? write_from_MEM2IO:read_from_SRAM}), .dataOut(read_to_MEM2IO), 
//    .hex_hits(hex_hits), .hex_misses(hex_misses)
//	);

	dmc q(
		.*, .dataIn({addr, WRITE ? write_from_MEM2IO:read_from_SRAM}), .dataOut(read_to_MEM2IO),
		.hex_hits(hex_hits), .hex_misses(hex_misses)
	);
	

endmodule


module dmc(
				input logic CLK, READ, WRITE, RESET,
				input logic [31:0] dataIn,
				output logic [15:0] dataOut,
				output logic [7:0] hex_hits, hex_misses
				);
				
	logic [31:0] cache [0:7];
	int hits, misses, count, i;
	logic duplicateFlag;
	
	
	always_comb
		begin
			duplicateFlag = 1'bx;
			dataOut = dataIn[15:0];
					case (dataIn[31:16])
						cache[0][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[1][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[2][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[3][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[4][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[5][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[6][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						cache[7][31:16]: 
							begin 
								duplicateFlag = 1'b1;
							end
						default : 
							begin
								duplicateFlag = 1'b0;
							end
					endcase 
				end
	
	always @ (posedge CLK)
		begin
			if(RESET)
				begin
					hits <= 0;
					misses <= 0;
					hex_hits <= 4'b0000;
					hex_misses <= 4'b0000;
					for(i = 0; i < 8; i = i+1)
						begin
							cache[i] = 16'h0;
						end
				end
			else if ((READ == 1'b1)) // READS
				begin
					if(duplicateFlag && count >= 8) // HIT
						begin
							hits <= hits + 1;
							hex_hits <= hex_hits + 1'b1;
						end
					else if (!duplicateFlag && count >= 8) // MISSES
						begin
							misses <= misses + 1;
							hex_misses <= hex_misses + 1'b1;
							cache[dataIn[18:16]] = dataIn;
						end
					else if (count < 8)
						begin
							count <= count + 1;
							cache[dataIn[18:16]] = dataIn;						
						end
				end
			else if ((WRITE == 1'b1))
				begin
					if(duplicateFlag && count >= 8) // HIT
						begin
							hits <= hits + 1;
							hex_hits <= hex_hits + 1'b1;
							cache[dataIn[18:16]] = dataIn;
						end
					else if (!duplicateFlag && count >= 8) // MISSES
						begin
							misses <= misses + 1;
							hex_misses <= hex_misses + 1'b1;
							cache[dataIn[18:16]] = dataIn;
						end
					else if (count < 8)
						begin
							count <= count + 1;
							cache[dataIn[18:16]] = dataIn;						
						end
				end	
		end
endmodule




module lru(
				input logic CLK, READ, WRITE, RESET,
				input logic [31:0] dataIn,
				output logic [15:0] dataOut,
				output logic [7:0] hex_hits, hex_misses
				);
				
	logic [31:0] queue [0:7];
	int count;
	int hits, misses;
	logic [2:0] duplicateIdx;
	logic duplicateFlag;
	int i;
	
	always_comb
		begin
			duplicateIdx = 3'bxxx;
			duplicateFlag = 1'bx;
			dataOut = dataIn[15:0];
			if(count >= 8)
				begin
					case (dataIn[31:16])
						queue[0][31:16]: 
							begin 
								duplicateIdx = 3'b000;
								duplicateFlag = 1'b1;
							end
						queue[1][31:16]: 
							begin 
								duplicateIdx = 3'b001;
								duplicateFlag = 1'b1;
							end
						queue[2][31:16]: 
							begin 
								duplicateIdx = 3'b010;
								duplicateFlag = 1'b1;
							end
						queue[3][31:16]: 
							begin 
								duplicateIdx = 3'b011;
								duplicateFlag = 1'b1;
							end
						queue[4][31:16]: 
							begin 
								duplicateIdx = 3'b100;
								duplicateFlag = 1'b1;
							end
						queue[5][31:16]: 
							begin 
								duplicateIdx = 3'b101;
								duplicateFlag = 1'b1;
							end
						queue[6][31:16]: 
							begin 
								duplicateIdx = 3'b110;
								duplicateFlag = 1'b1;
							end
						queue[7][31:16]: 
							begin 
								duplicateIdx = 3'b111;
								duplicateFlag = 1'b1;
							end
						default : 
							begin
								duplicateIdx = 3'bxxx;
								duplicateFlag = 1'b0;
							end
					endcase 
				end
				else if(count >= 8)
					begin
						duplicateIdx = 3'bxxx;
						duplicateFlag = 1'b0;
					end
				else
					begin
						duplicateIdx = 3'bxxx;
						duplicateFlag = 1'b0;
					end
		end
	always @ (posedge CLK)
		begin
			if(RESET)
				begin
					hits <= 0;
					misses <= 0;
					for(i = 0; i < 8; i = i+1)
						begin
							queue[i] = 32'h0;
						end
				end
			else if ((READ == 1'b1) && (count < 8)) // fill first
				begin
//					dataOut <= dataIn[15:0];
					queue[count] <= dataIn;
					count <= count + 1;
				end
			else if ((WRITE == 1'b1) && (count < 8)) // fill first
				begin
					queue[count] <= dataIn;
					count <= count + 1;
				end	
			else if (READ == 1'b1 && (count >= 8)) // READS
				begin
				
					if(duplicateFlag == 1'b0) // MISS
						begin
							misses <= misses + 1;
							hex_misses <= hex_misses + 1'b1;
//							dataOut <= dataIn[15:0];
							queue[7] <= dataIn;
							queue[6] <= queue[7];
							queue[5] <= queue[6];
							queue[4] <= queue[5];
							queue[3] <= queue[4];
							queue[2] <= queue[3];
							queue[1] <= queue[2];
							queue[0] <= queue[1];
						end
					
					
					if(duplicateFlag == 1'b1) // HIT
						begin
							hits <= hits + 1;
							hex_hits <= hex_hits + 1'b1;
//							dataOut <= queue[duplicateIdx];
							case(duplicateIdx) // HIT LOGIC
								3'b000: 
									begin;
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[2];
										queue[0] <= queue[1];
									end
								3'b001:
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[2];
										queue[0] <= queue[0];
									end
								3'b010: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b011: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b100: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b101: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b110: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[7];
										queue[5] <= queue[5];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b111: 
									begin
										queue[7] <= queue[duplicateIdx];
										queue[6] <= queue[6];
										queue[5] <= queue[5];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
							endcase
						end
				end
			else if ((WRITE == 1'b1)) // WRITES
				begin
					if(duplicateFlag == 1'b0) // MISS on write
						begin
							misses <= misses + 1;
							hex_misses <= hex_misses + 1'b1;
							queue[7] <= dataIn;
							queue[6] <= queue[7];
							queue[5] <= queue[6];
							queue[4] <= queue[5];
							queue[3] <= queue[4];
							queue[2] <= queue[3];
							queue[1] <= queue[2];
							queue[0] <= queue[1];
						end
					
					if(duplicateFlag == 1'b1) // HIT on write
						begin
							hits <= hits + 1;
							hex_hits <= hex_hits + 1'b1;
							case(duplicateIdx) // HIT LOGIC
								3'b000: 
									begin;
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[2];
										queue[0] <= queue[1];
									end
								3'b001:
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[2];
										queue[0] <= queue[0];
									end
								3'b010: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[3];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b011: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[4];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b100: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[5];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b101: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[6];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b110: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[7];
										queue[5] <= queue[5];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
								3'b111: 
									begin
										queue[7] <= dataIn;
										queue[6] <= queue[6];
										queue[5] <= queue[5];
										queue[4] <= queue[4];
										queue[3] <= queue[3];
										queue[2] <= queue[2];
										queue[1] <= queue[1];
										queue[0] <= queue[0];
									end
							endcase
						end
				end

			else;
			

		end
	
endmodule