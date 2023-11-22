`define clk_period 20
`timescale 1ns/1ns

module uart_dparm_tb();
	
	reg clk;
	reg rst_n;
	
	wire key_in;
	
	wire rs232_rx;
	
	wire rs232_tx;
	
	reg [7:0] data;
	reg send_en;
	wire tx_done;
	
	reg press;
	
	uart_sender uart_sender1(
		.Clk(clk),       //50M时钟输入
		.Rst_n(rst_n),     //模块复位
		.data_byte(data), //待传输8bit数据
		.send_en(send_en),   //发送使能
		.baud_set(3'd0),  //波特率设置
		
		.Rs232_Tx(rs232_rx),  //Rs232输出信号
		.Tx_Done(tx_done),   //一次发送数据完成标志
		.uart_state() //发送数据状态
	);
	
	uart_dparm uart_dparm1(
		.key_in(key_in),
		.rs232_rx(rs232_rx),
		.rs232_tx(rs232_tx),
		.clk(clk),
		.rst_n(rst_n)
	);
	
	key_model key_model1(
		.press(press),
		.key(key_in)
	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	initial begin
	
		rst_n = 1'b0;
		press = 0;
		data = 8'd0;
		send_en = 1'd0;
		#(`clk_period*20 + 1 );
		rst_n = 1'b1;
		#(`clk_period*50);
		
		
		data = 8'haa;
		send_en = 1'd1;
		#`clk_period;
		send_en = 1'd0;		
		@(posedge tx_done)
		
		#(`clk_period*5000);
		
		data = 8'h55;
		send_en = 1'd1;
		#`clk_period;
		send_en = 1'd0;
		@(posedge tx_done)
		
		#(`clk_period*5000);
		
		data = 8'h33;
		send_en = 1'd1;
		#`clk_period;
		send_en = 1'd0;		
		@(posedge tx_done)
		
		#(`clk_period*5000);
		
		data = 8'haf;
		send_en = 1'd1;
		#`clk_period;
		send_en = 1'd0;
		@(posedge tx_done)
		
		#(`clk_period*5000);
		
		press = 1;
		#(`clk_period*30000000)
		press = 0;
		#(`clk_period*5000000);
			
		$stop;
	end


endmodule