module OV5640(

	clk,
	rst_n,
	Camera_PCLK,
	Camera_Vsync,
	Camera_Href,
	Camera_Data,
	Camera_XCLK,

	Camera_Rst_n,
	Camera_PWDN,
	
	Camera_sclk,
	Camera_sdat,
	
	TFT_RGB,
	TFT_VS,
	TFT_HS,
	TFT_CLK,
	TFT_DE
	

);
	input clk;
	input rst_n;
	input Camera_PCLK;
	input Camera_Vsync;
	input Camera_Href;
	input [7:0]Camera_Data;
	
	output Camera_XCLK;
	output Camera_Rst_n;
	output Camera_PWDN;
	
	output Camera_sclk;
	inout Camera_sdat;
	
	output [15:0]TFT_RGB;
	output TFT_VS;
	output TFT_HS;
	output TFT_CLK;
	output TFT_DE;


	localparam RGB = 0;
	localparam JPEG = 1;
	parameter IMAGE_WIDTH   = 160;  //图片宽度
	parameter IMAGE_HEIGHT = 128;  //图片高度(≤720)
	parameter IMAGE_FLIP    = 0;    //0：不翻转，1：上下翻转
	parameter IMAGE_MIRROR = 1;    //0：不镜像，1：左右镜像


	wire Init_Done;
	wire [15:0]datapixel;
	wire datavalid;
	wire  imagestate;
	wire [15:0]q;
	reg [14:0]rdaddress;
	reg disp_valid;
	reg [14:0]wraddress;
	wire clk33m;
	wire [11:0]hcount;
	wire [11:0]vcount;
	wire [15:0]disp_data;
	
	assign disp_data = disp_valid?q:16'b0;
	wire data_req;
	
	pll pll (
		.inclk0(clk),
		.c0(clk33m),
		.c1(Camera_XCLK)
	);

	
	camera_init
	#(
		.IMAGE_TYPE(RGB), //括号里面填写RGB或者JPEG两种类型
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.IMAGE_HEIGHT(IMAGE_HEIGHT),
		.IMAGE_FLIP(IMAGE_FLIP),
		.IMAGE_MIRROR(IMAGE_MIRROR)
	)
	camera_init(
		.Clk(clk),
		.Rst_n(rst_n),
		.Init_Done(Init_Done),
		.camera_rst_n(Camera_Rst_n),
		.camera_pwdn(Camera_PWDN),
		.i2c_sclk(Camera_sclk),
		.i2c_sdat(Camera_sdat)
	);
	 
	 
	 

	DVP_capture DVP_capture(
		
		.pclk(Camera_PCLK),
		.rst_n(Init_Done),
		.vsync(Camera_Vsync),
		.href(Camera_Href),
		.data(Camera_Data),
		
		.datapixel(datapixel),
		.datavalid(datavalid),
		.imagestate(imagestate),
		.xaddr(),
		.yaddr()

	);
		TFT_CTRL TFT_CTRL(
		.clk33m(clk33m),
		.rst_n(rst_n),
		.data_in(disp_data),
		.data_req(data_req),
		.vcount(vcount),
		.hcount(hcount),
		.TFT_RGB(TFT_RGB),
		.TFT_VS(TFT_VS),
		.TFT_HS(TFT_HS),
		.TFT_CLK(TFT_CLK),
		.TFT_DE(TFT_DE)
	);
	
	dpram dpram (
		.data(datapixel),
		.rdaddress(rdaddress),
		.rdclock(clk33m),
		.rden(disp_valid),
		.wraddress(wraddress),
		.wrclock(Camera_PCLK),
		.wren(datavalid),
		.q(q)
	);
	

	always@(posedge Camera_PCLK or negedge rst_n)
		if(!rst_n)
			wraddress <= 0;
		else if(imagestate)
			wraddress <= 0;
		else if(datavalid) begin
			if(wraddress >= 20479)
				wraddress <= 0 ;
			else
				wraddress <= wraddress + 1;
			end


	
	
	always@(posedge clk33m or negedge rst_n)
		if(!rst_n)
			rdaddress <= 0;
		else if(imagestate)
			rdaddress <= 0;
		else if(disp_valid) begin
			if(rdaddress >= 20479)
				rdaddress <= 0 ;
			else
				rdaddress <= rdaddress + 1;
			end

			
			

	always@(posedge clk33m or negedge rst_n)
		if(!rst_n)
			disp_valid <= 0;
		else if((hcount <= 160) && (vcount < 128) && data_req)
			disp_valid <= 1;
		else
			disp_valid <= 0;
		



endmodule