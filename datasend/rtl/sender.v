module sender(
	clk,
	rst_n,
	en,
	tx_done,
	data,
	tx

);

	input clk;//50mhz
	input rst_n;
	
	input en;
	input [7:0] data;
	
	output reg tx_done;
	
	output reg tx;
	
	reg [8:0] cnt;
	
	initial cnt=0;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) 
			cnt <= 0;
		else if(en) 
			if(cnt == 399)
				cnt <= 0;
			else 
				cnt <= cnt + 1'b1;

		else
			cnt <= cnt;
		
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			tx <= 0;
		else begin
			case(cnt)
				0  : tx = data[0];
				49 : tx = data[1];
				99 : tx = data[2];
				149: tx = data[3];
				199: tx = data[4];
				249: tx = data[5];
				299: tx = data[6];
				349: tx = data[7];
				default: tx = tx;
			endcase
		end
		
		always@(posedge clk or negedge rst_n)
			if(!rst_n)
				tx_done <= 0;
			else if (cnt == 399)
				tx_done <= 1;
			else if (cnt == 0)
				tx_done <= 0;

					
endmodule