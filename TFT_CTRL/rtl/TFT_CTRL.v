module TFT_CTRL(
	clk33m,
	rst_n,
	data_in,
	
	vcount,
	hcount,
	TFT_RGB,
	TFT_VS,
	TFT_HS,
	TFT_CLK,
	TFT_DE,
	TFT_PWM

);

	input clk33m;
	input rst_n;
	input [15:0]data_in;
	
	output [10:0]vcount;
	output [10:0]hcount;
	output [15:0]TFT_RGB;
	output TFT_VS;
	output TFT_HS;
	output TFT_CLK;
	output TFT_DE;
	output TFT_PWM;
	
	reg [10:0] hcount_r;
	reg [10:0] vcount_r;
	
	wire hcount_of;
	wire vcount_of;
	assign hcount_of = (hcount_r == H_Total_Time - 1);
	assign vcount_of = (vcount_of == V_Total_Time - 1);
	
	parameter 
				H_Total_Time    = 1056,
				H_Right_Border  = 0,
				H_Front_Porch   = 0,
				H_Sync_Time     = 128,
				H_Back_Porch    = 88,
				H_Left_Border   = 0,
				
				
				V_Total_Time    = 525,
				V_Bottom_Border = 8,
				V_Front_Porch   = 2,
				V_Sync_Time     = 2,
				V_Back_Porch    = 25,
				V_Top_Border    = 8;
				 
	parameter 
				TFT_HS_end = H_Left_Border + H_Sync_Time - 1'd1,
				hdat_begin = H_Left_Border + H_Sync_Time + H_Back_Porch - 1'd1,
				
				hdat_end = H_Total_Time - H_Right_Border - H_Front_Porch - 1'd1,
				hpixel_end = H_Total_Time - H_Right_Border + 1'd1,
				
				TFT_VS_end = V_Top_Border + V_Sync_Time - 1'd1,
				vdat_begin = V_Top_Border + V_Sync_Time + V_Back_Porch - 1'd1,
				
				vdat_end = V_Total_Time - V_Bottom_Border - V_Front_Porch - 1'd1,
				vline_end = V_Total_Time - V_Bottom_Border -  1'd1;
				 
				 

	always@(posedge clk33m or negedge rst_n)
		if(!rst_n)
			hcount_r <= 0 ;
		else if(hcount_of)
			hcount_r <= 0;
		else	
			hcount_r <= hcount_r + 1;
			

	
	always@(posedge clk33m or negedge rst_n)
		if(!rst_n)
			vcount_r <= 0;
		else if(hcount_of)
			if(vcount_of)
				vcount_r <=0;
			else
				vcount_r <= vcount_r + 1;
		else
			vcount_r <= vcount_r;
			
	assign TFT_HS = (hcount_r > TFT_HS_end)?1'b1:1'b0;
	assign TFT_VS = (vcount_r > TFT_VS_end)?1'b1:1'b0;
	
	assign dat_act=((hcount_r >= hdat_begin)&&(hcount_r < hdat_end))&&((vcount_r >= vdat_begin)&&(vcount_r < vdat_end));
	assign TFT_RGB = (dat_act)?data_in:16'h0000;
	
	assign hcount = hcount_r - hdat_begin;
	assign vcount = vcount_r - vdat_begin;
	
	
	assign TFT_CLK = clk33m;
	assign TFT_DE = dat_act;
	assign TFT_PWM = rst_n;

endmodule