

`define clockperiod 20
`timescale 1ns/1ns

module mydcfifo_tb();

	reg	[15:0]  data;
	reg	  rdclk;
	reg	  rdreq;
	reg	  wrclk;
	reg	  wrreq;
	
	wire	[7:0]  q;
	wire	  rdempty;
	wire	[8:0]  rdusedw;
	wire	  wrfull;
	wire	[7:0]  wrusedw;
	
	mydcfifo mydcfifo (
		.data(data),
		.rdclk(rdclk),
		.rdreq(rdreq),
		.wrclk(wrclk),
		.wrreq(wrreq),
		.q(q),
		.rdempty(rdempty),
		.rdusedw(rdusedw),
		.wrfull(wrfull),
		.wrusedw(wrusedw)
	);

	initial rdclk = 1;
	initial wrclk = 1;
	
	
	always #(`clockperiod) wrclk = ~wrclk;
	always #(`clockperiod/2) rdclk = ~rdclk;
	
	integer i;
	
	initial begin
		wrreq = 0;
		rdreq = 0;

		data = 0;
		#401
		
		for(i=0;i<255;i=i+1) begin
			wrreq = 1;
			data = i+1024;
			#(`clockperiod*2);
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