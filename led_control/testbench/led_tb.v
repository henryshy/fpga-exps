
`timescale 1ns/1ns
`define clock_period 20

module led_tb;
	
	reg clk;
	reg rst;
	wire light;
	
	
	led 
//	#(
//		.cnt_max(25'd24999999)
//	)
	ledtest(
		.clk50m(clk),
		.rst(rst),
		.light(light)
	);
	
	//clockgen
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	
	//rst signal
	initial begin 
		rst = 1'b0;//复位
		#(`clock_period*200);
		rst = 1'b1;
		#2000000000;
		$stop;
		
	end
		

endmodule