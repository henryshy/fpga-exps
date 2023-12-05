`timescale 1ns/1ns
module DVP_capture_tb();


	reg pclk;
	reg rst_n;
	reg vsync;
	reg href;
	reg [7:0]data;
	
	wire [15:0]datapixel;
	wire datavalid;
	wire imagestate;
	wire [11:0]xaddr;
	wire [11:0]yaddr;


	DVP_capture DVP_capture(
		
		.pclk(pclk),
		.rst_n(rst_n),
		.vsync(vsync),
		.href(href),
		.data(data),
		.datapixel(datapixel),
		.datavalid(datavalid),
		.imagestate(imagestate),
		.xaddr(xaddr),
		.yaddr(yaddr)

	);
	
	
	parameter width = 8;
	parameter height = 12;
	
	initial pclk = 1;
	always #40 pclk = ~pclk;
	
	integer i,j;
	
	initial begin
		rst_n = 0;
		vsync = 0;
		href = 0;
		data = 0;
		#805;
		rst_n = 1;
		#400;
		
		repeat(15) begin
		
			vsync = 1;
			#320;
			vsync = 0;
			#800;
			for(i=0;i<height;i=i+1) begin
				for(j=0;j<width;j=j+1) begin
					href = 1;
					data = data + 1;
					#80;
				end
				href = 0;
				#800;
			end
		end
		$stop;
				
	
	end



endmodule