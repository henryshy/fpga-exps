
`timescale 1ns/1ns

module key_filter_tb();



	reg clk;
	reg rst_n;
	reg key_in;
	
	wire key_flag;
	wire key_state;
	
	reg [15:0]myrand;
	
	key_filter key_filter(

		.clk(clk),
		.rst_n(rst_n),
		.key_in(key_in),
		.key_flag(key_flag),
		.key_state(key_state)
		
	);
	
	task press_key; 
		begin
			repeat(50) begin  
				myrand = {$random}%65536; 
				#myrand key_in = ~key_in;  
			end
		
			key_in = 0; 
			#50_000_000; //按下稳定 
			
			repeat(50) begin 
				myrand = {$random}%65536; 
				#myrand key_in = ~key_in;   
			end 
				key_in = 1; 
				#50_000_000;  
		end
	endtask
	
	initial clk = 1;
	always #10 clk = ~clk;
	initial begin
		rst_n = 0;
		key_in = 1'b1;
		#200
		rst_n = 1;
		
		#30000 
		press_key; #10000;
		press_key; #10000;
		press_key; #10000;
		
		$stop;
	end
endmodule