module lru(
				input logic CLK, READ, WRITE, RESET,
				input logic [15:0]  addr, 
				input logic [15:0]  write_from_MEM2IO,
				input logic [15:0]  read_from_SRAM,
				output logic [15:0] read_to_MEM2IO,
				output logic [15:0] write_to_SRAM
				
);
	assign write_to_SRAM = write_from_MEM2IO;
	
	queue q(
		.*, .dataIn({addr, WRITE ? write_from_MEM2IO:read_from_SRAM}), .dataOut(read_to_MEM2IO)
	);


endmodule

module queue(
				input logic CLK, READ, WRITE, RESET,
				input logic [31:0] dataIn,
				output logic [15:0] dataOut
				);
				
	logic [31:0] queue [0:7];
	int count;
	logic [2:0] duplicateIdx;
	logic duplicateFlag;
	int i;
	
	always @ (posedge CLK)
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
		
			if(RESET)
				begin
					count <= 0;
					for(i = 0; i < 8; i = i+1)
						begin
							queue[i] = 32'h0;
						end
				end
			else if ((READ == 1'b1) && (duplicateFlag == 1'b0) && (count < 8)) // fill first
				begin
					dataOut <= dataIn[15:0];
					queue[count] <= dataIn;
					count <= count + 1;
				end
			else if ((WRITE == 1'b1) && (duplicateFlag == 1'b0) && (count < 8)) // fill first
				begin
					queue[count] <= dataIn;
					count <= count + 1;
				end	
			else if (READ == 1'b1 && (count >= 8)) // READS
				begin
				
					if(duplicateFlag == 1'b0) // MISS
						begin
							dataOut <= dataIn[15:0];
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
							dataOut <= queue[duplicateIdx];
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