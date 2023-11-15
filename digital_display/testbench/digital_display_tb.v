`timescale 1ns/1ns


module digital_display_tb();
	
	reg [31:0] nums;
	reg clk;
	reg rst_n;
	reg en;
	
	wire  [7:0] sel;
	wire  [6:0] led;
	
	digital_display digital_display(

		.clk(clk),
		.rst_n(rst_n),
		.nums(nums),
		.en(en),
		.sel(sel),
		.led(led)

	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	initial begin
		rst_n = 0;
		en = 1;
		nums=32'h12345678;
		#200
		rst_n = 1;
		#200
		#20000000
		nums=32'h87654321;
		#20000000
		nums=32'habcdffff;
		#20000000
		$stop;
		
	
	end
	




endmodule