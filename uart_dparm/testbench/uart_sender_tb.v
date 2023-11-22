`define clk_period 20
`timescale 1ns/1ns

module uart_sender_tb();

	reg clk;//50mhz
	reg rst_n;
	reg [2:0] baud_set;
	reg send_en;
	reg [7:0] data;
	
	wire  tx_done;
	
	wire  tx;
	wire  uart_state;
	

	uart_sender uart_sender2(
		.Clk(clk),       //50M时钟输入
		.Rst_n(rst_n),     //模块复位
		.data_byte(data), //待传输8bit数据
		.send_en(send_en),   //发送使能
		.baud_set(baud_set),  //波特率设置
		
		.Rs232_Tx(tx),  //Rs232输出信号
		.Tx_Done(tx_done),   //一次发送数据完成标志
		.uart_state(uart_state) //发送数据状态
	);
	
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	
	initial begin
		
		rst_n = 0 ;
		send_en = 0;
		#200
		rst_n = 1;
		data=8'b10010001;
		baud_set = 2;
		#201
		
		send_en = 1;
		
		#2000000
		
		send_en = 0;
		#200000
		
		$stop;
		
		
		
		
		
		
	
	end


endmodule