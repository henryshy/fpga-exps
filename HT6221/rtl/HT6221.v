module HT6221(
	clk,
	rst_n,
	iIR,
	irdata,
	iraddr,
	get_flag
	

);

	input clk;
	input rst_n;
	input iIR;
	
	
	output [15:0]irdata ;
	output [15:0]iraddr ;
	output  get_flag;


	reg [18:0] cnt;
	reg cnt_en;
	reg t9ms;
	reg t4p5ms;
	reg t0p56ms;
	reg t1p69ms;
	reg timeout;
	
	reg [3:0] state;
	
	localparam 
		idle = 4'b0001,
		leader_1 = 4'b0010,
		leader_0 = 4'b0100,
		data_get = 4'b1000;
	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt <= 0;
		else if(cnt_en == 1'b1)
			cnt <= cnt + 1;
		else 
			cnt <= 0;
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			t9ms <= 0;
		else if(cnt >= 325000 && cnt <= 495000)
			t9ms <= 1;
		else
			t9ms <= 0;
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			t4p5ms <= 0;
		else if(cnt >= 152500 && cnt <= 277500)
			t4p5ms <= 1;
		else
			t4p5ms <= 0;
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			t0p56ms <= 0;
		else if(cnt >= 20000 && cnt <= 35000)
			t0p56ms <= 1;
		else
			t0p56ms <= 0;
		
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			t1p69ms <= 0;
		else if(cnt >= 75000 && cnt <= 90000)
			t1p69ms <= 1;
		else
			t1p69ms <= 0;	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			timeout <= 0;
		else if(cnt >= 500000)
			timeout <= 1;
		else
			timeout <= 0;	
	
	
			
	reg iIR_sync_0;
	reg iIR_sync_1;
	
	wire ir_neg;
	wire ir_pos;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			iIR_sync_0 <= 1;
			iIR_sync_1 <= 1;
		end
		else begin
			iIR_sync_0 <= iIR;
			iIR_sync_1 <= iIR_sync_0;
		end
		
	assign ir_neg = (!iIR_sync_0) & iIR_sync_1;
	assign ir_pos = iIR_sync_0 & (!iIR_sync_1);
	
	
	reg [31:0] data_tmp;
 
	reg [5:0]bit_cnt;
	reg get_data_done;
	
	assign get_flag = get_data_done;
	assign irdata  = data_tmp[31:16];
	assign iraddr = data_tmp[15:0];
	
	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			state <= idle;
			cnt_en <= 0;
			data_tmp <= 32'b0;
			bit_cnt <= 6'b0;
			get_data_done <= 0;
		end
		else
			case(state)
				idle	  :  begin 
				
								get_data_done <= 0;
								bit_cnt <= 0;
								if(ir_neg) begin
									data_tmp <= 0;
									cnt_en <= 1;
									state <= leader_1;
								end
								else begin
									cnt_en <= 0;
									state <= idle;
								end	
								
							  end
							  
				leader_1 : begin
								   if(ir_pos && t9ms) begin	
										state <= leader_0;
										cnt_en <= 0;
									end
									else if(ir_pos && (!t9ms))begin
										state <= idle;
										cnt_en <= 0;
									end
									else begin
										state <= state;
										cnt_en <= 1;	
									end
									
							  end
					
				leader_0 : 	begin
								  if(ir_neg && t4p5ms) begin	
										state <= data_get;
										cnt_en <= 0;
									end
									else if(ir_pos && (!t4p5ms))begin
										state <= idle;
										cnt_en <= 0;
									end
									else begin
										state <= state;
										cnt_en <= 1;	
									end					
								end	
								
								
				data_get :	begin
									cnt_en <= 1;
									if(ir_pos)
										if(t0p56ms) begin
											state <= data_get;
											cnt_en <= 0;
												if (bit_cnt == 32) begin
													get_data_done <= 1;
													state <= idle;
													cnt_en <= 0;
												end
										end
										else begin
											state <= idle;
											cnt_en <= 0;
										end
									else if(ir_neg)
										if(t0p56ms) begin
											state <= data_get;
											cnt_en <= 0;
											data_tmp[bit_cnt] <= 0;
											bit_cnt <= bit_cnt + 1;
										end
										else if(t1p69ms) begin
											state <= data_get;
											cnt_en <= 0;
											data_tmp[bit_cnt] <= 1;
											bit_cnt <= bit_cnt + 1;
										end
										else begin
											state <= idle;
											cnt_en <= 0;
										end

								end
												
				default: begin
								state <= state;
							end
				
			endcase

endmodule