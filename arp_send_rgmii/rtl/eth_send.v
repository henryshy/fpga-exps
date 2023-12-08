`timescale 1ns/1ns
module eth_send(

	rst_n,
	tx_en,
	
	target_mac_addr,
	src_mac_addr,
	
	frame_type,
	fsc,
	crc_en,
	
	fifo_data_length,
	fifo_rdreq,
	fifo_data,
	fifo_rdclk,
	
	gmii_tx_clk,
	gmii_tx_data,
	gmii_tx_en,
	gmii_tx_er
);
	

	input rst_n;
	input tx_en;
	input [47:0]target_mac_addr;
	input [47:0] src_mac_addr;
	input [15:0] frame_type;
	input [31:0] fsc ;
	output crc_en;
	
	input [15:0]fifo_data_length;
	output fifo_rdreq;
	input [7:0] fifo_data;
	output fifo_rdclk;
	
	input gmii_tx_clk;
	output reg [7:0] gmii_tx_data;
	output reg gmii_tx_en;
	output gmii_tx_er;
	
	reg [15:0]send_cnt;
	reg frame_tx_en;
	reg [15:0]fifo_data_num;
	wire data_tx_en;
	reg [47:0]r_tgt_mac_addr;
	reg [15:0]r_type_length;	
	

	assign fifo_rdreq = data_tx_en;
	assign fifo_rdclk = gmii_tx_clk;
	
	assign crc_en = ((send_cnt > 9) && (send_cnt <= 24));

	
	always@(posedge gmii_tx_clk)
		if(tx_en)
			r_tgt_mac_addr <= target_mac_addr;
		else
			r_tgt_mac_addr <= r_tgt_mac_addr;
			
	always@(posedge gmii_tx_clk)
		if(tx_en)
			r_type_length <= frame_type;
		else
			r_type_length <= r_type_length;
			
	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			frame_tx_en <= #1 1'b0;

		else if(tx_en)
			frame_tx_en <= #1 1'b1;
		else if(send_cnt >= 16'd27)
			frame_tx_en <= # 1'b0;
			

		
	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			send_cnt <= #1 16'd0;
		else if(frame_tx_en) begin
			if(!data_tx_en)
				send_cnt <= #1 send_cnt + 16'd1;
			else
				send_cnt <= #1 send_cnt;
		end
		else
			send_cnt <= #1 16'd0;
			
	assign data_tx_en = (send_cnt == 16'd23)&&(fifo_data_num > 1);

	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			fifo_data_num <= #1 16'd0;
		else if(tx_en)
			fifo_data_num <= fifo_data_length;
		else if(data_tx_en)
			fifo_data_num <= #1 fifo_data_num - 16'd1;
		else
			fifo_data_num <= #1 fifo_data_num;
	
			
	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			gmii_tx_data <= #1 8'b0;	
		else
			case(send_cnt)
				//前导码
				1,2,3,4,5,6,7 :
					gmii_tx_data <= #1 8'h55;
				//分隔符
				8 :
					gmii_tx_data <= #1 8'hd5;
				//目的mac
				9  : gmii_tx_data <= #1 r_tgt_mac_addr[47:40];
				10 : gmii_tx_data <= #1 r_tgt_mac_addr[39:32];
				11 : gmii_tx_data <= #1 r_tgt_mac_addr[31:24];
				12 : gmii_tx_data <= #1 r_tgt_mac_addr[23:16];
				13 : gmii_tx_data <= #1 r_tgt_mac_addr[15:8];
				14 : gmii_tx_data <= #1 r_tgt_mac_addr[7:0];
				//源mac
				15 : gmii_tx_data <= #1 src_mac_addr[47:40];
				16 : gmii_tx_data <= #1 src_mac_addr[39:32];
				17 : gmii_tx_data <= #1 src_mac_addr[31:24];
				18 : gmii_tx_data <= #1 src_mac_addr[23:16];
				19 : gmii_tx_data <= #1 src_mac_addr[15:8];
				20 : gmii_tx_data <= #1 src_mac_addr[7:0];
				//类型
				21 : gmii_tx_data <= #1 r_type_length[15:8];
				22 : gmii_tx_data <= #1 r_type_length[7:0];

				//fifodata
				23 : gmii_tx_data <= #1 fifo_data;
				//fsc
				24 : gmii_tx_data <= #1 fsc[31:24];
				25 : gmii_tx_data <= #1 fsc[23:16];
				26 : gmii_tx_data <= #1 fsc[15:8];
				27 : gmii_tx_data <= #1 fsc[7:0];
				
				28 : gmii_tx_data <= #1 8'd0;
				default : gmii_tx_data <= #1 8'b0;
				
			endcase
	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			gmii_tx_en <= #1 0;
		else if((send_cnt >= 16'd1) && (send_cnt <= 16'd27))
			gmii_tx_en <= #1 1;
		else
			gmii_tx_en <= #1 0;
	

	
	
endmodule