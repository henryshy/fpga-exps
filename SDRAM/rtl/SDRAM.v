
module SDRAM( //clk 100m 

	CLK,
	RST_N,
	CKE,
	
	CS_N,
	RAS_N,
	CAS_N,
	WE_N,
	
	BA,
	A,
	DQM,
	DQ

);

	input CLK;
	
	input RST_N;
	
	output reg CKE;
	
	output reg CS_N;
	output reg RAS_N;
	output reg CAS_N;
	output reg WE_N;
	
	output [1:0]BA;
	inout [12:0]A;
	input [1:0]DQM;
	inout [15:0]DQ;
	


endmodule