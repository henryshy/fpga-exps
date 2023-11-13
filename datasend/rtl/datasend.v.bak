module datasend(

	clk,
	rst_n,
	tx,
	data
);

	input clk;
	input rst_n;
	input [7:0] data;
	output tx;
	
	
	wire en;
	wire tx_done;
	
	control control(
		
		.clk(clk),
		.rst_n(rst_n),
		.tx_done(tx_done),
		.en(en)
	);

	sender sender(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.tx_done(tx_done),
		.data(data),
		.tx(tx)
	);
	

endmodule