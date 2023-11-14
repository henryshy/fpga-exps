module dac_driver(
	clk,
	rst_n,
	en,
	data,
	
	cs,
	sclk,
	din,
	cvt_done

);
	
	input clk;
	input rst_n;
	input en;
	input [15:0] data;
	
	output reg cs;
	output reg sclk;
	output reg din;
	output reg cvt_done;
	
	reg cnt;
	
	reg [5:0] lsm_cnt;
	reg cs_dly;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)	
			cnt <= 0;
		else if(cnt == 1)
			cnt <=0 ;
		else 
			cnt <= cnt +1;
			
	always@(posedge clk or negedge rst_n) 
		if(!rst_n)
			lsm_cnt <= 0;
		else if (lsm_cnt <= 5'd31)
			lsm_cnt <= 0;
		else	
			lsm_cnt = lsm_cnt + 1'd1;
			
	
	always@(posedge clk or negedge rst_n) //12.5Mhz sclk
		
		if(!rst_n) begin
			cvt_done <= 0;
			din <= 0;
		end
		else begin
			case(lsm_cnt)
				0:begin sclk <= 1;din <= data[15];cs <= 0 ;end
				1:sclk <= 0;
				2:begin sclk <= 1;din <= data[14]; end
				3:sclk <= 0;
				4:begin sclk <= 1;din <= data[13]; end
				5:sclk <= 0;
				6:begin sclk <= 1;din <= data[12]; end
				7:sclk <= 0;
				8:begin sclk <= 1;din <= data[11]; end
				9:sclk <= 0;
				10:begin sclk <= 1;din <= data[10]; end
				11:sclk <= 0;
				12:begin sclk <= 1;din <= data[9]; end
				13:sclk <= 0;
				14:begin sclk <= 1;din <= data[8]; end
				15:sclk <= 0;
				16:begin sclk <= 1;din <= data[7]; end
				17:sclk <= 0;
				18:begin sclk <= 1;din <= data[6]; end
				19:sclk <= 0;
				20:begin sclk <= 1;din <= data[5]; end
				21:sclk <= 0;
				22:begin sclk <= 1;din <= data[4]; end
				23:sclk <= 0;
				24:begin sclk <= 1;din <= data[3]; end
				25:sclk <= 0;
				26:begin sclk <= 1;din <= data[2]; end
				27:sclk <= 0;
				28:begin sclk <= 1;din <= data[1]; end
				29:sclk <= 0;
				30:begin sclk <= 1;din <= data[0]; end
				31:begin sclk <= 0; end
				32:begin cs <= 1;cvt_done <= 1;end
				default:begin sclk <= sclk; cs <= cs; cvt_done <= cvt_done; din <= din; end
			endcase
		end
	
			

endmodule
