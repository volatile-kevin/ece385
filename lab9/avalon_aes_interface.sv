/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);
		
		logic dumbReset;
		logic LE_KEY0, LE_KEY1, LE_KEY2, LE_KEY3,
				LE_EN0, LE_EN1, LE_EN2, LE_EN3, 
				LE_DE0, LE_DE1, LE_DE2, LE_DE3,
				LE_START, LE_DONE;
				
		logic [127:0] AES_KEY, AES_MSG_EN, AES_MSG_DE;
		logic [31:0] dumb_start, dumb_done, real_done;
		logic [127:0] AES_MSG_DE_READ; 

		
				//WEEK 2 
		AES AESBruh(
			.CLK(CLK), .RESET(RESET), .AES_START(dumb_start), .AES_DONE(dumb_done), 
			.AES_KEY({AES_KEY[31:0], AES_KEY[63:32], AES_KEY[95:64], AES_KEY[127:96]}), 
			.AES_MSG_ENC({AES_MSG_EN[31:0], AES_MSG_EN[63:32], AES_MSG_EN[95:64], AES_MSG_EN[127:96]}), .AES_MSG_DEC(AES_MSG_DE),
			.dumbReset(dumbReset) // find and replace
		);
		
		always_comb
			begin
				LE_KEY0 = 1'b0;
				LE_KEY1 = 1'b0;
				LE_KEY2 = 1'b0;
				LE_KEY3 = 1'b0;
				LE_EN0 = 1'b0;
				LE_EN1 = 1'b0;
				LE_EN2 = 1'b0;
				LE_EN3 = 1'b0;
				LE_DE0 = 1'b0;
				LE_DE1 = 1'b0;
				LE_DE2 = 1'b0;
				LE_DE3 = 1'b0;
				LE_START = 1'b0;
				LE_DONE = 1'b0;
				if(dumb_done)
					begin
						LE_DONE = 1'b1;
						LE_DE0 = 1'b1;
						LE_DE1 = 1'b1;
						LE_DE2 = 1'b1;
						LE_DE3 = 1'b1;
					end
				if (AVL_WRITE && AVL_CS)
					begin
						case(AVL_ADDR)
							4'b0000:
								LE_KEY0 = 1'b1;
							4'b0001:
								LE_KEY1 = 1'b1;
							4'b0010:
								LE_KEY2 = 1'b1;
							4'b0011:
								LE_KEY3 = 1'b1;
							4'b0100:
								LE_EN0 = 1'b1;
							4'b0101:
								LE_EN1 = 1'b1;
							4'b0110:
								LE_EN2 = 1'b1;
							4'b0111:
								LE_EN3 = 1'b1;

							//start and done
							4'b1110:
								LE_START = 1'b1;
							default: ;
								
						endcase
					end
			end
			
			
		always_comb
			begin
				AVL_READDATA = 8'h00000000;
				if(AVL_READ && AVL_CS)
					begin
						case(AVL_ADDR)
							4'b0000:
								AVL_READDATA = AES_KEY[31:0];
							4'b0001:
								AVL_READDATA = AES_KEY[63:32];
							4'b0010:
								AVL_READDATA = AES_KEY[95:64];
							4'b0011:
								AVL_READDATA = AES_KEY[127:96];
							4'b0100:
								AVL_READDATA = AES_MSG_EN[31:0];
							4'b0101:
								AVL_READDATA = AES_MSG_EN[63:32];
							4'b0110:
								AVL_READDATA = AES_MSG_EN[95:64];
							4'b0111:
								AVL_READDATA = AES_MSG_EN[127:96];
							4'b1000:
								AVL_READDATA = AES_MSG_DE[31:0];
							4'b1001:
								AVL_READDATA = AES_MSG_DE[63:32];
							4'b1010:
								AVL_READDATA = AES_MSG_DE[95:64];
							4'b1011:
								AVL_READDATA = AES_MSG_DE[127:96];
							//start and done
							4'b1110:
								AVL_READDATA = dumb_start;
							4'b1111:
								AVL_READDATA = real_done;
							default:
								AVL_READDATA = 8'h00000000;
						endcase
					end
			end
		
			
//		assign EXPORT_DATA = {AES_MSG_DE[31:16], AES_MSG_DE[111:96]};
		assign EXPORT_DATA = {AES_KEY[31:16], AES_KEY[111:96]};

		// 000102030...0f - 0001 0e0f
		//AES_KEY
 		register32 AES_KEY0(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_KEY0), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_KEY[31:0])
		);
		
		register32 AES_KEY1(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_KEY1), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_KEY[63:32])
		);
		
		register32 AES_KEY2(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_KEY2), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_KEY[95:64])
		);
		
		register32 AES_KEY3(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_KEY3), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_KEY[127:96])
		);
		
		//AES_MEG_EN
		register32 AES_MSG_EN0(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_EN0), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_MSG_EN[31:0])
		);
		
		register32 AES_MSG_EN1(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_EN1), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_MSG_EN[63:32])
		);
		
		register32 AES_MSG_EN2(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_EN2), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_MSG_EN[95:64])
		);
		
		register32 AES_MSG_EN3(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_EN3), .byte_enable(AVL_BYTE_EN), .data_in(AVL_WRITEDATA), 
		.data_out(AES_MSG_EN[127:96])
		);
		
		//AES_MSG_DE
		register32 AES_MSG_DE0(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_DE0), .byte_enable(4'b1111), .data_in(AES_MSG_DE[31:0]), 
		.data_out(AES_MSG_DE_READ[31:0])
		);
		
		register32 AES_MSG_DE1(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_DE1), .byte_enable(4'b1111), .data_in(AES_MSG_DE[63:32]), 
		.data_out(AES_MSG_DE_READ[63:32])
		);
		
		register32 AES_MSG_DE2(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_DE2), .byte_enable(4'b1111), .data_in(AES_MSG_DE[95:64]), 
		.data_out(AES_MSG_DE_READ[95:64])
		);
		
		register32 AES_MSG_DE3(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_DE3), .byte_enable(4'b1111), .data_in(AES_MSG_DE[127:96]), 
		.data_out(AES_MSG_DE_READ[127:96])
		);
		
		
		//START & DONE
		register32 START(
		.Clk(CLK), .Reset(RESET | dumbReset), .load_enable(LE_START), .byte_enable(4'b1111), .data_in(AVL_WRITEDATA), 
		.data_out(dumb_start)
		);
		
		register32 DONE(
		.Clk(CLK), .Reset(RESET), .load_enable(LE_DONE), .byte_enable(4'b1111), .data_in(dumb_done), 
		.data_out(real_done)
		);



		
		
endmodule

module register32 (
		input logic Clk, Reset, load_enable, 
		input logic [3:0] byte_enable,
		input logic  [31:0] data_in,
		output logic [31:0] data_out
);
			
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				data_out <= 32'h00000000000000000000000000000000;
			else if (load_enable)
				begin
					if(byte_enable[0])
						data_out[7:0] <= data_in[7:0];
					if(byte_enable[1])
						data_out[15:8] <= data_in[15:8];
					if(byte_enable[2])
						data_out[23:16] <= data_in[23:16];
					if(byte_enable[3])
						data_out[31:24] <= data_in[31:24];
				end
		end
		
endmodule
