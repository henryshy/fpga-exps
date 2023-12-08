`timescale 1ns/1ns
module eth_send_frame(

	gmii_tx_data,
	gmii_tx_clk,
	gmii_tx_en,
	gmii_tx_er,
	
	rst_n,
	phy_rst_n
);

	input rst_n;
	
	output phy_rst_n;
	
	input gmii_tx_clk;
	output [7:0]gmii_tx_data;
	output gmii_tx_en;
	output gmii_tx_er;
	
	parameter [47:0]target_mac_addr = 48'hFFFFFFFFFFFF;
	parameter [47:0] src_mac_addr = 48'h0007EDAC6200;
   parameter [15:0] frame_type = 16'h0806;
	parameter [15:0] hardware_type = 16'h0001;
	parameter [15:0] protocol_type= 16'h0800;
	parameter [7:0] hardware_addr_length = 8'h06;
	parameter [7:0] protocol_addr_length = 8'h04;
	parameter [15:0] option = 16'h0001;
	parameter [31:0] src_ip = 32'hC0A80002;
	parameter [31:0] target_ip = 32'hC0A80003;
	
	parameter [31:0]crc = 32'hBE7C1CBB;
	wire [31:0] fsc ;
	assign fsc = {crc[7:0],crc[15:8],crc[23:16],crc[31:24]};

	assign phy_rst_n =1 ;
	wire fifo_rdreq;
	reg [7:0]fifo_data;
	wire fifo_rdclk;
	reg [23:0]cnt;
	wire tx_en;
	reg [11:0]data_cnt;	
	
	eth_send eth_send(
		.rst_n(rst_n),
		.tx_en(tx_en),
		.target_mac_addr(48'hff_ff_ff_ff_ff_ff),
		.src_mac_addr(48'h00_07_ed_ac_62_00),		
		.frame_type(16'h08_06),
		.fsc(fsc),		
		.fifo_data_length(16'd46),
		.fifo_rdreq(fifo_rdreq),
		.fifo_data(fifo_data),
		.fifo_rdclk(fifo_rdclk),		
		.gmii_tx_clk(gmii_tx_clk),
		.gmii_tx_data(gmii_tx_data),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_er(gmii_tx_er)
	);


	always@(posedge gmii_tx_clk or negedge rst_n)
		if(!rst_n)
			cnt <= #1 0;
		else 
			cnt <= #1 cnt + 1'b1;
		

	assign tx_en = (cnt == 24'd1);
	

	always@(posedge gmii_tx_clk or negedge rst_n)
	if(!rst_n)
		data_cnt <= #1 12'd0;
	else if(fifo_rdreq)
		data_cnt <= #1 data_cnt + 1'b1;
	else
		data_cnt <= #1 12'd0;
	
	always@(*)
	begin
		case(data_cnt)
			//硬件类型
//			0  : fifo_data <=  hardware_type[15:8];
//			1  : fifo_data <=  hardware_type[7:0];
//			//协议类型
//			2  : fifo_data <=  protocol_type[15:8];
//			3  : fifo_data <=  protocol_type[7:0];
//			//硬件地址长度
//			4  : fifo_data <=  hardware_addr_length;
//			//协议地址长度
//			5  : fifo_data <=  protocol_addr_length;
//			//操作
//			6  : fifo_data <=  option[15:8];
//			7  : fifo_data <=  option[7:0];
//			//源mac
//			8  : fifo_data <=  src_mac_addr[47:40];
//			9  : fifo_data <=  src_mac_addr[39:32];
//			10 : fifo_data <=  src_mac_addr[31:24];
//			11 : fifo_data <=  src_mac_addr[23:16];
//			12 : fifo_data <=  src_mac_addr[15:8];
//			13 : fifo_data <=  src_mac_addr[7:0];
//			//源ip
//			14 : fifo_data <=  src_ip[31:24];
//			15 : fifo_data <=  src_ip[23:16];
//			16 : fifo_data <=  src_ip[15:8];
//			17 : fifo_data <=  src_ip[7:0];
//			//目标mac
//			18,19,20,21,22,23	: fifo_data <=  8'b0;
//			
//			//目标ip
//			24 : fifo_data <=  target_ip[31:24];
//			25 : fifo_data <=  target_ip[23:16];
//			26 : fifo_data <=  target_ip[15:8];
//			27 : fifo_data <=  target_ip[7:0];
			00: fifo_data =	8'h00;
			01: fifo_data =	8'h01;
			
			//protocol type
			02: fifo_data =	8'h08;
			03: fifo_data =	8'h00;
			
			//hdwr size
			04: fifo_data =	8'h06;
			
			//protocol size
			05: fifo_data =	8'h04;
			
			//opcode
			06: fifo_data =	8'h00;
			07: fifo_data =	8'h01;
			
			//sender mac
			08: fifo_data =	8'h00;
			09: fifo_data =	8'h07;
			10: fifo_data =	8'hed;
			11: fifo_data =	8'hac;
			12: fifo_data =	8'h62;
			13: fifo_data =	8'h00;
			
			//sender ip : 192.168.0.2
			14: fifo_data =	8'hc0;//192
			15: fifo_data =	8'ha8;//168
			16: fifo_data =	8'h00;//0
			17: fifo_data =	8'h02;//2
			
			//target mac
			18: fifo_data =	8'h00;
			19: fifo_data =	8'h00;
			20: fifo_data =	8'h00;
			21: fifo_data =	8'h00;
			22: fifo_data =	8'h00;
			23: fifo_data =	8'h00;
			
			//target ip : 192.168.0.3
			24: fifo_data =	8'hc0;//192
			25: fifo_data =	8'ha8;//168
			26: fifo_data =	8'h00;//0
			27: fifo_data =	8'h03;//3
			
			28: fifo_data =	8'h00;
			29: fifo_data =	8'h00;
			30: fifo_data =	8'hff;
			31: fifo_data =	8'hff;
			32: fifo_data =	8'hff;
			33: fifo_data =	8'hff;
			34: fifo_data =	8'hff;
			35: fifo_data =	8'hff;
			36: fifo_data =	8'h00;
			37: fifo_data =	8'h23;
			38: fifo_data =	8'hcd;
			39: fifo_data =	8'h76;
			40: fifo_data =	8'h63;
			41: fifo_data =	8'h1a;
			42: fifo_data =	8'h08;
			43: fifo_data =	8'h06;
			44: fifo_data =	8'h00;
			45: fifo_data =	8'h01;
			
			default : fifo_data <= 8'b0;
		endcase
	end
endmodule