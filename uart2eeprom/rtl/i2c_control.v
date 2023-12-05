
module i2c_control(
	clk,
	rst_n,
	rd,
	wr,
	wrdata_num,
	rddata_num,
	wraddr_num,
	device_addr,
	word_addr,
	wr_data,
	wr_data_valid,
	rd_data,
	rd_data_valid,
	done,
	SCL,
	SDA
);
	
	
	parameter sys_clock = 50_000_000;
	parameter i2c_clock = 400_000;
	
	
	localparam scl_cnt_max = sys_clock / i2c_clock;

	input clk;
	input rst_n;
	input rd;
	input wr;
	
	input [5:0]wrdata_num;
	input [5:0]rddata_num;
	input [1:0]wraddr_num;

	
	input [2:0]device_addr;
	input [15:0]word_addr;
	
	input [7:0]wr_data;
	output wr_data_valid;
	
	output reg[7:0] rd_data;
	output reg rd_data_valid;
	
	output reg done;
	output reg SCL;
	inout SDA;
	
	
	
	reg [15:0]scl_cnt;
	
	reg scl_valid;
	reg scl_high;
	reg scl_low;

	reg aoe;
	reg i2c_sda_od;
	assign SDA = aoe?i2c_sda_od:1'bz;
	

	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			scl_cnt <= 16'd0;
		else if(scl_valid) begin
			if(scl_cnt == scl_cnt_max - 1)
				scl_cnt <= 16'd0;
			else
				scl_cnt <= scl_cnt + 16'd1;
		end
		else
			scl_cnt <= 16'b0;

			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			scl_valid <= 0;
		else if (wr | rd)
			scl_valid <= 1;
		else if (done)
			scl_valid <= 0;
		else 
			scl_valid <= scl_valid;
	

	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			SCL <= 1;
		else if(scl_cnt == (scl_cnt_max>>1))
			SCL <= 0;
		else if(scl_cnt == 0)
			SCL <= 1;
		else
			SCL <= SCL;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) 
			scl_high <= 0;
		else if(scl_cnt == (scl_cnt_max>>2)) 
			scl_high <= 1;
		else
			scl_high <= 0;
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			scl_low <= 0;
		else if(scl_cnt == ((scl_cnt_max>>1) + (scl_cnt_max>>2)))
			scl_low <= 1;
		else
			scl_low <= 0;
			
	
	
	reg [8:0] state;
	
	localparam	
					idle				= 9'b000000001,
					write_begin		= 9'b000000010,
					write_control	= 9'b000000100,
					write_addr		= 9'b000001000,
					write_data		= 9'b000010000,
					read_begin		= 9'b000100000,
					read_control	= 9'b001000000,
					read_data		= 9'b010000000,
					opt_end			= 9'b100000000;
			   

	reg [4:0] half_bit;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			half_bit <= 5'd0;
		else if((state == write_control) ||
				  (state == write_addr) ||
				  (state == write_data) ||
				  (state == read_data) ||
				  (state == read_control)) begin		
			if(scl_high | scl_low) begin
				if(half_bit == 5'd17)
					half_bit <= 5'd0;
				else 
					half_bit <= half_bit + 5'd1;
			end
			else
				half_bit <= half_bit;
		end
		else
			half_bit <= 5'd0;
			
	reg ack;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			ack <= 0;
		else if((half_bit == 5'd16)&&scl_high&&(SDA == 0))
			ack <= 1;
		else if((half_bit == 5'd17) && scl_low)
			ack <= 0;
		else
			ack <= ack;
			
	
	always@(*) begin
		case(state)
			idle 	: 
				aoe <= 0;			
			write_begin, read_begin, opt_end :
				aoe <= 1;
	
			write_addr,write_control,read_control, write_data : begin
				if(half_bit < 16)
					aoe <= 1;
				else
					aoe <= 0;
			end
			read_data : begin
				if(half_bit < 16)
					aoe <= 0;
				else
					aoe <= 1;
			end		
			default:
				aoe <= 0;
		endcase			
	end


	
	reg w_flag;
	reg r_flag;

	reg [7:0] wdata_cnt;
	reg [7:0] rdata_cnt;
	reg [1:0] waddr_cnt;


	reg FF;
	
	reg [7:0]sda_data_out;
	reg [7:0]sda_data_in;
	
	wire [7:0]wr_ctrl_word;
	wire [7:0]rd_ctrl_word;
	
	assign wr_ctrl_word = {4'b1010, device_addr,1'b0};
	assign rd_ctrl_word = {4'b1010, device_addr,1'b1};
	
	
	task send8bit;
		if((scl_high) && (half_bit == 16))
			FF <= 1;
		else if (half_bit < 5'd17) begin
			i2c_sda_od <= sda_data_out[7];
			if(scl_low)
				sda_data_out <= {sda_data_out[6:0],1'b0};
			else
				sda_data_out <= sda_data_out;
		end
		else
			;
	endtask
	
	task receive8bit;
		if((scl_low) && (half_bit == 5'd15))
			FF <= 1;
		else if (half_bit < 5'd16) begin
			if(scl_high)
				sda_data_in <= {sda_data_in[6:0],SDA};
			else
				sda_data_in <= sda_data_in;
		end
		else
			;
	endtask
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			state <= idle;
			done <= 0;
			i2c_sda_od <= 1;
			w_flag <= 0;
			r_flag <= 0;
			wdata_cnt <= 8'd1;
			waddr_cnt <= 2'd1;
			rdata_cnt <= 8'd1;
		end
		else
			case(state)
					idle				: begin
						done <= 0;
						i2c_sda_od <= 1;
						w_flag <= 0;
						r_flag <= 0;
						wdata_cnt <= 8'd1;
						waddr_cnt <= 2'd1;
						rdata_cnt <= 8'd1;
						
						if(wr) begin
							w_flag <= 1;
							state <= write_begin;
						end
						else if(rd) begin
							r_flag <= 1;
							state <= write_begin;
						end
						else
							state <= idle;
					end
					
					write_begin		: begin
						if(scl_high) begin
							i2c_sda_od <= 0;
							state <= write_begin;
						end
						else if(scl_low) begin
							state <= write_control;
							FF <= 0;
							sda_data_out <= wr_ctrl_word;
						end
						else
							state <= write_begin;

					end
					write_control	: begin
						if(FF == 0)
							send8bit;
						else begin
							if(ack == 1)
								if(scl_low) begin
									
									state <= write_addr;
									FF <= 0;
									if(wraddr_num == 1)
										sda_data_out <= word_addr[7:0];
									else	
										sda_data_out <= word_addr[15:8];
								end
								else
									state <= write_control;
									
							else
								state <= idle;
						end
					end
					
					write_addr		: begin
						if( FF ==0)
							send8bit;
						else begin
							if(ack == 1)
								if(waddr_cnt == wraddr_num) begin
									if(scl_low && w_flag) begin
										state <= write_data;
										FF <= 0;
										sda_data_out <= wr_data;
										waddr_cnt <= 2'd1;
									end
									else if(scl_low && r_flag) begin
										state <= read_begin;
										i2c_sda_od <= 1;
									end
									else
										state <= write_addr;
								end
								else begin
									if(scl_low) begin
										waddr_cnt <= waddr_cnt + 2'd1;
										state <= write_addr;
										sda_data_out <= word_addr[7:0];
										FF <= 0;
									end
									else
										state <=write_addr;
								end
		
							else
								state <= idle;
						end			
						
					end
					
					
					write_data		: begin
						if( FF == 0)
							send8bit;
						else begin
							if(ack == 1)
								if(wrdata_num == wdata_cnt)
									if(scl_low) begin
										state  <= opt_end;
										i2c_sda_od <= 0;
										wdata_cnt <= 7'd1;
									end
									else
										state <= write_data;
								else begin
									if(scl_low) begin
										state <= write_data;
										FF <= 0;
										sda_data_out <= wr_data;
										wdata_cnt <= wdata_cnt + 7'd1;
									end
									else
										state <= write_data;
								end
									
							else
								state <= idle;			
									
						end
					end
					
					read_begin		: begin
						if(scl_low) begin
							state <= read_control;
							sda_data_out <= rd_ctrl_word;
							FF <= 0;
						end
						else if(scl_high) begin
							state <= read_begin;
							i2c_sda_od <= 0;
						end
						else
							state <= read_begin;
					end
					
					read_control	: begin
						if(FF == 0)
							send8bit;
						else begin
							if(ack == 1) begin
								if(scl_low) begin
									state <= read_data;
									FF <= 0;
								end
								else
									state <= read_control;
							end
							else
								state <= idle;
						end
					end
								
					read_data		: begin
					
					
						if(FF == 1'b0)
							receive8bit;
						else begin
							if(rdata_cnt == rddata_num)begin
								i2c_sda_od <= 1'b1;
								if(scl_low)begin
									state <= opt_end;
									i2c_sda_od  <= 1'b0;
								end
								else
									state <= read_data;
							end
							else begin
								i2c_sda_od <= 1'b0;
								if(scl_low)begin
									rdata_cnt  <= rdata_cnt + 8'd1;
									state <= read_data;
									FF         <= 1'b0;
								end
								else
									state <= read_data;
							end
						end
					end
					
					
					opt_end			: begin
						if(scl_high) begin
							i2c_sda_od <= 1;
							state <= idle;
							done <= 1;
							
						end
						else
							state <= opt_end;
						
						
					end
			
					default			: begin
						state <= idle;
					end
				endcase
				
	wire rd_data_valid_r;
	assign wr_data_valid = ((state==write_addr)&&
	                       (waddr_cnt==wraddr_num)&&
								  (w_flag && scl_low)&&
								  (ack == 1'b1))||
                     	  ((state == write_data)&&
								  (ack == 1'b1)&&(scl_low)&&
								  (wdata_cnt != wrdata_num));
	assign rd_data_valid_r = (state == read_data)
	                        &&(half_bit == 8'd15)&&scl_low;		

	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			rd_data_valid <= 1'b0;
		else if(rd_data_valid_r)
			rd_data_valid <= 1'b1;
		else
			rd_data_valid <= 1'b0;
	end

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			rd_data <= 8'd0;
		else if(rd_data_valid_r)
			rd_data <= sda_data_in;
		else
			rd_data <= rd_data;
	end
							
endmodule

