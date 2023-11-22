module rom_signaltap(

	
	clk,
	rst_n,
	q
);
	input clk;
	input rst_n;
	output [7:0] q;
	reg [7:0] address;
	
	rom rom2(
		.address(address),
		.clock(clk),
		.q(q)
	);
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			address <= 0;
		else
			address <= address + 1;
	
	
endmodule