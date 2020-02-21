module testbench();


timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic Clk, Reset, Run, ClearA_LoadB;
logic [7:0] S;
logic [6:0] AhexU;
logic [6:0] AhexL;
logic [6:0] BhexU;
logic [6:0] BhexL;
logic [7:0] Aval;
logic [7:0] Bval;
logic X;



top_level penis(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST
	Reset = 0;
	Run = 1;
	S = 8'b10101010;
	
#2	ClearA_LoadB = 1;

	


end
endmodule