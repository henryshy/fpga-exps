`timescale 1ns/1ns
module OV5640_tb();

	reg clk;
	reg rst_n;
	reg Camera_PCLK;
	reg Camera_Vsync;
	reg Camera_Href;
	reg [7:0]Camera_Data;
	
	wire Camera_XCLK;
	wire Camera_Rst_n;
	wire Camera_PWDN;
	
	wire Camera_sclk;
	wire Camera_sdat;
	
	wire [15:0]TFT_RGB;
	wire TFT_VS;
	wire TFT_HS;
	wire TFT_CLK;
	wire TFT_DE;

	
	OV5640 OV5640(

		.clk(clk),
		.rst_n(rst_n),
		.Camera_PCLK(Camera_PCLK),
		.Camera_Vsync(Camera_Vsync),
		.Camera_Href(Camera_Href),
		.Camera_Data(Camera_Data),
		.Camera_XCLK(Camera_XCLK),

		.Camera_Rst_n(Camera_Rst_n),
		.Camera_PWDN(Camera_PWDN),
		
		.Camera_sclk(Camera_sclk),
		.Camera_sdat(Camera_sdat),
		
		.TFT_RGB(TFT_RGB),
		.TFT_VS(TFT_VS),
		.TFT_HS(TFT_HS),
		.TFT_CLK(TFT_CLK),
		.TFT_DE(TFT_DE)
	);

	initial clk = 1;
	always #10 clk = ~clk;
	
	initial Camera_PCLK = 1;
	always #40 Camera_PCLK = ~Camera_PCLK;
	
	integer i,j;
	localparam height =128;
	localparam width = 160;
		initial begin
		rst_n = 0;
		Camera_Vsync = 0;
		Camera_Href = 0;
		Camera_Data = 0;
		#805;
		rst_n = 1;
		#400;
		repeat(150)begin
			Camera_Vsync = 1;
			#320;
			Camera_Vsync = 0;
			#800;
			for(i=0;i<height;i=i+1)begin
				for(j=0;j<width*2;j=j+1)begin
					Camera_Href = 1;
					Camera_Data = Camera_Data  + 1;
					#80;
				end
				Camera_Href = 0;
				#800;
			end
		end
		$stop;	
	end
	
endmodule