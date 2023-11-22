module uart_sender_tb();

	reg clk;//50mhz
	reg rst_n;
	reg [2:0] baud_set;
	reg send_en;
	reg [7:0] data;
	
	wire  tx_done;
	
	wire  tx;
	wire  uart_state;
	
	uart_sender uart_sender(
		
		.clk(clk),
		.rst_n(rst_n),
		.baud_set(baud_set),
		.send_en(send_en),
		.tx_done(tx_done),
		.data(data),
		.tx(tx),
		.uart_state(uart_state)
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