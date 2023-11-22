module uart_dparm(
	
	key_in,
	rs232_rx,
	rs232_tx,
	clk,
	rst_n
);

	
	input clk;
	input rst_n;
	input key_in;
	input rs232_rx;
	
	output rs232_tx;


	wire key_flag;
	wire key_state;
	
	wire tx_done;
	wire rx_done;
	
	wire [7:0]rdaddress;
	wire [7:0]wraddress;
	wire wren;
	wire [7:0]tx_data;
	wire [7:0]rx_data;
	wire send_en;
	
	key_filter key_filter(
		.clk(clk),
		.rst_n(rst_n),
		.key_in(key_in),
		.key_flag(key_flag),
		.key_state(key_state)
	);
	
	control control(
		.clk(clk),
		.rst_n(rst_n),
		.key_flag(key_flag),
		.key_state(key_state),
		.tx_done(tx_done),
		.rx_done(rx_done),
		.rdaddress(rdaddress),
		.wraddress(wraddress),
		.wren(wren),
		.send_en(send_en)
	);

	
	dparm dparm (
		.clock(clk),
		.data(rx_data),
		.rdaddress(rdaddress),
		.wraddress(wraddress),
		.wren(wren),
		.q(tx_data)
	);
	
	uart_sender uart_sender(
		.Clk(clk),       //50M时钟输入
		.Rst_n(rst_n),     //模块复位
		.data_byte(tx_data), //待传输8bit数据
		.send_en(send_en),   //发送使能
		.baud_set(3'd0),  //波特率设置
		
		.Rs232_Tx(rs232_tx),  //Rs232输出信号
		.Tx_Done(tx_done),   //一次发送数据完成标志
		.uart_state() //发送数据状态
	);
	
	uart_receiver uart_receiver(
		.Clk(clk),        //模块时钟50M
		.Rst_n(rst_n),      //模块复位
		.baud_set(3'd0),   //波特率设置
		.Rs232_Rx(rs232_rx),   //RS232数据输入
		
		.data_byte(rx_data),  //并行数据输出
		.Rx_Done(rx_done)     //一次数据接收完成标志
	);
	

endmodule