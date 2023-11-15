`timescale 1ns/1ns
module HC595_driver_tb();

	
	reg clk;
	reg rst_n;
	reg [15:0]data;
	reg en;
	wire ds;
	wire stcp;
	wire shcp;
	
	HC595_driver HC595_driver(
		.clk(clk),
		.rst_n(rst_n),
		.data(data),
		.en(1),
		.ds(ds),
		.stcp(stcp),
		.shcp(shcp)
	);

	initial clk = 1;
	always #10 clk = ~clk;
	
	
	initial begin
	
		data = 16'h 1234;
		rst_n = 0;
		en = 1;
		#200
		rst_n = 1;
		
		#2000000
		data = 16'h 8765;
		#2000000
		
		$stop;
		
	end

endmodule