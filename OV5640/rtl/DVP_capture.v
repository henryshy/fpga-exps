module DVP_capture(
	
	pclk,
	rst_n,
	vsync,
	href,
	data,
	datapixel,
	datavalid,
	imagestate,
	xaddr,
	yaddr

);
	
	input pclk;
	input rst_n;
	input vsync;
	input href;
	input [7:0]data;
	
	output [15:0]datapixel;
	output datavalid;
	output reg imagestate;
	output [11:0]xaddr;
	output [11:0]yaddr;


	reg [3:0] frame_cnt;
	reg [11:0] row_cnt;
	reg [12:0]pixel_cnt;
	
	reg r_vsync;
	reg r_href;
	reg [7:0]r_data;
	reg [15:0] r_datapixel;
	
	always@(posedge pclk) begin
		r_vsync <= vsync;
		r_href <= href;
		r_data <= data;
	end
	
	always@(posedge pclk or negedge rst_n)
		if(!rst_n)
			imagestate <= 1;
		else if(r_vsync)
			imagestate <= 0;
	
	
	always@(posedge pclk or negedge rst_n)
		if(!rst_n)
			frame_cnt <= 0;
		else if({vsync,r_vsync} == 2'b10)begin
			if(frame_cnt >= 10)
				frame_cnt <= 10;
			else
				frame_cnt <= frame_cnt + 1;
		end
		else
			frame_cnt <= frame_cnt;
			
	always@(posedge pclk or negedge rst_n)
		if(!rst_n)
			row_cnt <= row_cnt;
		else if({href,r_href} == 2'b10)	
			row_cnt <= row_cnt + 1;
		else if(r_vsync)
			row_cnt <= 0;
		else
			row_cnt <= row_cnt;
	
	always@(posedge pclk or negedge rst_n)
		if(!rst_n)
			r_datapixel <= 0;
		else if(!pixel_cnt[0])
			r_datapixel[15:8] <= r_data;
		else
			r_datapixel[7:0] <= r_data;
	

	always@(posedge pclk or negedge rst_n)
		if(!rst_n)
			pixel_cnt <= 0;
		else if(r_href)
			pixel_cnt <= pixel_cnt + 1;
		else 
			pixel_cnt <= 0;
	reg r_datavalid;
	always@(posedge pclk or negedge rst_n)	
		
		if(!rst_n)
			r_datavalid <= 0;
		else if(r_href && pixel_cnt[0])
			r_datavalid <= 1;
		else
			r_datavalid <= 0;
	reg dump_frame;
	
	always@(posedge pclk or negedge rst_n)
		if(!rst_n)	
			dump_frame <= 0;
		else if(frame_cnt >= 10)
			dump_frame <= 1;
		else
			dump_frame <= 0;
			
	
	assign yaddr = row_cnt;		
	assign xaddr = pixel_cnt[12:1];
	
	assign datapixel = r_datapixel;
	assign datavalid = r_datavalid && dump_frame;
	



endmodule