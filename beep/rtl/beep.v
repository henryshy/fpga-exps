module beep(
	clk,
	rst,
	
	timetogo,
	countMode,
	countAct,
	
	countVal,
	fullflag
);
	input clk;
	input rst;
	
	input [31:0] timetogo;//定时值
	
	input  countAct;
	input  countMode;
	
	output [31:0] countVal;
	output fullflag;
	
	reg [31:0] counter;
	reg oneshot;
	
	assign fullflag = (counter == timetogo);
	assign countVal = counter;
	
	always@(posedge clk or negedge rst)  
		
		if(!rst) begin //复位信号使能
			counter <= 0;
		end
		else 
			if(countMode == 1 ) begin//循环计时模式
				if(countAct == 1 && !fullflag)
					counter <= counter + 1'b1;
				else 
					counter <= 1'b0;
			end
			else if(countMode == 0) begin //单次计时模式 
				if(oneshot == 1 && !fullflag)
					counter <= counter + 1'b1;
				else 
					counter <= 1'b0;	
			end

			
	
	always@(posedge clk or negedge rst) 
		if(!rst)
			oneshot <= 0;
		else if(countMode == 0) begin
			if(countAct == 1 && !fullflag)
				oneshot <= 1;
			else if(fullflag)
				oneshot <= 0;
		end
		else
			oneshot <= oneshot;
	

endmodule


