module WallaceTree (
						  input logic [15:0] MUR, MUD, //multiplier and multiplicand
						  output logic [31:0] result);
						  
		logic[31:0] intermediate_result;
		logic[15:0] MUR1;
		logic[15:0] MUD1;
		logic[31:0] z1;
		logic[31:0] z2;
		logic[1:0] switcher; //specifies if we should two's complement the result
		TCGenerator16 tcgen1(.IN(MUR), .OUT(MUR1), .switched(switcher[0]));
		TCGenerator16 tcgen2(.IN(MUD), .OUT(MUD1), .switched(switcher[1]));
		
		logic pp[15:0][15:0]; //partial products

		always_comb begin
			
			int i, j;
			for (i = 0; i <= 15; i = i+1)
			for (j = 0; j <= 15; j = j+1)
			pp[j][i] <= MUR1[j] & MUD1[i];
//			$display("MUR is %d", MUR);
//			$display("MUD is %d", MUD);
//
//			$display("MUR1 is %d", MUR1);
//			$display("MUD1 is %d", MUD1);
			end
			
//		always_comb begin
//			
//			int k;
//			for (k = 0; k <= 15; k = k+1)
//			test[k] <= pp[0][k];
//			
//		end
//		always_comb begin
//			
//			int l;
//			for (l = 0; l <= 15; l = l+1)
//			test2[l] <= pp[1][l];
//			
//		end
						  
//half_adder ha1(.x(pp[2][2]), .y(pp[1][3]), .s(ha1s), .c(ha1c));
//half_adder ha2(.x(pp[1][2]), .y(pp[0][3]), .s(ha2s), .c(ha2c));
//
//full_adder fa1(.x(pp[3][2]), .y(pp[2][3]), .cin(ha1c),     .s(z2[5]), .c(z1[6]));
//full_adder fa2(.x(ha1s),     .y(pp[3][1]), .cin(ha2c),     .s(z2[4]), .c(z1[5]));
//full_adder fa3(.x(ha2s),     .y(pp[3][0]), .cin(pp[2][1]), .s(z2[3]), .c(z1[4]));
//full_adder fa4(.x(pp[1][1]), .y(pp[0][2]), .cin(0),      .s(z2[2]), .c(z1[3]));

wire fas[200:0];
wire has[200:0];
wire fac[200:0];
wire hac[200:0];
wire dot[200:0];

/*stage 1******************/ 
assign dot[0] = pp[0][0];
half_adder ha0( .x(pp[0][1]),  .y(pp[1][0]),  .s(has[0]), .c(hac[0]));
full_adder fa0( .x(pp[0][2]),  .y(pp[1][1]),  .cin(pp[2][0]),  .s(fas[0]),  .c(fac[0]));
full_adder fa1( .x(pp[0][3]),  .y(pp[1][2]),  .cin(pp[2][1]),  .s(fas[1]),  .c(fac[1]));
full_adder fa2( .x(pp[0][4]),  .y(pp[1][3]),  .cin(pp[2][2]),  .s(fas[2]),  .c(fac[2]));
full_adder fa3( .x(pp[0][5]),  .y(pp[1][4]),  .cin(pp[2][3]),  .s(fas[3]),  .c(fac[3]));
full_adder fa4( .x(pp[0][6]),  .y(pp[1][5]),  .cin(pp[2][4]),  .s(fas[4]),  .c(fac[4]));
full_adder fa5( .x(pp[0][7]),  .y(pp[1][6]),  .cin(pp[2][5]),  .s(fas[5]),  .c(fac[5]));
full_adder fa6( .x(pp[0][8]),  .y(pp[1][7]),  .cin(pp[2][6]),  .s(fas[6]),  .c(fac[6]));
full_adder fa7( .x(pp[0][9]),  .y(pp[1][8]),  .cin(pp[2][7]),  .s(fas[7]),  .c(fac[7]));
full_adder fa8( .x(pp[0][10]), .y(pp[1][9]),  .cin(pp[2][8]),  .s(fas[8]),  .c(fac[8]));
full_adder fa9( .x(pp[0][11]), .y(pp[1][10]), .cin(pp[2][9]),  .s(fas[9]),  .c(fac[9]));
full_adder fa10(.x(pp[0][12]), .y(pp[1][11]), .cin(pp[2][10]), .s(fas[10]), .c(fac[10]));
full_adder fa11(.x(pp[0][13]), .y(pp[1][12]), .cin(pp[2][11]), .s(fas[11]), .c(fac[11]));
full_adder fa12(.x(pp[0][14]), .y(pp[1][13]), .cin(pp[2][12]), .s(fas[12]), .c(fac[12]));
full_adder fa13(.x(pp[0][15]), .y(pp[1][14]), .cin(pp[2][13]), .s(fas[13]), .c(fac[13]));
half_adder ha1( .x(pp[1][15]), .y(pp[2][14]), .s(has[1]), .c(hac[1]));
assign dot[1] = pp[2][15];

assign dot[2] = pp[3][0];
half_adder ha2( .x(pp[3][1]),  .y(pp[4][0]),  .s(has[2]), .c(hac[2]));
full_adder fa14(.x(pp[3][2]),  .y(pp[4][1]),  .cin(pp[5][0]),  .s(fas[14]), .c(fac[14]));
full_adder fa15(.x(pp[3][3]),  .y(pp[4][2]),  .cin(pp[5][1]),  .s(fas[15]), .c(fac[15]));
full_adder fa16(.x(pp[3][4]),  .y(pp[4][3]),  .cin(pp[5][2]),  .s(fas[16]), .c(fac[16]));
full_adder fa17(.x(pp[3][5]),  .y(pp[4][4]),  .cin(pp[5][3]),  .s(fas[17]), .c(fac[17]));
full_adder fa18(.x(pp[3][6]),  .y(pp[4][5]),  .cin(pp[5][4]),  .s(fas[18]), .c(fac[18]));
full_adder fa19(.x(pp[3][7]),  .y(pp[4][6]),  .cin(pp[5][5]),  .s(fas[19]), .c(fac[19]));
full_adder fa20(.x(pp[3][8]),  .y(pp[4][7]),  .cin(pp[5][6]),  .s(fas[20]), .c(fac[20]));
full_adder fa21(.x(pp[3][9]),  .y(pp[4][8]),  .cin(pp[5][7]),  .s(fas[21]), .c(fac[21]));
full_adder fa22(.x(pp[3][10]), .y(pp[4][9]),  .cin(pp[5][8]),  .s(fas[22]), .c(fac[22]));
full_adder fa23(.x(pp[3][11]), .y(pp[4][10]), .cin(pp[5][9]),  .s(fas[23]), .c(fac[23]));
full_adder fa24(.x(pp[3][12]), .y(pp[4][11]), .cin(pp[5][10]), .s(fas[24]), .c(fac[24]));
full_adder fa25(.x(pp[3][13]), .y(pp[4][12]), .cin(pp[5][11]), .s(fas[25]), .c(fac[25]));
full_adder fa26(.x(pp[3][14]), .y(pp[4][13]), .cin(pp[5][12]), .s(fas[26]), .c(fac[26]));
full_adder fa27(.x(pp[3][15]), .y(pp[4][14]), .cin(pp[5][13]), .s(fas[27]), .c(fac[27]));
half_adder ha3( .x(pp[4][15]), .y(pp[5][14]), .s(has[3]), .c(hac[3]));
assign dot[3] = pp[5][15];

assign dot[4] = pp[6][0];
half_adder ha4( .x(pp[6][1]), .y(pp[7][0]), .s(has[4]), .c(hac[4]));
full_adder fa28(.x(pp[6][2]),  .y(pp[7][1]),  .cin(pp[8][0]), .s(fas[28]),  .c(fac[28]));
full_adder fa29(.x(pp[6][3]),  .y(pp[7][2]),  .cin(pp[8][1]), .s(fas[29]),  .c(fac[29]));
full_adder fa30(.x(pp[6][4]),  .y(pp[7][3]),  .cin(pp[8][2]), .s(fas[30]),  .c(fac[30]));
full_adder fa31(.x(pp[6][5]),  .y(pp[7][4]),  .cin(pp[8][3]), .s(fas[31]),  .c(fac[31]));
full_adder fa32(.x(pp[6][6]),  .y(pp[7][5]),  .cin(pp[8][4]), .s(fas[32]),  .c(fac[32]));
full_adder fa33(.x(pp[6][7]),  .y(pp[7][6]),  .cin(pp[8][5]), .s(fas[33]),  .c(fac[33]));
full_adder fa34(.x(pp[6][8]),  .y(pp[7][7]),  .cin(pp[8][6]), .s(fas[34]),  .c(fac[34]));
full_adder fa35(.x(pp[6][9]),  .y(pp[7][8]),  .cin(pp[8][7]), .s(fas[35]),  .c(fac[35]));
full_adder fa36(.x(pp[6][10]), .y(pp[7][9]),  .cin(pp[8][8]), .s(fas[36]),  .c(fac[36]));
full_adder fa37(.x(pp[6][11]), .y(pp[7][10]), .cin(pp[8][9]), .s(fas[37]),  .c(fac[37]));
full_adder fa38(.x(pp[6][12]), .y(pp[7][11]), .cin(pp[8][10]), .s(fas[38]), .c(fac[38]));
full_adder fa39(.x(pp[6][13]), .y(pp[7][12]), .cin(pp[8][11]), .s(fas[39]), .c(fac[39]));
full_adder fa40(.x(pp[6][14]), .y(pp[7][13]), .cin(pp[8][12]), .s(fas[40]), .c(fac[40]));
full_adder fa41(.x(pp[6][15]), .y(pp[7][14]), .cin(pp[8][13]), .s(fas[41]), .c(fac[41]));
half_adder ha5( .x(pp[7][15]), .y(pp[8][14]), .s(has[5]), .c(hac[5]));
assign dot[5] = pp[8][15];

assign dot[6] = pp[9][0];
half_adder ha6( .x(pp[9][1]), .y(pp[10][0]), .s(has[6]), .c(hac[6]));
full_adder fa42(.x(pp[9][2]),  .y(pp[10][1]),  .cin(pp[11][0]), .s(fas[42]), .c(fac[42]));
full_adder fa43(.x(pp[9][3]),  .y(pp[10][2]),  .cin(pp[11][1]), .s(fas[43]), .c(fac[43]));
full_adder fa44(.x(pp[9][4]),  .y(pp[10][3]),  .cin(pp[11][2]), .s(fas[44]), .c(fac[44]));
full_adder fa45(.x(pp[9][5]),  .y(pp[10][4]),  .cin(pp[11][3]), .s(fas[45]), .c(fac[45]));
full_adder fa46(.x(pp[9][6]),  .y(pp[10][5]),  .cin(pp[11][4]), .s(fas[46]), .c(fac[46]));
full_adder fa47(.x(pp[9][7]),  .y(pp[10][6]),  .cin(pp[11][5]), .s(fas[47]), .c(fac[47]));
full_adder fa48(.x(pp[9][8]),  .y(pp[10][7]),  .cin(pp[11][6]), .s(fas[48]), .c(fac[48]));
full_adder fa49(.x(pp[9][9]),  .y(pp[10][8]),  .cin(pp[11][7]), .s(fas[49]), .c(fac[49]));
full_adder fa50(.x(pp[9][10]), .y(pp[10][9]),  .cin(pp[11][8]), .s(fas[50]), .c(fac[50]));
full_adder fa51(.x(pp[9][11]), .y(pp[10][10]), .cin(pp[11][9]), .s(fas[51]), .c(fac[51]));
full_adder fa52(.x(pp[9][12]), .y(pp[10][11]), .cin(pp[11][10]), .s(fas[52]), .c(fac[52]));
full_adder fa53(.x(pp[9][13]), .y(pp[10][12]), .cin(pp[11][11]), .s(fas[53]), .c(fac[53]));
full_adder fa54(.x(pp[9][14]), .y(pp[10][13]), .cin(pp[11][12]), .s(fas[54]), .c(fac[54]));
full_adder fa55(.x(pp[9][15]), .y(pp[10][14]), .cin(pp[11][13]), .s(fas[55]), .c(fac[55]));
half_adder ha7( .x(pp[10][15]), .y(pp[11][14]), .s(has[7]), .c(hac[7]));
assign dot[7] = pp[11][15];

assign dot[8] = pp[12][0];
half_adder ha8( .x(pp[12][1]), .y(pp[13][0]), .s(has[8]), .c(hac[8]));
full_adder fa56(.x(pp[12][2]),  .y(pp[13][1]),  .cin(pp[14][0]),  .s(fas[56]), .c(fac[56]));
full_adder fa57(.x(pp[12][3]),  .y(pp[13][2]),  .cin(pp[14][1]),  .s(fas[57]), .c(fac[57]));
full_adder fa58(.x(pp[12][4]),  .y(pp[13][3]),  .cin(pp[14][2]),  .s(fas[58]), .c(fac[58]));
full_adder fa59(.x(pp[12][5]),  .y(pp[13][4]),  .cin(pp[14][3]),  .s(fas[59]), .c(fac[59]));
full_adder fa60(.x(pp[12][6]),  .y(pp[13][5]),  .cin(pp[14][4]),  .s(fas[60]), .c(fac[60]));
full_adder fa61(.x(pp[12][7]),  .y(pp[13][6]),  .cin(pp[14][5]),  .s(fas[61]), .c(fac[61]));
full_adder fa62(.x(pp[12][8]),  .y(pp[13][7]),  .cin(pp[14][6]),  .s(fas[62]), .c(fac[62]));
full_adder fa63(.x(pp[12][9]),  .y(pp[13][8]),  .cin(pp[14][7]),  .s(fas[63]), .c(fac[63]));
full_adder fa64(.x(pp[12][10]), .y(pp[13][9]),  .cin(pp[14][8]),  .s(fas[64]), .c(fac[64]));
full_adder fa65(.x(pp[12][11]), .y(pp[13][10]), .cin(pp[14][9]),  .s(fas[65]), .c(fac[65]));
full_adder fa66(.x(pp[12][12]), .y(pp[13][11]), .cin(pp[14][10]), .s(fas[66]), .c(fac[66]));
full_adder fa67(.x(pp[12][13]), .y(pp[13][12]), .cin(pp[14][11]), .s(fas[67]), .c(fac[67]));
full_adder fa68(.x(pp[12][14]), .y(pp[13][13]), .cin(pp[14][12]), .s(fas[68]), .c(fac[68]));
full_adder fa69(.x(pp[12][15]), .y(pp[13][14]), .cin(pp[14][13]), .s(fas[69]), .c(fac[69]));
half_adder ha9( .x(pp[13][15]), .y(pp[14][14]), .s(has[9]), .c(hac[9]));
assign dot[9] = pp[14][15];

assign dot[10]  = pp[15][0];
assign dot[11] = pp[15][1];
assign dot[12] = pp[15][2];
assign dot[13] = pp[15][3];
assign dot[14] = pp[15][4];
assign dot[15] = pp[15][5];
assign dot[16] = pp[15][6];
assign dot[17] = pp[15][7];
assign dot[18] = pp[15][8];
assign dot[19] = pp[15][9];
assign dot[20] = pp[15][10];
assign dot[21] = pp[15][11];
assign dot[22] = pp[15][12];
assign dot[23] = pp[15][13];
assign dot[24] = pp[15][14];
assign dot[25] = pp[15][15];
/***********************/
/*stage 2***************/
assign dot[26] = dot[0];
assign dot[27] = has[0];
half_adder ha10(.x(fas[0]), .y(hac[0]), .s(has[10]), .c(hac[10]));
full_adder fa70(.x(fas[1]),  .y(fac[0]),  .cin(dot[2]), .s(fas[70]), .c(fac[70]));
full_adder fa71(.x(fas[2]),  .y(fac[1]),  .cin(has[2]), .s(fas[71]), .c(fac[71]));
full_adder fa72(.x(fas[3]),  .y(fac[2]),  .cin(fas[14]), .s(fas[72]), .c(fac[72]));
full_adder fa73(.x(fas[4]),  .y(fac[3]),  .cin(fas[15]), .s(fas[73]), .c(fac[73]));
full_adder fa74(.x(fas[5]),  .y(fac[4]),  .cin(fas[16]), .s(fas[74]), .c(fac[74]));
full_adder fa75(.x(fas[6]),  .y(fac[5]),  .cin(fas[17]), .s(fas[75]), .c(fac[75]));
full_adder fa76(.x(fas[7]),  .y(fac[6]),  .cin(fas[18]), .s(fas[76]), .c(fac[76]));
full_adder fa77(.x(fas[8]),  .y(fac[7]),  .cin(fas[19]), .s(fas[77]), .c(fac[77]));
full_adder fa78(.x(fas[9]),  .y(fac[8]),  .cin(fas[20]), .s(fas[78]), .c(fac[78]));
full_adder fa79(.x(fas[10]), .y(fac[9]),  .cin(fas[21]), .s(fas[79]), .c(fac[79]));
full_adder fa80(.x(fas[11]), .y(fac[10]), .cin(fas[23]), .s(fas[80]), .c(fac[80]));
full_adder fa81(.x(fas[12]), .y(fac[11]), .cin(fas[24]), .s(fas[81]), .c(fac[81]));
full_adder fa82(.x(fas[13]), .y(fac[12]), .cin(fas[25]), .s(fas[82]), .c(fac[82]));
full_adder fa83(.x(has[1]),  .y(fac[13]), .cin(fas[26]), .s(fas[83]), .c(fac[83]));
full_adder fa84(.x(dot[1]),  .y(hac[1]),  .cin(fas[27]), .s(fas[84]), .c(fac[84]));
assign dot[28] = fas[28];
assign dot[29] = has[3];
assign dot[30] = dot[3];

assign dot[31] = hac[2];
half_adder ha11(.x(fac[14]), .y(dot[4]), .s(has[11]), .c(hac[11]));
half_adder ha12(.x(fac[15]), .y(has[4]), .s(has[12]), .c(hac[12]));
full_adder fa85(.x(fac[16]),  .y(fas[28]),  .cin(hac[4]), .s(fas[85]), .c(fac[85]));
full_adder fa86(.x(fac[17]),  .y(fas[29]),  .cin(fac[28]), .s(fas[86]), .c(fac[86]));
full_adder fa87(.x(fac[18]),  .y(fas[30]),  .cin(fac[29]), .s(fas[87]), .c(fac[87]));
full_adder fa88(.x(fac[19]),  .y(fas[31]),  .cin(fac[30]), .s(fas[88]), .c(fac[88]));
full_adder fa89(.x(fac[20]),  .y(fas[32]),  .cin(fac[31]), .s(fas[89]), .c(fac[89]));
full_adder fa90(.x(fac[21]),  .y(fas[33]),  .cin(fac[32]), .s(fas[90]), .c(fac[90]));
full_adder fa91(.x(fac[22]),  .y(fas[34]),  .cin(fac[33]), .s(fas[91]), .c(fac[91]));
full_adder fa92(.x(fac[23]),  .y(fas[35]),  .cin(fac[34]), .s(fas[92]), .c(fac[92]));
full_adder fa93(.x(fac[24]),  .y(fas[36]),  .cin(fac[35]), .s(fas[93]), .c(fac[93]));
full_adder fa94(.x(fac[25]),  .y(fas[37]),  .cin(fac[36]), .s(fas[94]), .c(fac[94]));
full_adder fa95(.x(fac[26]),  .y(fas[38]),  .cin(fac[37]), .s(fas[95]), .c(fac[95]));
full_adder fa96(.x(fac[27]),  .y(fas[39]),  .cin(fac[38]), .s(fas[96]), .c(fac[96]));
full_adder fa97(.x(hac[3]),   .y(fas[40]),  .cin(fac[39]), .s(fas[97]), .c(fac[97]));
half_adder ha13(.x(fas[41]), .y(fac[40]), .s(has[13]), .c(hac[13]));
half_adder ha14(.x(has[5]), .y(fac[41]), .s(has[14]), .c(hac[14]));
half_adder ha15(.x(dot[5]), .y(hac[5]), .s(has[15]), .c(hac[15]));

assign dot[32] = dot[6];
assign dot[33] = has[6];
half_adder ha16(.x(fas[42]), .y(hac[6]), .s(has[16]), .c(hac[16]));
full_adder fa98(.x(fas[43]), .y(fac[42]),  .cin(dot[8]), .s(fas[98]), .c(fac[98]));
full_adder fa99(.x(fas[44]), .y(fac[43]),  .cin(has[8]), .s(fas[99]), .c(fac[99]));
full_adder fa100(.x(fas[45]), .y(fac[44]),  .cin(fas[56]), .s(fas[100]), .c(fac[100]));
full_adder fa101(.x(fas[46]), .y(fac[45]),  .cin(fas[57]), .s(fas[101]), .c(fac[101]));
full_adder fa102(.x(fas[47]), .y(fac[46]),  .cin(fas[58]), .s(fas[102]), .c(fac[102]));
full_adder fa103(.x(fas[48]), .y(fac[47]),  .cin(fas[59]), .s(fas[103]), .c(fac[103]));
full_adder fa104(.x(fas[49]), .y(fac[48]),  .cin(fas[60]), .s(fas[104]), .c(fac[104]));
full_adder fa105(.x(fas[50]), .y(fac[49]),  .cin(fas[61]), .s(fas[105]), .c(fac[105]));
full_adder fa106(.x(fas[51]), .y(fac[50]),  .cin(fas[62]), .s(fas[106]), .c(fac[106]));
full_adder fa107(.x(fas[52]), .y(fac[51]),  .cin(fas[63]), .s(fas[107]), .c(fac[107]));
full_adder fa108(.x(fas[53]), .y(fac[52]),  .cin(fas[64]), .s(fas[108]), .c(fac[108]));
full_adder fa109(.x(fas[54]), .y(fac[53]),  .cin(fas[65]), .s(fas[109]), .c(fac[109]));
full_adder fa110(.x(fas[55]), .y(fac[54]),  .cin(fas[66]), .s(fas[110]), .c(fac[110]));
full_adder fa111(.x(has[7]),  .y(fac[55]),  .cin(fas[67]), .s(fas[111]), .c(fac[111]));
full_adder fa112(.x(dot[7]),  .y(hac[7]),   .cin(fas[68]), .s(fas[112]), .c(fac[112]));
assign dot[34] = fas[69];
assign dot[35] = has[9];
assign dot[36] = dot[9];

//last two rows of dots will carry over a few times, keep track of them

/*stage 3********/
//dot[26], dot[27]
assign dot[37] = has[10];
half_adder ha17(.x(fas[70]), .y(hac[10]), .s(has[17]), .c(hac[17]));
half_adder ha18(.x(fas[71]), .y(fac[70]), .s(has[18]), .c(hac[18]));
full_adder fa113(.x(fas[72]),  .y(fac[71]),   .cin(dot[31]), .s(fas[113]), .c(fac[113]));
full_adder fa114(.x(fas[73]),  .y(fac[72]),   .cin(has[11]), .s(fas[114]), .c(fac[114]));
full_adder fa115(.x(fas[74]),  .y(fac[73]),   .cin(has[12]), .s(fas[115]), .c(fac[115]));
full_adder fa116(.x(fas[75]),  .y(fac[74]),   .cin(fas[85]), .s(fas[116]), .c(fac[116]));
full_adder fa117(.x(fas[76]),  .y(fac[75]),   .cin(fas[86]), .s(fas[117]), .c(fac[117]));
full_adder fa118(.x(fas[77]),  .y(fac[76]),   .cin(fas[87]), .s(fas[118]), .c(fac[118]));
full_adder fa119(.x(fas[78]),  .y(fac[77]),   .cin(fas[88]), .s(fas[119]), .c(fac[119]));
full_adder fa120(.x(fas[79]),  .y(fac[78]),   .cin(fas[89]), .s(fas[120]), .c(fac[120]));
full_adder fa121(.x(fas[80]),  .y(fac[79]),   .cin(fas[90]), .s(fas[121]), .c(fac[121]));
full_adder fa122(.x(fas[81]),  .y(fac[80]),   .cin(fas[91]), .s(fas[122]), .c(fac[122]));
full_adder fa123(.x(fas[82]),  .y(fac[81]),   .cin(fas[92]), .s(fas[123]), .c(fac[123]));
full_adder fa124(.x(fas[83]),  .y(fac[82]),   .cin(fas[93]), .s(fas[124]), .c(fac[124]));
full_adder fa125(.x(fas[84]),  .y(fac[83]),   .cin(fas[94]), .s(fas[125]), .c(fac[125]));
full_adder fa126(.x(dot[28]),  .y(fac[84]),   .cin(fas[95]), .s(fas[126]), .c(fac[126]));
half_adder ha19(.x(dot[29]), .y(fas[96]), .s(has[19]), .c(hac[19]));
half_adder ha20(.x(dot[30]), .y(fas[97]), .s(has[20]), .c(hac[20]));
assign dot[38] = has[13];
assign dot[39] = has[14];
assign dot[40] = has[15];

assign dot[41] = hac[11];
assign dot[42] = hac[12];
half_adder ha21(.x(fac[85]), .y(dot[32]), .s(has[21]), .c(hac[21]));
half_adder ha22(.x(fac[86]), .y(fac[86]), .s(has[22]), .c(hac[22]));
half_adder ha23(.x(fac[87]), .y(has[16]), .s(has[23]), .c(hac[23]));
full_adder fa127(.x(fac[88]),  .y(fas[98]),  .cin(hac[16]),  .s(fas[127]), .c(fac[127]));
full_adder fa128(.x(fac[89]),  .y(fas[99]),  .cin(fac[98]),  .s(fas[128]), .c(fac[128]));
full_adder fa129(.x(fac[90]),  .y(fas[100]), .cin(fac[99]),  .s(fas[129]), .c(fac[129]));
full_adder fa130(.x(fac[91]),  .y(fas[101]), .cin(fac[100]), .s(fas[130]), .c(fac[130]));
full_adder fa131(.x(fac[92]),  .y(fas[102]), .cin(fac[101]), .s(fas[131]), .c(fac[131]));
full_adder fa132(.x(fac[93]),  .y(fas[103]), .cin(fac[102]), .s(fas[132]), .c(fac[132]));
full_adder fa133(.x(fac[94]),  .y(fas[104]), .cin(fac[103]), .s(fas[133]), .c(fac[133]));
full_adder fa134(.x(fac[95]),  .y(fas[105]), .cin(fac[104]), .s(fas[134]), .c(fac[134]));
full_adder fa135(.x(fac[96]),  .y(fas[106]), .cin(fac[105]), .s(fas[135]), .c(fac[135]));
full_adder fa136(.x(fac[97]),  .y(fas[107]), .cin(fac[106]), .s(fas[136]), .c(fac[136]));
full_adder fa137(.x(hac[13]),  .y(fas[108]), .cin(fac[107]), .s(fas[137]), .c(fac[137]));
full_adder fa138(.x(hac[14]),  .y(fas[109]), .cin(fac[108]), .s(fas[138]), .c(fac[138]));
full_adder fa139(.x(hac[15]),  .y(fas[110]), .cin(fac[109]), .s(fas[139]), .c(fac[139]));
half_adder ha24(.x(fas[111]), .y(fac[110]), .s(has[24]), .c(hac[24]));
half_adder ha25(.x(fas[112]), .y(fac[111]), .s(has[25]), .c(hac[25]));
half_adder ha26(.x(dot[34]), .y(fac[112]), .s(has[26]), .c(hac[26]));
assign dot[43] = dot[35];
assign dot[44] = dot[36]; 
/***************/
/*stage 4 **********/
//dot[26], [27], [37]
assign dot[45] = has[17];
half_adder ha27(.x(has[18]), .y(hac[17]), .s(has[27]), .c(hac[27]));
half_adder ha28(.x(fas[113]), .y(hac[18]), .s(has[28]), .c(hac[28]));
half_adder ha29(.x(fas[114]), .y(fac[113]), .s(has[29]), .c(hac[29]));
full_adder fa140(.x(fas[115]), .y(fac[114]), .cin(dot[41]), .s(fas[140]), .c(fac[140]));
full_adder fa141(.x(fas[116]), .y(fac[115]), .cin(dot[42]), .s(fas[141]), .c(fac[141]));
full_adder fa142(.x(fas[117]), .y(fac[116]), .cin(has[21]), .s(fas[142]), .c(fac[142]));
full_adder fa143(.x(fas[118]), .y(fac[117]), .cin(has[22]), .s(fas[143]), .c(fac[143]));
full_adder fa144(.x(fas[119]), .y(fac[118]), .cin(has[23]), .s(fas[144]), .c(fac[144]));
full_adder fa145(.x(fas[120]), .y(fac[119]), .cin(fas[127]), .s(fas[145]), .c(fac[145]));
full_adder fa146(.x(fas[121]), .y(fac[120]), .cin(fas[128]), .s(fas[146]), .c(fac[146]));
full_adder fa147(.x(fas[122]), .y(fac[121]), .cin(fas[129]), .s(fas[147]), .c(fac[147]));
full_adder fa148(.x(fas[123]), .y(fac[122]), .cin(fas[130]), .s(fas[148]), .c(fac[148]));
full_adder fa149(.x(fas[124]), .y(fac[123]), .cin(fas[131]), .s(fas[149]), .c(fac[149]));
full_adder fa150(.x(fas[125]), .y(fac[124]), .cin(fas[132]), .s(fas[150]), .c(fac[150]));
full_adder fa151(.x(fas[126]), .y(fac[125]), .cin(fas[133]), .s(fas[151]), .c(fac[151]));
full_adder fa152(.x(has[19]), .y(fac[126]), .cin(fas[134]), .s(fas[152]), .c(fac[152]));
full_adder fa153(.x(has[20]), .y(hac[19]), .cin(fas[135]), .s(fas[153]), .c(fac[153]));
full_adder fa154(.x(dot[38]), .y(hac[20]), .cin(fas[136]), .s(fas[154]), .c(fac[154]));
half_adder ha30(.x(dot[39]), .y(fas[137]), .s(has[30]), .c(hac[30]));
half_adder ha31(.x(dot[40]), .y(fas[138]), .s(has[31]), .c(hac[31]));
assign dot[46] = fas[139];
assign dot[47] = has[24];
assign dot[48] = has[25];
assign dot[49] = has[26];
//dot[43]

assign dot[50] = hac[21];
assign dot[51] = hac[22];
assign dot[52] = hac[23];
assign dot[53] = fac[127];
half_adder ha32(.x(fac[128]), .y(hac[8]), .s(has[32]), .c(hac[32])); //check first for errors
full_adder fa155(.x(fac[129]), .y(fac[56]), .cin(dot[10]), .s(fas[155]), .c(fac[155]));
full_adder fa156(.x(fac[130]), .y(fac[57]), .cin(dot[11]), .s(fas[156]), .c(fac[156]));
full_adder fa157(.x(fac[131]), .y(fac[58]), .cin(dot[12]), .s(fas[157]), .c(fac[157]));
full_adder fa158(.x(fac[132]), .y(fac[59]), .cin(dot[13]), .s(fas[158]), .c(fac[158]));
full_adder fa159(.x(fac[133]), .y(fac[60]), .cin(dot[14]), .s(fas[159]), .c(fac[159]));
full_adder fa160(.x(fac[134]), .y(fac[61]), .cin(dot[15]), .s(fas[160]), .c(fac[160]));
full_adder fa161(.x(fac[135]), .y(fac[62]), .cin(dot[16]), .s(fas[161]), .c(fac[161]));
full_adder fa162(.x(fac[136]), .y(fac[63]), .cin(dot[17]), .s(fas[162]), .c(fac[162]));
full_adder fa163(.x(fac[137]), .y(fac[64]), .cin(dot[18]), .s(fas[163]), .c(fac[163]));
full_adder fa164(.x(fac[138]), .y(fac[65]), .cin(dot[19]), .s(fas[164]), .c(fac[164]));
full_adder fa165(.x(fac[139]), .y(fac[66]), .cin(dot[20]), .s(fas[165]), .c(fac[165]));
full_adder fa166(.x(hac[24]), .y(fac[67]), .cin(dot[21]), .s(fas[166]), .c(fac[166]));
full_adder fa167(.x(hac[25]), .y(fac[68]), .cin(dot[22]), .s(fas[167]), .c(fac[167]));
full_adder fa168(.x(hac[26]), .y(fac[69]), .cin(dot[23]), .s(fas[168]), .c(fac[168]));
full_adder fa169(.x(dot[36]), .y(hac[9]), .cin(dot[24]), .s(fas[169]), .c(fac[169]));
assign dot[54] = dot[25];
/**************/
/*stage 5 *****/
//dot[26], [27], [37], [45]
assign dot[55] = has[27];
half_adder ha33(.x(has[28]), .y(hac[27]), .s(has[33]), .c(hac[33]));
half_adder ha34(.x(has[29]), .y(hac[28]), .s(has[34]), .c(hac[34]));
half_adder ha35(.x(fas[140]), .y(hac[29]), .s(has[35]), .c(hac[35]));
half_adder ha36(.x(fas[141]), .y(fac[140]), .s(has[36]), .c(hac[36]));
half_adder ha37(.x(fas[142]), .y(fac[141]), .s(has[37]), .c(hac[37]));
full_adder fa170(.x(fas[143]), .y(fac[142]), .cin(dot[50]), .s(fas[170]), .c(fac[170]));
full_adder fa171(.x(fas[144]), .y(fac[143]), .cin(dot[51]), .s(fas[171]), .c(fac[171]));
full_adder fa172(.x(fas[145]), .y(fac[144]), .cin(dot[52]), .s(fas[172]), .c(fac[172]));
full_adder fa173(.x(fas[146]), .y(fac[145]), .cin(dot[53]), .s(fas[173]), .c(fac[173]));
full_adder fa174(.x(fas[147]), .y(fac[146]), .cin(has[32]), .s(fas[174]), .c(fac[174]));
full_adder fa175(.x(fas[148]), .y(fac[147]), .cin(fas[155]), .s(fas[175]), .c(fac[175]));
full_adder fa176(.x(fas[149]), .y(fac[148]), .cin(fas[156]), .s(fas[176]), .c(fac[176]));
full_adder fa177(.x(fas[150]), .y(fac[149]), .cin(fas[157]), .s(fas[177]), .c(fac[177]));
full_adder fa178(.x(fas[151]), .y(fac[150]), .cin(fas[158]), .s(fas[178]), .c(fac[178]));
full_adder fa179(.x(fas[152]), .y(fac[151]), .cin(fas[159]), .s(fas[179]), .c(fac[179]));
full_adder fa180(.x(fas[153]), .y(fac[152]), .cin(fas[160]), .s(fas[180]), .c(fac[180]));
full_adder fa181(.x(fas[154]), .y(fac[153]), .cin(fas[161]), .s(fas[181]), .c(fac[181]));
full_adder fa182(.x(has[30]), .y(fac[154]), .cin(fas[162]), .s(fas[182]), .c(fac[182]));
full_adder fa183(.x(has[31]), .y(hac[30]),  .cin(fas[163]), .s(fas[183]), .c(fac[183]));
full_adder fa184(.x(dot[46]), .y(hac[31]),  .cin(fas[164]), .s(fas[184]), .c(fac[184]));
half_adder ha38(.x(dot[47]), .y(fas[165]), .s(has[38]), .c(hac[38]));
half_adder ha39(.x(dot[48]), .y(fas[166]), .s(has[39]), .c(hac[39]));
half_adder ha40(.x(dot[49]), .y(fas[167]), .s(has[40]), .c(hac[40]));
half_adder ha41(.x(dot[43]), .y(fas[168]), .s(has[41]), .c(hac[41]));  ///check here
assign dot[56] = fas[169];
//dot[54]
/*************/
/*stage 6 ****/
//dot[26], [27], [37], [45], [55]
assign dot[57] = has[33];
half_adder ha42(.x(has[34]), .y(hac[33]), .s(has[42]), .c(hac[42])); 
half_adder ha43(.x(has[35]), .y(hac[34]), .s(has[43]), .c(hac[43])); 
half_adder ha44(.x(has[36]), .y(hac[35]), .s(has[44]), .c(hac[44])); 
half_adder ha45(.x(has[37]), .y(hac[36]), .s(has[45]), .c(hac[45])); 
half_adder ha46(.x(fas[170]), .y(hac[37]), .s(has[46]), .c(hac[46])); 
half_adder ha47(.x(fas[171]), .y(fac[170]), .s(has[47]), .c(hac[47])); 
half_adder ha48(.x(fas[172]), .y(fac[171]), .s(has[48]), .c(hac[48])); 
half_adder ha49(.x(fas[173]), .y(fac[172]), .s(has[49]), .c(hac[49])); 
half_adder ha50(.x(fas[174]), .y(fac[173]), .s(has[50]), .c(hac[50])); 
full_adder fa185(.x(fas[175]), .y(fac[174]),  .cin(hac[32]), .s(fas[185]), .c(fac[185]));
full_adder fa186(.x(fas[176]), .y(fac[175]),  .cin(fac[155]), .s(fas[186]), .c(fac[186]));
full_adder fa187(.x(fas[177]), .y(fac[176]),  .cin(fac[156]), .s(fas[187]), .c(fac[187]));
full_adder fa188(.x(fas[178]), .y(fac[177]),  .cin(fac[157]), .s(fas[188]), .c(fac[188]));
full_adder fa189(.x(fas[179]), .y(fac[178]),  .cin(fac[158]), .s(fas[189]), .c(fac[189]));
full_adder fa190(.x(fas[180]), .y(fac[179]),  .cin(fac[159]), .s(fas[190]), .c(fac[190]));
full_adder fa191(.x(fas[181]), .y(fac[180]),  .cin(fac[160]), .s(fas[191]), .c(fac[191]));
full_adder fa192(.x(fas[182]), .y(fac[181]),  .cin(fac[161]), .s(fas[192]), .c(fac[192]));
full_adder fa193(.x(fas[183]), .y(fac[182]),  .cin(fac[162]), .s(fas[193]), .c(fac[193]));
full_adder fa194(.x(fas[184]), .y(fac[183]),  .cin(fac[163]), .s(fas[194]), .c(fac[194]));
full_adder fa195(.x(has[38]), .y(fac[184]),  .cin(fac[164]), .s(fas[195]), .c(fac[195]));
full_adder fa196(.x(has[39]), .y(hac[38]),   .cin(fac[165]), .s(fas[196]), .c(fac[196]));
full_adder fa197(.x(has[40]), .y(hac[39]),   .cin(fac[166]), .s(fas[197]), .c(fac[197]));
full_adder fa198(.x(has[41]), .y(hac[40]),   .cin(fac[167]), .s(fas[198]), .c(fac[198]));
full_adder fa199(.x(dot[56]), .y(hac[41]),   .cin(fac[168]), .s(fas[199]), .c(fac[199]));
half_adder ha51(.x(dot[54]), .y(fac[169]), .s(has[51]), .c(hac[51])); 
/*************/
/*stage 7 ****/
assign z1[0] = dot[26];
assign z1[1] = dot[27];
assign z1[2] = dot[37];
assign z1[3] = dot[45];
assign z1[4] = dot[55];
assign z1[5] = dot[57];
assign z1[6] = has[42];
assign z1[7] = has[43];
assign z1[8] = has[44];
assign z1[9] = has[45];
assign z1[10] = has[46];
assign z1[11] = has[47];
assign z1[12] = has[48];
assign z1[13] = has[49];
assign z1[14] = has[50];
assign z1[15] = fas[185];
assign z1[16] = fas[186];
assign z1[17] = fas[187];
assign z1[18] = fas[188];
assign z1[19] = fas[189];
assign z1[20] = fas[190];
assign z1[21] = fas[191];
assign z1[22] = fas[192];
assign z1[23] = fas[193];
assign z1[24] = fas[194];
assign z1[25] = fas[195];
assign z1[26] = fas[196];
assign z1[27] = fas[197];
assign z1[28] = fas[198];
assign z1[29] = fas[199];
assign z1[30] = has[51];
assign z1[31] = 0;

assign z2[0] = 0;
assign z2[1] = 0;
assign z2[2] = 0;
assign z2[3] = 0;
assign z2[4] = 0;
assign z2[5] = 0;
assign z2[6] = 0;
assign z2[7] = hac[42];
assign z2[8] = hac[43];
assign z2[9] = hac[44];
assign z2[10] = hac[45];
assign z2[11] = hac[46];
assign z2[12] = hac[47];
assign z2[13] = hac[48];
assign z2[14] = hac[49];
assign z2[15] = hac[50];
assign z2[16] = fac[185];
assign z2[17] = fac[186];
assign z2[18] = fac[187];
assign z2[19] = fac[188];
assign z2[20] = fac[189];
assign z2[21] = fac[190];
assign z2[22] = fac[191];
assign z2[23] = fac[192];
assign z2[24] = fac[193];
assign z2[25] = fac[194];
assign z2[26] = fac[195];
assign z2[27] = fac[196];
assign z2[28] = fac[197];
assign z2[29] = fac[198];
assign z2[30] = fac[199];
assign z2[31] = hac[51];

logic cout;
carry_lookahead_adder32 car(.A(z1), .B(z2), .Sum(intermediate_result), .C0(cout));
TCGenerator32 tcgen3(.IN(intermediate_result), .switch(switcher), .OUT(result));



//end on .x = 139























// assign z1[7] = 0;
// assign z2[7] = 0;
// assign z2[6] = pp[3][3];
// assign z1[2] = pp[2][0];
// assign z1[1] = pp[0][1];
// assign z2[1] = pp[0][1];
// assign z2[0] = pp[0][0];
// assign z1[0] = 0;
// assign result1 = z1;
// assign result2 = z2;




						  
//TCGenerator tcgen0(.in(MUR), .out(MURtc));
//TCGenerator tcgen1(.in(MUD), .out(MUDtc));

endmodule
