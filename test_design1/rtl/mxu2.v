module mxu2(
	a,
	b,
	sel,
	out
);

	input a,b,sel;
	output out;
	
	assign out=sel?b:a;
	
	
	


endmodule