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
wire [15:0] Data;


logic [15:0] pc, bus;

lab6_toplevel LC3(.*);

assign pc = LC3.my_slc.PC;
assign bus = LC3.my_slc.bus_data;

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
    S = 16'h0003;
    Reset = 0;
    Run = 1;
    Continue = 1;


#2 Reset = 1;


#2 Run = 0;
//Run = 1 -> state 18
//#2 Run = 1;

#10;



end
endmodule