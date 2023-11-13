module datasend_tb();


	
	reg clk;
	reg rst_n;
	reg [7:0] data;
	wire tx;
	
	datasend datasend(

		.clk(clk),
		.rst_n(rst_n),
		.tx(tx)
	);
	
	initial clk = 0;
	always #10 clk = ~clk;
	
	
	initial begin
		#200
		rst_n = 0;
		data = 8'b0;
		#201
		rst_n = 1;
		
		#200
		data = 8'b 10110101;
		
		#120000
		data = 8'b 11101110;
		
		
	end
endmodule