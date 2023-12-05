`timescale 1ns/1ns

module i2c_control_tb();

	reg clk;
	reg rst_n;


	reg rd;
	reg wr;
	
	reg [5:0]wrdata_num;
	reg [5:0]rddata_num;
	reg [1:0]wraddr_num;
	
	reg [2:0]device_addr;
	reg [15:0]word_addr;
	reg [7:0]wr_data;
	
	wire wr_data_valid;
	wire [7:0] rd_data;
	wire  rd_data_valid;
	wire  done;
	
	
	wire SCL;
	wire SDA;
	
	i2c_control i2c_control(
		.clk(clk),
		.rst_n(rst_n),
		.rd(rd),
		.wr(wr),
		.wrdata_num(wrdata_num),
		.rddata_num(rddata_num),
		.wraddr_num(wraddr_num),
		.device_addr(device_addr),
		.word_addr(word_addr),
		.wr_data(wr_data),
		.wr_data_valid(wr_data_valid),
		.rd_data(rd_data),
		.rd_data_valid(rd_data_valid),
		.done(done),
		.SCL(SCL),
		.SDA(SDA)
	);

	M24LC04B M24LC04B (
		.A0(1'b0),
		.A1(1'b0), 
		.A2(1'b0), 
		.WP(1'b0), 
		.SDA(SDA), 
		.SCL(SCL), 
		.RESET(!rst_n)
	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	integer i;
	
	initial begin
		rst_n = 0;
		rd = 0;
		wr = 0;

		wrdata_num = 4;
		rddata_num = 4;
		wraddr_num = 1;
		device_addr = 3'b0;
		word_addr = 0;
		wr_data = 0;
		#4001

		rst_n = 1;

		#200
		
		word_addr = 0;
		wr_data = 100;
		repeat(20)begin
			wr      = 1'b1;
			#20
			wr      = 1'b0;

			repeat(4)begin 
				@(posedge wr_data_valid)
				wr_data = wr_data + 1;
			end

			@(posedge done);
			#2000;
			word_addr = word_addr + 4;
		end
		
		#2000;
		
		word_addr = 0;

		repeat(20)begin
			rd     = 1'b1;
			#20
			rd     = 1'b0;
			
			@(posedge done);
			#2000;
			word_addr = word_addr + 4;
		end
		#5000;
		$stop;
	end
	

endmodule