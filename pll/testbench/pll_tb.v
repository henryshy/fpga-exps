`define clockperiod 20
`timescale 1ns/1ns

module pll_tb();

	reg	  areset;
	reg	  inclk0;
	wire	  c0;
	wire	  c1;
	wire	  c2;
	wire	 locked;
	
	pll pll (
		.areset(areset),
		.inclk0(inclk0),
		.c0(c0),
		.c1(c1),
		.c2(c2),
		.locked(locked)
	);

		
	initial inclk0 = 1;
	always #(`clockperiod/2) inclk0 <= ~inclk0;

	
	initial begin
		areset = 0;
		
		#201
		
		areset = 1;
		
		
		#20000
		
		areset = 0;
		
		
		#20000
		$stop;
	end
endmodule