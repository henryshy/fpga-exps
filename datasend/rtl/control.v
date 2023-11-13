module control(
	
	clk,
	rst_n,
	tx_done,
	en,

);
	
	input clk;
	input rst_n;
	input tx_done;
	output reg en;

	
	
	reg [1:0] state;
	reg delay_done;
	reg cnt_en;
	reg [8:0] inner_counter;
	
	
	localparam s0 = 0;//开始发送
	localparam s1 = 1;//等待发送完成
	localparam s2 = 2;//等待延迟完成，开始新一轮发送
	
	
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			state <= s0;
			en <= 1;
			cnt_en <= 0;
		end
		else 
			case(state)
				s0:
					begin
						en = 1;
						state = s1;
					end
				s1:
					begin
						if(tx_done == 1) begin
							en = 0;
							cnt_en = 1;
							state = s2;
						end	
						else
							cnt_en = 0;
					end
				s2:
					begin
						if(delay_done) begin
							state = s0;
							cnt_en = 0;
						end
						else
							cnt_en = 1;
					end
				default: 
					begin		
						state <= s0;					
						en <= 1;
						cnt_en <= 0;
					end
			endcase
	end
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
		
			delay_done <= 1;
			inner_counter <= 0;
			
		end
		else if(cnt_en)
			if(inner_counter == 399) begin
				inner_counter <= 0;
				delay_done <= 1;
			end
			else begin 
				inner_counter <= inner_counter + 1'b1;
				delay_done <= 0;
			end
			
endmodule