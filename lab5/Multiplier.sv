

module adder_9bit(
						input   logic[8:0]     A,
						input   logic[8:0]     B,
						input sub,
						output  logic[8:0]     Sum,
						output  logic          CO,
						output logic [8:0] temp
						);
	logic C0, C1;
	
	always_comb begin
		if(sub) 
			begin
				temp = ~B + 1'b1;
			end
		else 
			begin
				temp = B;
			end
	end
	
	four_bit_ra FRA0(.x(temp[3:0]), .y(A[3:0]), .cin(0), .s(Sum[3:0]), .cout(C0));
	four_bit_ra FRA1(.x(temp[7:4]), .y(A[7:4]), .cin(C0), .s(Sum[7:4]), .cout(C1));
	full_adder fa3(.x(temp[8]), .y(A[8]), .cin(C1), .s(Sum[8]), .cout(CO));
	
	
endmodule

module four_bit_ra(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s,
						output logic [3:0] cout
						);
		
	logic c0, c1, c2;
	
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0), .s(s[1]), .cout(c1));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1), .s(s[2]), .cout(c2));
	full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2), .s(s[3]), .cout(cout));


endmodule


module full_adder(
						input x,
						input y,
						input cin,
						output logic s, 
						output logic cout
						);
	assign s = x^y^cin;
	assign cout = (x&y)|(y&cin)|(cin&x);	
	
endmodule						
