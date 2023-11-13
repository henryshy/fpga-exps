`timescale 1ns/1ns


module mxu2_tb();

	reg s1;
	reg s2;
	reg s3;
	wire light;
	
	
	mxu2 mxu2_test(
		.a(s1),
		.b(s2),
		.sel(s3),
		.out(light)
	);
	
	
	initial begin
		s1=0;s2=0;s3=0;
		
		#100;
		s1=1;s2=0;s3=0;
		
		#100;
		s1=0;s2=1;s3=0;
		
		#100;
		s1=1;s2=1;s3=0;
		
		#100;
		s1=0;s2=0;s3=1;
		
		#100;
		s1=1;s2=0;s3=1;
		
		#100;
		s1=0;s2=1;s3=1;
		
		#100;
		s1=1;s2=1;s3=1;
		
		#100;
		
		$stop;
		
	end


endmodule