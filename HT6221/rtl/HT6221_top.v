module HT6221_top(
	
	
	clk,
	rst_n,
	
	iIR,
	get_flag,
	data
);
	input clk;
	input rst_n;
	input iIR;
	
	output [31:0]data;
	output get_flag;

	HT6221 HT6221(
		.clk(clk),
		.rst_n(rst_n),
		.iIR(iIR),
		.irdata(data[31:16]),
		.iraddr(data[15:0]),
		.get_flag(get_flag)
	);
	
	issp issp (
		.probe(data)  // probes.probe
	);


endmodule