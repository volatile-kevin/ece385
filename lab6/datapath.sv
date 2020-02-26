module datapath(input logic Reset,
					 input logic [15:0] data1,
					 input logic data1_select,
					 input logic [15:0] data2,
					 input logic data2_select,
					 input logic [15:0] data3,
					 input logic data3_select,
					 input logic [15:0] data4,
					 input logic data4_select,
					 output logic [15:0]data_out);
					 
	logic [3:0]selection;
	assign selection = {data1_select,data2_select,data3_select,data4_select};

	always_comb begin //do we need to use always_ff instead?
		unique case (selection)
			4'b0001 : data_out = data1;
			4'b0010 : data_out = data2;
			4'b0100 : data_out = data3;
			4'b1000 : data_out = data4;
			default : data_out = 4'b0000;
		endcase
		
		if (Reset)
			data_out = 4'b0000;
	end
	

endmodule