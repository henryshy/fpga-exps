`timescale 1ns/1ns
`define clockperiod 20


module beep_tb();

	reg clk;
	reg rst;
	reg [31:0] timetogo;
	reg  countAct;
	reg  countMode;
	
	wire [31:0] countVal;
	wire fullflag;


	beep beep01(
		.clk(clk),
		.rst(rst),
		
		.timetogo(timetogo),
		.countMode(countMode),
		.countAct(countAct),
		
		.countVal(countVal),
		.fullflag(fullflag)
	);
	
	
	initial clk = 1;
	always #(`clockperiod/2) clk=~clk;
	
	
	initial begin	
	
		rst = 0;
		countMode = 0;
		timetogo = 0;
		countAct = 0;
		
		#(`clockperiod * 200);
		rst = 1;
		
		//测试循环计时，计数1000次
		#(`clockperiod * 200);
		timetogo = 1000;
		countMode = 1;
		
		#(`clockperiod * 20)
		countAct = 1;
		
		#(`clockperiod * 12000);
		
		countAct = 0;
		
		#(`clockperiod * 200);
		
		//测试循环计时600次
		timetogo = 600;
		countMode = 1;
		#(`clockperiod * 20)
		countAct = 1;
		#(`clockperiod * 12000);
		countAct = 0;
		#(`clockperiod * 20);
		
		
		//测试单次循环1000次
		timetogo = 1000;
		countMode = 0;
		#(`clockperiod * 20)
		countAct = 1;
		#(`clockperiod );
		countAct = 0;
		
		#(`clockperiod * 1200);
		
		//测试单次循环6000次
		timetogo = 600;
		countMode = 0;
		#(`clockperiod * 20)
		countAct = 1;
		#(`clockperiod );
		countAct = 0;
		
		#(`clockperiod * 1200);
		
		$stop;
		
		
	end
	
	





endmodule