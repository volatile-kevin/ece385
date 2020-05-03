module lru(
				input logic CLK, READ, WRITE, RESET,
				input logic [15:0] addr, 
				input logic [15:0] write_from_MEM2IO,
				input logic [15:0] read_from_SRAM,
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
				
	logic [2:0] count;
	logic [31:0] queue [0:7];
	logic [2:0] numReads, numWrites;
	
	always @ (posedge CLK)
		begin
			if(RESET)
				begin
					numReads <= 3'b000;
					numWrites <= 3'b000;
				end
			else if ((READ) && (count != 3'b000))
				begin
					dataOut <= queue[numReads];
					numReads <= numReads + 1'b1;
				end
			else if ((WRITE) && (count < 8))
				begin	
					queue[numWrites] <= dataIn;
					numWrites = numWrites + 1'b1;
				end
			else;
			
			if(numWrites == 8)
				begin
					numWrites = 3'b000;
				end
			else if (numReads == 8)
				begin
					numReads = 3'b000;
				end
			else;
			
			if(numReads > numWrites)
				begin
					count = numReads - numWrites;
				end
			else if (numWrites > numReads)
				begin
					count = numWrites - numReads;
				end
			else;
		end
	
endmodule