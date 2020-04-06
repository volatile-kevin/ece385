/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input  logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC,
	output logic dumbReset
);
	// load enables for registers
	logic msgRegLE, barrierRegLE;
	// select bits for register mux 5-1 and imc register
	logic [2:0] regSelect;
	logic [1:0] imcSelect;
	logic [3:0] arkSelect;
	logic [31:0] muxOut;
	logic [31:0] imcOut;
	logic [127:0] isbIn, arkIn, isrIn, imcIn;
	logic [127:0] regOut, regIn;
	logic [1407:0] keySchedule;
	
	
	assign AES_MSG_DEC = regOut;

	// control unit
	control controlBruh(.*);
	
	// message register
	register128 msgReg(
		.CLK(CLK), .RESET(RESET), .loadEnable(msgRegLE), .din(regIn), .dout(regOut)
	);
	
	// register for IMC
	barrierReg barrierRegBruh(
		.CLK(CLK), .RESET(RESET), .loadEnable(barrierRegLE), .select(imcSelect), .din0(imcOut), .din1(imcOut), .din2(imcOut), .din3(imcOut), .dout(imcIn)
	);
	
	// 4-1 mux input to register
	mux5_128 muxReg(
		.select(regSelect), .din0(arkIn), .din1(isrIn), .din2(imcIn), .din3(isbIn), .din4(AES_MSG_ENC), .dout(regIn)
	);
	
	mux4_32 muxIMC(
		.select(imcSelect), .din0(regOut[31:0]), .din1(regOut[63:32]), .din2(regOut[95:64]), .din3(regOut[127:96]), 
		.dout(muxOut)
	);
	
	// decryption modules
	InvSubBytes16 InvSubBytes16Bruh(
		.CLK(CLK), .din(regOut), .dout(isbIn)
	);
	
	InvShiftRows InvShiftRowsBruh(
		.data_in(regOut), .data_out(isrIn)
	);
	
	InvMixColumns InvMixColumnsBruh(
		.in(muxOut), .out(imcOut)
	);
	
	AddRoundKey AddRoundKeyBruh(
		.keySched(keySchedule), .din(regOut), .select(arkSelect), .dout(arkIn)
	);
	
	KeyExpansion KeyExpansionBruh(
		.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(keySchedule)
	);
	
	
	
endmodule
