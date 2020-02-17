module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	   logic C0, C1, C2;
	  
		four_bit_adder FRA0(.x(A[3:0]), .y(B[3:0]), .cin(0), .sum(Sum[3:0]), .cout(C0));
		four_ba_mux FRA1(.x(A[7:4]), .y(B[7:4]), .cin(C0), .sum(Sum[7:4]), .cout(C1));
		four_ba_mux FRA2(.x(A[11:8]), .y(B[11:8]), .cin(C1), .sum(Sum[11:8]), .cout(C2));
		four_ba_mux FRA3(.x(A[15:12]), .y(B[15:12]), .cin(C2), .sum(Sum[15:12]), .cout(CO));
     
endmodule


module four_ba_mux(
							input [3:0] x, 
							input [3:0] y,
							input cin,
							output logic [3:0] sum,
							output logic cout
);

			logic[3:0] sumA, sumB;
			logic a, b;
			
			four_bit_adder FOUR_BA0(.x(x), .y(y), .cin(0), .sum(sumA), .cout(a));
			four_bit_adder FOUR_BA1(.x(x), .y(y), .cin(1), .sum(sumB), .cout(b));
			mux mymux(.din0(sumA), .din1(sumB), .sel(cin), .mux_out(sum));
			
			assign cout = (cin & b) | a;
			
endmodule



module four_bit_adder(
							input [3:0] x, 
							input [3:0] y,
							input cin,
							output logic [3:0] sum,
							output logic cout
);

			logic c2, c1, c0;
			
			full_adder_csa BA0(.x(x[0]), .y(y[0]), .cin(cin), .s(sum[0]), .cout(c0));
			full_adder_csa BA1(.x(x[1]), .y(y[1]), .cin(c0), .s(sum[1]), .cout(c1));
			full_adder_csa BA2(.x(x[2]), .y(y[2]), .cin(c1), .s(sum[2]), .cout(c2));
			full_adder_csa BA3(.x(x[3]), .y(y[3]), .cin(c2), .s(sum[3]), .cout(cout));


endmodule

module mux(
				input [3:0] din0,
				input [3:0] din1, 
				input sel,
				output logic [3:0] mux_out
);

assign mux_out = (sel) ? din1 : din0; 


endmodule

module full_adder_csa(
						input x,
						input y,
						input cin,
						output logic s, 
						output logic cout
						);
	assign s = x^y^cin;
	assign cout = (x&y)|(y&cin)|(cin&x);	
	
endmodule						
