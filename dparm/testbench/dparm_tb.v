`timescale 1ns/1ns
module dparm_tb();
	
	reg clock;
	reg [7:0]data;
	reg [7:0]rdaddress;
	reg [7:0]wraddress;
	reg wren;
	wire [7:0] q;
	
	reg [4:0] i ;
	
	dparm dparm (
		.clock(clock),
		.data(data),
		.rdaddress(rdaddress),
		.wraddress(wraddress),
		.wren(wren),
		.q(q)
	);
	
	
	initial clock = 1;
	always #10 clock = ~clock;
	
	
	initial begin
	
		data = 0;
		rdaddress = 0;
		wraddress = 0;
		wren = 0;
		
		#201;
		
		
		for(i=0;i<=15;i=i+1) begin
			wren = 1;
			data = 255 - i;
			wraddress = i;
			#20;
		end
		
		wren = 0;
		#200;
		
		for(i=0;i<=15;i=i+1) begin
			rdaddress = i;
			#20;
		end
		#200;
		
		$stop;
	end
	
endmodule