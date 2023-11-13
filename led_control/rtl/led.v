module led(
	clk50m,
	rst,
	light
);
	input clk50m;
	input rst;
	
	output reg [3:0] light;
	
	reg [24:0] cnt;
	parameter cnt_max=25'd 24999999;
	
	always@(posedge clk50m or negedge rst)
	
	if(rst == 1'b0)
		cnt <= 25'd0;
	else if (cnt == cnt_max)
		cnt <= 25'd0;
	else
		cnt <= cnt+ 1'b1;
	
	
	always@(posedge clk50m or negedge rst)
	if(rst == 1'b0)
		light <= 4'b0111;
	else if (cnt == cnt_max)
		light <= {light[0],light[3:1]};
	else 
		light <= light;

endmodule
