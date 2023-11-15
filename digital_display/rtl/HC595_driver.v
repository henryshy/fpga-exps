module HC595_driver(

	clk,
	rst_n,
	data,
	en,
	
	ds,
	stcp,
	shcp
);

	input clk;
	input rst_n;
	input [15:0]data;
	input en;
	
	output reg ds;
	output reg stcp;
	output reg shcp;
	
	reg [2:0]divider_cnt;
	
	wire sck_pulse;
	
	
	reg [4:0] shcp_edge_cnt ;//shcp EDGE counter
	
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			divider_cnt <= 0;
		else if (en)
			if(divider_cnt == 4)
				divider_cnt <= 0;
			else 
				divider_cnt <= divider_cnt + 1;
		else	
			divider_cnt <= divider_cnt;
			

	assign sck_pulse = (divider_cnt == 4);
	
	

	always@(posedge clk or negedge rst_n)
		if (!rst_n)
			shcp_edge_cnt <= 5'd0;
		else if (sck_pulse) 
			if (shcp_edge_cnt == 5'd31)
				shcp_edge_cnt <= 5'd0;
			else
				shcp_edge_cnt <= shcp_edge_cnt + 1'd1;
		else
			shcp_edge_cnt <= shcp_edge_cnt;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)begin 
			shcp <= 1'b0; 
			stcp <= 1'b0;
			ds <= 1'b0; 
		end 
		else begin 
			case(shcp_edge_cnt) 
				5'd 0 :begin shcp <= 1'b0; stcp <= 1'b1; ds <= data[15]; end 
				5'd 1 :begin shcp <= 1'b1; stcp <= 1'b0;end 
				5'd 2 :begin shcp <= 1'b0; ds <= data[14];end 
				5'd 3 :begin shcp <= 1'b1; end 
				5'd 4 :begin shcp <= 1'b0; ds <= data[13];end 
				5'd 5 :begin shcp <= 1'b1; end 
				5'd 6 :begin shcp <= 1'b0; ds <= data[12];end 
				5'd 7 :begin shcp <= 1'b1; end 
				5'd 8 :begin shcp <= 1'b0; ds <= data[11];end 
				5'd 9 :begin shcp <= 1'b1; end 
				5'd10 :begin shcp <= 1'b0; ds <= data[10];end 
				5'd11 :begin shcp <= 1'b1; end 
				5'd12 :begin shcp <= 1'b0; ds <= data[9];end 
				5'd13 :begin shcp <= 1'b1; end 
				5'd14 :begin shcp <= 1'b0; ds <= data[8];end 
				5'd15 :begin shcp <= 1'b1; end 
				5'd16 :begin shcp <= 1'b0; ds <= data[7];end 
				5'd17 :begin shcp <= 1'b1; end 
				5'd18 :begin shcp <= 1'b0; ds <= data[6];end
				5'd19 :begin shcp <= 1'b1; end 
				5'd20 :begin shcp <= 1'b0; ds <= data[5];end 
				5'd21 :begin shcp <= 1'b1; end 
				5'd22 :begin shcp <= 1'b0; ds <= data[4];end
				5'd23 :begin shcp <= 1'b1; end 
				5'd24 :begin shcp <= 1'b0; ds <= data[3];end 
				5'd25 :begin shcp <= 1'b1; end 
				5'd26 :begin shcp <= 1'b0; ds <= data[2];end 
				5'd27 :begin shcp <= 1'b1; end 
				5'd28 :begin shcp <= 1'b0; ds <= data[1];end
				5'd29 :begin shcp <= 1'b1; end 
				5'd30 :begin shcp <= 1'b0; ds <= data[0];end 
				5'd31 :begin shcp <= 1'b1; end 
			endcase
		end
endmodule