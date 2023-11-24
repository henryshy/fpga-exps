
`define clockperiod 20
`timescale 1ns/1ns

module fifo_tb();

	reg	  clock;
	reg	[7:0]  data;
	reg	  rdreq;
	reg	  sclr;
	reg	  wrreq;
	
	wire	  almost_empty;
	wire	  almost_full;
	wire	  empty;
	wire	  full;
	wire	[7:0]  q;
	wire	[7:0]  usedw;


	fifo fifo (
		.clock(clock),
		.data(data),
		.rdreq(rdreq),
		.sclr(sclr),
		.wrreq(wrreq),
		.almost_empty(almost_empty),
		.almost_full(almost_full),
		.empty(empty),
		.full(full),
		.q(q),
		.usedw(usedw)
	);

	initial clock = 1;
	always #(`clockperiod/2) clock = ~clock;
	
	integer i;
	initial begin
		wrreq = 0;
		rdreq = 0;
		sclr = 0;
		data = 0;
		#201
		for(i=0;i<255;i=i+1) begin
			wrreq = 1;
			data = i;
			#(`clockperiod);
		end
		
		wrreq = 0;
		#201
		for(i=0;i<255;i=i+1) begin
			rdreq = 1;
			#(`clockperiod);
		end
		
		rdreq = 0;
		
		#(`clockperiod*500);
		$stop;
		
	
	end



endmodule