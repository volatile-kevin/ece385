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
logic [8:0] temp;
logic sub_reg;

top_level penis(.*);

always begin : COCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: COCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST
	Reset = 1;
	Run = 0;
	ClearA_LoadB = 1;
	S = 8'b11111110;
	
	
#2 Reset = 0;
#2	ClearA_LoadB = 0;
S = 8'b00000010;
	
#2 Run = 1;

#22 ;

end
endmodule