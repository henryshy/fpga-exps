`define beep_T 50000;

module beep_top(
	clk,
	rst,
	
	countAct,
	beep1
);
	input clk;
	input rst;
	input countAct;
	
	output beep1;
	
	wire fullflag1;
	wire fullflag2;
	wire rstbeep;
	reg rstsig;
	assign rstbeep = rstsig;
	
	reg beep_sig;

	reg soundclk;
	wire [31:0] countVal;
	
	initial beep_sig = 0;
	initial soundclk = 1;

	assign beep1 = beep_sig;
	
	soundgen sound01(//产生计数器值countVal
		.clk(soundclk),
		.rst(rst),
		.val(countVal)
   );
	
	
	beep beep01(//用fullflag1翻转beep信号发声
		.clk(clk),
		.rst(rstbeep),
		.timetogo(countVal/2),
		.countMode(1'b1),
		.countAct(1),
		.countVal(),
		.fullflag(fullflag1)
	);
	
	
	
	beep timer1(  //让频率定时换
		.clk(clk),
		.rst(rst),
		.timetogo(10000000),
		.countMode(1'b1),
		.countAct(1),
		.countVal(),
		.fullflag(fullflag2)
	);
	
	always@(posedge fullflag1)
		beep_sig <= ~beep_sig;

	
	always@(posedge fullflag2) begin
		soundclk <= ~soundclk;
	end

	always@(*)
		if(fullflag2)
			rstsig <= 0;
		else
			rstsig <= 1;
		

		
	
	
endmodule