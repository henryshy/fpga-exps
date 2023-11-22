module key_filter(

	clk,
	rst_n,
	key_in,
	key_flag,
	key_state
	
);

	input clk;
	input rst_n;
	input key_in;
	
	output reg key_flag;
	output reg key_state;
	
	reg key_sync;
	reg key_synced;
	
	reg key_tmp1;
	reg key_tmp2;
	
	reg [2:0] state;
	
	localparam up = 2'b00;
	localparam filter0 = 2'b01;
	localparam down = 2'b10;
	localparam filter1 = 2'b11;
	

	wire key_neg;
	wire key_pos;
	
	reg dly_done;
	reg cnt_en;
	reg [19:0] cnt;
	
	always@(posedge clk or negedge rst_n)//syncronize key_in to clk
		if(!rst_n) begin
			key_sync <= 0;
			key_synced <= 0;end
		
		else begin
			key_sync <= key_in;
			key_synced <= key_sync;end
		
		
	always@(posedge clk or negedge rst_n)	//key posedge & negedge generate
		if(!rst_n) begin
			key_tmp1 <= 0;
			key_tmp2 <= 0;end
		
		else begin
			key_tmp1 <= key_synced;
			key_tmp2 <= key_tmp1;end
		
		
	assign key_pos = !key_tmp1 && key_tmp2;
	assign key_neg = key_tmp1 && !key_tmp2;
	
	
	always@(posedge clk or negedge rst_n)	//delay counter
		if(!rst_n) begin
			dly_done <= 0;
			cnt <= 0;end
	
		
		else if(cnt_en)
			if(cnt == 1000000 - 1) begin
				dly_done <= 1;
				cnt <= 0 ;end
			
			else	begin
				dly_done <= 0;
				cnt <= cnt + 1'b1;end
			
		else	begin
			dly_done <= dly_done;
			cnt <= cnt;end
		
		
	
	always@(posedge clk or negedge rst_n) //state timing machine
		if(!rst_n) begin
			state <= up;
			key_flag <= 0;
			key_state <= 0;
			cnt_en <= 0;end
		else
			case(state)
				up     : begin 
								key_flag <= 0;
								
								if(key_neg) begin
									state <= filter0;
									cnt_en <= 1;end
								else
									key_state <= 1;
									
							end
							
				filter0: begin   
								if(dly_done) begin
									state <= down;
									cnt_en <= 0;
									key_flag <= 1;
									key_state <= 1;end
				
								else if(key_pos) begin
									state <= up;
									cnt_en <= 0; end
								
								else
									state <= filter0;
						
							end
				down   : begin    
								key_flag <= 0;
								if(key_pos) begin
									state <= filter1;
									cnt_en <= 1;end
								else
									key_state <= 0;
							end
							
				filter1: begin  
								if(dly_done) begin
									state <= up;
									cnt_en <= 0;
									key_flag <= 1;
									key_state <= 0;end
				
								else if(key_neg) begin
									state <= down;
									cnt_en <= 0; end
								
								else
									state <= filter1;
	
							end
			endcase
	
				
	
	
	






endmodule