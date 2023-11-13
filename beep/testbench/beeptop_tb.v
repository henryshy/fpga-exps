`timescale 1ns/1ns
`define clockperiod 20

module beeptop_tb();

	
	reg clk;
	reg rst;
	
	reg countAct;
	
	wire beep;
	
	
	beep_top beettest(
		.clk(clk),
		.rst(rst),
		
		.countAct(countAct),
		.beep1(beep)
	);
	
	
	
	initial clk = 1;
	always #(`clockperiod/2) clk=~clk;
	
	
	initial begin
		rst = 0;
		countAct = 1;
		
		#(`clockperiod *20)
		rst = 1;
		countAct = 0;
		
		#(1000000000)
		
		
		$stop;
		
		
		
		
		
	end
	
	
	

	
	
	



endmodule