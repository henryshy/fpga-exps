module TFT_DISPLAY(
	
	clk,
	rst_n,
	
	TFT_RGB,
	
	TFT_VS,
	TFT_HS,
	TFT_CLK,
	TFT_DE,
	TFT_PWM

);

	input clk;
	input rst_n;
	
	output [15:0]TFT_RGB;
	output TFT_VS;
	output TFT_HS;
	output TFT_CLK;
	output TFT_DE;
	output TFT_PWM;
	
	localparam
		black  = 16'h0000,
		blue   = 16'h001F,
		red    = 16'hF800,
		purple = 16'hF81F,
		green  = 16'h07E0,
		cyan   = 16'h07FF,
		yellow = 16'hFFE0,
		white  = 16'hFFFF;
		
	localparam 
		R0_C0 = black, 
		R0_C1 = blue, 
		R1_C0 = red, 
		R1_C1 = purple,
		R2_C0 = green, 
		R2_C1 = cyan, 
		R3_C0 = yellow,		 
		R3_C1 = white;  
		
	wire [10:0]hcount;
	wire [10:0]vcount;
	
	wire clk33m;
	reg [15:0] disp_data;
	
	
	wire R0_act = vcount >= 0 && vcount < 200;	
	wire R1_act = vcount >= 201 && vcount < 400;
	wire R2_act = vcount >= 401 && vcount < 600;
	wire R3_act = vcount >= 601 && vcount < 800;
	
	wire C0_act = hcount >= 0 && hcount < 240; 
	wire C1_act = hcount >= 240 && hcount < 480; 
	
	wire R0_C0_act = R0_act & C0_act;	
	wire R0_C1_act = R0_act & C1_act;	
	wire R1_C0_act = R1_act & C0_act;
	wire R1_C1_act = R1_act & C1_act;
	wire R2_C0_act = R2_act & C0_act;
	wire R2_C1_act = R2_act & C1_act;	
	wire R3_C0_act = R3_act & C0_act;	
	wire R3_C1_act = R3_act & C1_act;	
	
	always@(*)
		case({R3_C1_act,R3_C0_act,R2_C1_act,R2_C0_act,
				R1_C1_act,R1_C0_act,R0_C1_act,R0_C0_act})
			8'b0000_0001:disp_data = R0_C0;
			8'b0000_0010:disp_data = R0_C1;
			8'b0000_0100:disp_data = R1_C0;
			8'b0000_1000:disp_data = R1_C1;
			8'b0001_0000:disp_data = R2_C0;
			8'b0010_0000:disp_data = R2_C1;
			8'b0100_0000:disp_data = R3_C0;
			8'b1000_0000:disp_data = R3_C1;
			default:disp_data = R0_C0;
		endcase
		
	pll pll (
		.areset(0),
		.inclk0(clk),
		.c0(clk33m),
		.locked()
	);
	

	TFT_CTRL TFT_CTRL(
		.clk33m(clk33m),
		.rst_n(rst_n),
		.data_in(disp_data),
		
		.vcount(hcount),
		.hcount(vcount),
		.TFT_RGB(TFT_RGB),
		.TFT_VS(TFT_VS),
		.TFT_HS(TFT_HS),
		.TFT_CLK(TFT_CLK),
		.TFT_DE(TFT_DE),
		.TFT_PWM(TFT_PWM)
	);
endmodule
