module digital_display(

	clk,
	rst_n,
	nums,
	en,
	sel,
	led

);

	input [31:0] nums;
	input clk;
	input rst_n;
	input en;
	
	output  [7:0] sel;
	output reg [6:0]led;
	
	reg [7:0] sel_r;
	reg [15:0] cnt;
	
	reg [3:0]show_num;

	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt <= 0;
		else if(!en)
			cnt <= 0;
		else if(cnt == 49999)
			cnt <= 0;
		else
			cnt <= cnt + 1'b1;
			
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n) 
			sel_r <= 8'b00000001;
		else if(cnt == 49999) 
			if(sel_r == 8'b10000000)
				sel_r <= 8'b00000001;
			else 
				sel_r <= sel_r << 1;
		else
			sel_r <= sel_r;
		
	
	
	always@(*) 
		case(sel_r)   
			8'b00000001: show_num = nums[3:0]; 
			8'b00000010: show_num = nums[7:4]; 
			8'b00000100: show_num = nums[11:8]; 
			8'b00001000: show_num = nums[15:12];
			8'b00010000: show_num = nums[19:16];
			8'b00100000: show_num = nums[23:20];
			8'b01000000: show_num = nums[27:24];
			8'b10000000: show_num = nums[31:28];
			default: show_num = 0;
		endcase
		
	always@(*)
		case(show_num)
			4'h0 :led = 7'b1000000;
			4'h1 :led = 7'b1111001;
			4'h2 :led = 7'b0100100;
			4'h3 :led = 7'b0110000;
			4'h4 :led = 7'b0011001;
			4'h5 :led = 7'b0010010;
			4'h6 :led = 7'b0000010;
			4'h7 :led = 7'b1111000;
			4'h8 :led = 7'b0000000;
			4'h9 :led = 7'b0010000;
			4'ha :led = 7'b0001000;
			4'hb :led = 7'b0000011;
			4'hc :led = 7'b1000110;
			4'hd :led = 7'b0100001;
			4'he :led = 7'b0000110;
			4'hf :led = 7'b0001110;
		endcase
		
	assign sel = en?sel_r:8'b00000000;

endmodule