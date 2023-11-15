module display_top(

	clk,
	rst_n,
	ds,
	shcp,
	stcp
);
	input clk;
	input rst_n;
	
	wire [7:0]sel;
	wire [6:0]led;
	
	wire [31:0] nums;
	output ds;
	output shcp;
	output stcp;
	
	wire [14:0]data;
	assign data = {led,sel};
	
	digital_display digital_display(

		.clk(clk),
		.rst_n(rst_n),
		.nums(nums),
		.en(1),
		.sel(sel),
		.led(led)

	);
	
	HC595_driver HC595_driver(
		.clk(clk),
		.rst_n(rst_n),
		.data(data),
		.en(1),
		.ds(ds),
		.stcp(stcp),
		.shcp(shcp)
	);
	
	digital_display_issp digital_display_issp (
		.source(nums)  
	);
	

endmodule