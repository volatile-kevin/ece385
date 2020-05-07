module TCGenerator16(input logic [15:0] IN,

						 output logic [15:0] OUT,
						 output logic switched);
		logic [15:0] temp;
		always @(IN) begin
			if (IN[15]) begin
				temp = ~IN;
				OUT = temp + 1'b1;
				switched = 1'b1;
				
			end
			else begin
				OUT = IN;
				switched = 0;
			end
		 end
endmodule

module TCGenerator32(input logic [31:0] IN,
						   input logic [1:0] switch,

						 output logic [31:0] OUT);
		logic [31:0] temp;
		 always @(IN) begin
			if (switch[0] == 1 && switch[1] == 0 || switch[0] == 0 && switch[1] == 1) begin
				temp = ~IN;
				OUT = temp + 1'b1;
				$display("switch[0] is %d", switch[0]);
				$display("switch[1] is %d", switch[1]);
			end
			else
				OUT = IN;
		 end
		 
endmodule