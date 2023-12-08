`timescale 1ns/1ns
module crc32_D8(
	clk,
	rst_n,
	data_in, 
	crc_en,
	crc_init,
	crc,
	crcNext,
	crc_eth
);

	parameter Tp = 1;

	input clk;
	input rst_n;
	input [7:0] data_in;
	input crc_en;
	input crc_init;

	output reg [31:0] crc;
	
	output [31:0]crc_eth;

	output [31:0] crcNext;

	wire [7:0] Data;

	assign Data={data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7]};

	assign crcNext[0] = crc[24] ^ crc[30] ^ Data[0] ^ Data[6];
	assign crcNext[1] = crc[24] ^ crc[25] ^ crc[30] ^ crc[31] ^ Data[0] ^ Data[1] ^ Data[6] ^ Data[7];
	assign crcNext[2] = crc[24] ^ crc[25] ^ crc[26] ^ crc[30] ^ crc[31] ^ Data[0] ^ Data[1] ^ Data[2] ^ Data[6] ^ Data[7];
	assign crcNext[3] = crc[25] ^ crc[26] ^ crc[27] ^ crc[31] ^ Data[1] ^ Data[2] ^ Data[3] ^ Data[7];
	assign crcNext[4] = crc[24] ^ crc[26] ^ crc[27] ^ crc[28] ^ crc[30] ^ Data[0] ^ Data[2] ^ Data[3] ^ Data[4] ^ Data[6];
	assign crcNext[5] = crc[24] ^ crc[25] ^ crc[27] ^ crc[28] ^ crc[29] ^ crc[30] ^ crc[31] ^ Data[0] ^ Data[1] ^ Data[3] ^ Data[4] ^ Data[5] ^ Data[6] ^ Data[7];
	assign crcNext[6] = crc[25] ^ crc[26] ^ crc[28] ^ crc[29] ^ crc[30] ^ crc[31] ^ Data[1] ^ Data[2] ^ Data[4] ^ Data[5] ^ Data[6] ^ Data[7];
	assign crcNext[7] = crc[24] ^ crc[26] ^ crc[27] ^ crc[29] ^ crc[31] ^ Data[0] ^ Data[2] ^ Data[3] ^ Data[5] ^ Data[7];
	assign crcNext[8] = crc[0] ^ crc[24] ^ crc[25] ^ crc[27] ^ crc[28] ^ Data[0] ^ Data[1] ^ Data[3] ^ Data[4];
	assign crcNext[9] = crc[1] ^ crc[25] ^ crc[26] ^ crc[28] ^ crc[29] ^ Data[1] ^ Data[2] ^ Data[4] ^ Data[5];
	assign crcNext[10] = crc[2] ^ crc[24] ^ crc[26] ^ crc[27] ^ crc[29] ^ Data[0] ^ Data[2] ^ Data[3] ^ Data[5];
	assign crcNext[11] = crc[3] ^ crc[24] ^ crc[25] ^ crc[27] ^ crc[28] ^ Data[0] ^ Data[1] ^ Data[3] ^ Data[4];
	assign crcNext[12] = crc[4] ^ crc[24] ^ crc[25] ^ crc[26] ^ crc[28] ^ crc[29] ^ crc[30] ^ Data[0] ^ Data[1] ^ Data[2] ^ Data[4] ^ Data[5] ^ Data[6];
	assign crcNext[13] = crc[5] ^ crc[25] ^ crc[26] ^ crc[27] ^ crc[29] ^ crc[30] ^ crc[31] ^ Data[1] ^ Data[2] ^ Data[3] ^ Data[5] ^ Data[6] ^ Data[7];
	assign crcNext[14] = crc[6] ^ crc[26] ^ crc[27] ^ crc[28] ^ crc[30] ^ crc[31] ^ Data[2] ^ Data[3] ^ Data[4] ^ Data[6] ^ Data[7];
	assign crcNext[15] =  crc[7] ^ crc[27] ^ crc[28] ^ crc[29] ^ crc[31] ^ Data[3] ^ Data[4] ^ Data[5] ^ Data[7];
	assign crcNext[16] = crc[8] ^ crc[24] ^ crc[28] ^ crc[29] ^ Data[0] ^ Data[4] ^ Data[5];
	assign crcNext[17] = crc[9] ^ crc[25] ^ crc[29] ^ crc[30] ^ Data[1] ^ Data[5] ^ Data[6];
	assign crcNext[18] = crc[10] ^ crc[26] ^ crc[30] ^ crc[31] ^ Data[2] ^ Data[6] ^ Data[7];
	assign crcNext[19] = crc[11] ^ crc[27] ^ crc[31] ^ Data[3] ^ Data[7];
	assign crcNext[20] = crc[12] ^ crc[28] ^ Data[4];
	assign crcNext[21] = crc[13] ^ crc[29] ^ Data[5];
	assign crcNext[22] = crc[14] ^ crc[24] ^ Data[0];
	assign crcNext[23] = crc[15] ^ crc[24] ^ crc[25] ^ crc[30] ^ Data[0] ^ Data[1] ^ Data[6];
	assign crcNext[24] = crc[16] ^ crc[25] ^ crc[26] ^ crc[31] ^ Data[1] ^ Data[2] ^ Data[7];
	assign crcNext[25] = crc[17] ^ crc[26] ^ crc[27] ^ Data[2] ^ Data[3];
	assign crcNext[26] = crc[18] ^ crc[24] ^ crc[27] ^ crc[28] ^ crc[30] ^ Data[0] ^ Data[3] ^ Data[4] ^ Data[6];
	assign crcNext[27] = crc[19] ^ crc[25] ^ crc[28] ^ crc[29] ^ crc[31] ^ Data[1] ^ Data[4] ^ Data[5] ^ Data[7];
	assign crcNext[28] = crc[20] ^ crc[26] ^ crc[29] ^ crc[30] ^ Data[2] ^ Data[5] ^ Data[6];
	assign crcNext[29] = crc[21] ^ crc[27] ^ crc[30] ^ crc[31] ^ Data[3] ^ Data[6] ^ Data[7];
	assign crcNext[30] = crc[22] ^ crc[28] ^ crc[31] ^ Data[4] ^ Data[7];
	assign crcNext[31] = crc[23] ^ crc[29] ^ Data[5];

	always @ (posedge clk)
	if (!rst_n)
		crc <={32{1'b1}};
	else if(crc_init)
		crc <={32{1'b1}};
   else if (crc_en)
		crc <= #1 crcNext;

assign crc_eth = ~{
						crcNext[24], crcNext[25], crcNext[26], crcNext[27],crcNext[28], crcNext[29], crcNext[30], crcNext[31],
						crc[16], crc[17], crc[18], crc[19],crc[20], crc[21], crc[22], crc[23],
						crc[ 8], crc[ 9], crc[10], crc[11],crc[12], crc[13], crc[14], crc[15],
						crc[ 0], crc[ 1], crc[ 2], crc[ 3],crc[ 4], crc[ 5], crc[ 6], crc[ 7]};		

endmodule
