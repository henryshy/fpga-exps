module soundgen(
	clk,
	rst,
	val
);



	input clk;
	input rst;
	output reg [31:0] val;
	
	reg [4:0] addr;
	initial addr = 5'b0;
	initial val = 0;

	always@(posedge clk or negedge rst) begin
		if(!rst)
			addr <= 5'b0;
		else if (addr > 5'd20)
			addr  <= 0;
		else
			addr <= addr + 1'b1;
	end
	
	always@(*) begin
		case(addr)
			0 : val = 191130 ;
			1 : val = 170241 ;
			2 : val = 151689 ;
			3 : val = 143183 ;
			4 : val = 127550 ;
			5 : val = 113635 ;
			6 : val = 101234 ;
			7 : val = 95546  ;
			8 : val = 85134  ;
			9 : val = 75837  ;
			10: val = 71581  ;
			11: val = 63775  ;
			12: val = 56817  ;
			13: val = 50617  ;
			14: val = 47823  ;
			15: val = 42563  ;
			16: val = 37921  ;
			17: val = 35793  ;
			18: val = 31887  ;
			19: val = 28408  ;
			20: val = 25309  ;
			default : val = 191130;
		endcase
	end
		
	
	
	
endmodule