//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Internal connections
logic BEN;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN; //mio energy

logic [15:0] MDR_In;
logic [15:0] MAR, PC, MDR, IR; 
logic [15:0] Data_from_SRAM, Data_to_SRAM;




// MODIFIED:
logic [15:0] plus_data, pc_off; // plus_data = PC+1, pc_off = PC+offset
logic [15:0] ALU; //created fake ALU for now (6.1)
logic [15:0] MDR_mux_out, PC_mux_out;
logic [15:0] bus_data;


logic [15:0] SR1, SR2;
logic [15:0] SR2MUX_out;
logic [15:0] IR_SEXT;


assign pc_off = 16'h0000;


// Signals being displayed on hex display
logic [3:0][3:0] hex_4;

// For week 1, hexdrivers will display IR. Comment out these in week 2.
HexDriver hex_driver3 (IR[15:12], HEX3);
HexDriver hex_driver2 (IR[11:8], HEX2);
HexDriver hex_driver1 (IR[7:4], HEX1);
HexDriver hex_driver0 (IR[3:0], HEX0);

// For week 2, hexdrivers will be mounted to Mem2IO
// HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
// HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
// HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
// HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC[15:12], HEX7);
HexDriver hex_driver6 (PC[11:8], HEX6);
HexDriver hex_driver5 (PC[7:4], HEX5);
HexDriver hex_driver4 (PC[3:0], HEX4);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
assign ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;


// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
// datapath d0 (.Reset(Reset_ah), .data1(PC), .data1_select(GatePC),.data2(MDR), .data2_select(GateMDR),.data3(ALU), .data3_select(GateALU),.data4(MAR), .data4_select(GateMARMUX), .data_out(bus_data));

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);


// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);


//*****************************************************************************************//
// MODIFIED
//*****************************************************************************************//

// register unit
registerUnit regFile(
    .Clk(Clk), .Reset(Reset_ah), .LD_REG(LD_REG), .DR_select(DRMUX), .SR1_select(SR1MUX), .SR2(IR[2:0]), .bus_data(bus_data), .IR(IR),
    .SR1_out(SR1), .SR2_out(SR2)
);

sext_16 sext16(
    .in(IR[4:0]), .out(IR_SEXT)
);

mux2_16 sr2_mux(
    .select(SR2MUX), .data_in_1(SR2), .data_in_2(IR_SEXT), 
    .data_out(SR2MUX_out)    
);

alu alu_bruh (
    .select(ALUK), .A(SR1), .B(SR2MUX_out),
    .data_out(ALU)
);

// registers
register16 pc_register(
	 .Clk(Clk), .Reset(Reset_ah), .data_in(PC_mux_out), .Load_Enable(LD_PC),
	 .data_out(PC)
);

register16 mdr_register(
	 .Clk(Clk), .Reset(Reset_ah), .data_in(MDR_mux_out), .Load_Enable(LD_MDR),
	 .data_out(MDR)
);

register16 mar_register(
	 .Clk(Clk), .Reset(Reset_ah), .data_in(bus_data), .Load_Enable(LD_MAR),
	 .data_out(MAR)
);

register16 ir_register(
	 .Clk(Clk), .Reset(Reset_ah), .data_in(bus_data), .Load_Enable(LD_IR),
	 .data_out(IR)
);


// register muxes
mux4_16 pc_mux(
	.select(PCMUX), .data_in_3(bus_data),  .data_in_2(pc_off), .data_in_1(plus_data),
    .data_out(PC_mux_out)
);

mux2_16 mdr_mux(
    .select(MIO_EN), .data_in_1(bus_data), .data_in_2(MDR_In), 
    .data_out(MDR_mux_out)
);


// tristate buffers
tristate_gate #(.N(16)) pc_tristate(
		.Clk(Clk), .tristate_output_enable(GatePC), .data_in(PC), .data_out(bus_data)
);

tristate_gate #(.N(16)) marmux_tristate(
		.Clk(Clk), .tristate_output_enable(GateMARMUX), .data_in(pc_off), .data_out(bus_data)
);

tristate_gate #(.N(16)) mdr_tristate(
		.Clk(Clk), .tristate_output_enable(GateMDR), .data_in(MDR), .data_out(bus_data)
);

tristate_gate #(.N(16)) alu_tristate(
		.Clk(Clk), .tristate_output_enable(GateALU), .data_in(ALU), .data_out(bus_data)
);

// misc
pc_increment pcplusone(
    .in(PC), .out(plus_data)
);

endmodule
