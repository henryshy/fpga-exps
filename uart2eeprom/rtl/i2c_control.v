
module i2c_control(
	clk,
	rst_n,

	SCL,
	SDA

);
	
	
	parameter sys_clock = 50_000_000;
	parameter i2c_clock = 400_000;
	
	
	localparam scl_cnt_max = sys_clock / i2c_clock;
	localparam sda_cnt_max = 8*scl_cnt_max;
	input clk;
	input rst_n;
	

	output SCL;
	inout SDA;
	
	
	
	reg [15:0]scl_cnt;
	
	reg scl_clock;
	reg scl_valid;
	reg scl_high;
	reg scl_low;
	
	reg done;
	reg rd;
	reg wr;
	
	 
	reg aoe;
	
	reg i2c_sda_od;
	wire i2c_sda_id;
	
	assign SDA = (aoe && !i2c_sda_od)?1'b0:1'bz;
	
	assign i2c_sda_id = SDA;
	

	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			scl_cnt <= 0;
		else if(scl_cnt == scl_cnt_max)
			scl_cnt <= 0;
		else
			scl_cnt <= scl_cnt + 1;
			
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
			scl_clock <= 1;
		else if(scl_cnt == (scl_cnt_max>>1))
			scl_clock <= 0;
		else if(scl_cnt == 0)
			scl_clock <= 1;
		else
			scl_clock <= scl_clock;
	
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
			   
			
	
	localparam control_code = 4'b1010;
	localparam chip_select_bit = 3'b110;
	localparam slave_addr = {control_code,chip_select_bit};
	
	
	reg [7:0] word_addr;
	reg [7:0] control_byte;
	reg [7:0] data;
	reg sda_r;
	reg [3:0] bit_cnt;
	task send8bit;
	
		input [7:0]data;
		input scl_low;
		input scl_high;
		input next_state;
		output i2c_sda_od;
		output state;
		output [3:0] bit_cnt;
		
		if(scl_low && bit_cnt != 8) begin
			case(bit_cnt) 
				0: i2c_sda_od <= data[7];
				1: i2c_sda_od <= data[6];
				2: i2c_sda_od <= data[5];
				3: i2c_sda_od <= data[4];
				4: i2c_sda_od <= data[3];
				5: i2c_sda_od <= data[2];
				6: i2c_sda_od <= data[1];
				7: i2c_sda_od <= data[0];
				default:;
			endcase
			bit_cnt <= bit_cnt + 1;
		end
		else if(scl_low && bit_cnt == 8)
			aoe <= 0;
		else if(scl_high && bit_cnt == 8) begin
			if(i2c_sda_id == 0) begin
				state <= next_state;
				aoe <= 1;
			end
			else begin
				state <= idle;
				aoe <= 0;
			end
		end
		else begin
			aoe <= aoe;
			state <= next_state;
			bit_cnt <= bit_cnt;
		end
	endtask
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			aoe <= 0;
			state <= idle;
			i2c_sda_od <= 1;
			bit_cnt <= 0;

		end
		else
			case(state)
					idle				: begin
						aoe <= 0;
						if(wr|rd) begin
							state <= write_begin;
							control_byte <= {slave_addr,1'b0};
						end
						else begin
							state <= state;
							control_byte <= control_byte;	
						end
					end
					write_begin		: begin
						if(scl_high) begin
							aoe <= 1;
							sda_r <= 0;
							state <= write_control;
						end
						else
							state <= state;
					end
					write_control	: begin
						send8bit(control_byte,scl_low,scl_high,write_addr,i2c_sda_od,state,bit_cnt);
					end
					
					write_addr		: begin
						if(wr)
							send8bit(word_addr,scl_low,scl_high,write_data,i2c_sda_od,state,bit_cnt);
						else if(rd)
							send8bit(word_addr,scl_low,scl_high,read_control,i2c_sda_od,state,bit_cnt);
						else
							state <= idle;

					end
					
					
					write_data		: begin
						send8bit(word_addr,scl_low,scl_high,idle,i2c_sda_od,state,bit_cnt);

					end
					read_begin		: begin
					end
					read_control	: begin
					end
					read_data		: begin
					end
					opt_end			: begin
					end
					
					
					
					default			: begin
					end
				endcase
	
	
endmodule

