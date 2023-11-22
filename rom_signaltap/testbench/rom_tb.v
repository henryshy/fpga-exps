`timescale 1ns / 1ns
`define clockperiod 20

module rom_tb();

	reg clk;
	reg [7:0] address;
	wire [7:0] data;
	
	rom rom1 (
		.address(address),
		.clock(clk),
		.q(data)
	);
	
	initial clk = 1;
	always #(`clockperiod/2) clk = ~clk;
	
	integer i;
	
	initial begin
		address <= 0;

		#(`clockperiod)
		for(i=0;i<2560;i=i+1) begin
			address <= address + 1;
			#(`clockperiod);
		end
		#5000
		$stop;
	end
	
	
	
	
endmodule