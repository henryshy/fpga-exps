module uart_top(

	clk,
	rst_n,
	uart_tx,
	uart_rx

);
	input clk;
	input rst_n;
	
	output uart_tx;
	input uart_rx;
	
	wire send_en;
	wire [7:0] data;
	
	
	uart_sender uart_sender(
		.Clk(clk),       
		.Rst_n(rst_n),     
		.data_byte(data), 
		.send_en(send_en),  
		.baud_set(1), 
		
		.Rs232_Tx(uart_tx), 
		.Tx_Done(),   
		.uart_state()
	);
	
	
	uart_receiver uart_receiver(
		.Clk(clk),       
		.Rst_n(rst_n),      
		.baud_set(1),  
		.Rs232_Rx(uart_rx),   
		
		.data_byte(data),  
		.Rx_Done(send_en)    
	);
endmodule



