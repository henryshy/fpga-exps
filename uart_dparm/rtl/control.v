module control(
	clk,
	rst_n,
	key_flag,
	key_state,
	tx_done,
	rx_done,
	rdaddress,
	wraddress,
	wren,
	send_en
);
	input clk;
	input rst_n;
	
	input tx_done;
	input rx_done;
	input key_flag;
	input key_state;
	
	output reg [7:0] rdaddress;
	output reg [7:0] wraddress;
	output  wren;
	output reg send_en;
	
	reg send_en_reg1;
	reg send_en_reg2;
	
	
	reg do_send;
	
	assign wren = rx_done;
	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			wraddress <= 8'd0;
		else if(rx_done)
			wraddress <= wraddress + 1'b1;
		else
			wraddress <= wraddress;
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n) 
			do_send <= 1'd0;
		else if((key_flag == 1)&& (key_state == 0))
			do_send <= ~do_send;		
			
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			rdaddress <= 8'b0;
		else if(do_send && tx_done)
			rdaddress <= rdaddress + 8'd1;
		else
			rdaddress <= rdaddress;
			

	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			send_en_reg1 <= 1'b0;
			send_en_reg2 <= 1'b0;
		end
		else begin
			send_en_reg1 <= (do_send && tx_done);
			send_en_reg2 <= send_en_reg1;
		end
		
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			send_en <= 0;
		else if((key_flag == 1)&& (key_state == 0) )
			send_en <= 1;
		else if(send_en_reg2)
			send_en <= 1;
		else
			send_en <= 0;

		
				
endmodule