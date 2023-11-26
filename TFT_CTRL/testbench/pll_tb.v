
`timescale 1ns/1ns
module pll_tb();

	reg clk;
	wire clk9m;
	reg areset ;
	
	pll pll1 (
		.areset(areset),
		.inclk0(clk),
		.c0(clk9m),
		.locked()
	);


	initial clk = 1;
	always #10 clk = ~clk;
	
	
	initial begin
		
		areset = 1;
		#200
		areset = 0;
		#20000;
		$stop;

	end

endmodule