module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic CE, UB, LB, OE, WE;
logic [19:0] ADDR;
logic [15:0] busData;
logic [15:0] PC, MDR, IR; 
wire [15:0] Data;


lab6_toplevel LC3(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
    S = 16'h0000;
    Reset = 0;
    Run = 1;
    Continue = 1;


#2 Reset = 1;

#2 Run = 0;
//Run = 1 -> state 18
//#2 Run = 1;

#20;



end
endmodule