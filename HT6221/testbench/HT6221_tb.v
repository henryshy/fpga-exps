
`timescale 1ns/1ns

`define clk_period 20


module HT6221_tb();


	reg clk;
	reg rst_n;
	reg iIR;
	
	
	wire [15:0]irdata ;
	wire [15:0]iraddr ;
	wire  get_flag;
	
	HT6221 HT6221(
		.clk(clk),
		.rst_n(rst_n),
		.iIR(iIR),
		.irdata(irdata),
		.iraddr(iraddr),
		.get_flag(get_flag)
	);
	
	
	integer i;
	initial clk = 1;
	always #(`clk_period/2) clk = ~clk;

	initial begin
		rst_n = 1'b0;
		iIR = 1'b1;
		#(`clk_period*10+1'b1);
		rst_n = 1'b1;
		#2000;
		iIR = 1'b1;
		send_data(1,8'h12);
		#60000000;
		send_data(3,8'heb);
		#60000000;
		$stop	;
	end


	
	task send_data;
		input [15:0]addr;
		input [7:0]data;
		begin
			iIR = 0;#9000000;
			iIR = 1;#4500000;
			for(i=0;i<=15;i=i+1)begin
				bit_send(addr[i]);		
			end
			for(i=0;i<=7;i=i+1)begin
				bit_send(data[i]);		
			end
			for(i=0;i<=7;i=i+1)begin
				bit_send(~data[i]);		
			end
			iIR = 0;#560000;
			iIR = 1;		
		end
	endtask
	
	task bit_send;
		input one_bit;
		begin
			iIR = 0; #560000;
			iIR = 1;
			if(one_bit)
				#1690000;
			else
				#560000;
		end	
	endtask



endmodule