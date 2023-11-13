module sender_tb();


	reg clk;
	reg rst_n;
	reg en;
	reg [7:0] data;
	wire tx;
	wire tx_done;

	sender sender(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.tx_done(tx_done),
		.data(data),
		.tx(tx)
	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	initial begin
		rst_n = 0;
		data = 8'b0;
		en = 0;
		
		#200
		rst_n = 1;
		
		#200
		
		data = 8'b11010011;
		en = 1;
		@(posedge tx_done);
		en = 0;
		
		
		#50000
		
		data = 8'b00111010;
		en = 1;
		@(posedge tx_done);
		en = 0;
		
		#4000
		
		$stop;
		
	end
endmodule