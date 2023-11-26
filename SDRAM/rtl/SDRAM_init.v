
module SDRAM_init( //clk 100m 

	CLK,
	RST_N,
	command,
	saddr,
	init_done
);

`include "params.h"
	input CLK;
	
	input RST_N;
	
	output reg [3:0]command;
	output reg [`ASIZE-1:0]saddr;
	output  init_done;
	

	localparam 
		init_PRE_TIME  = INIT_PRE ,
		init_REF_TIME1 = INIT_PRE + tRP ,
		init_REF_TIME2 = INIT_PRE + tRP + tRFC,
		init_LMR_TIME  = INIT_PRE + tRP + tRFC + tRFC ,
		init_END_TIME  = INIT_PRE + tRP + tRFC + tRFC +tMRD ;
		
		
	reg [14:0]init_CNT;
	assign init_done = (init_CNT == init_END_TIME);
//	always@(posedge CLK or negedge RST_N)
//		if(!RST_N)	

	always@(posedge CLK or negedge RST_N)
		if(!RST_N)
			init_CNT <= 0;
		else if(init_CNT < init_END_TIME)
			init_CNT <= init_CNT + 1;
		else 
			init_CNT <= 0;
	
	
	always@(posedge CLK or negedge RST_N)
		if(!RST_N) begin
			command <= C_NOP;
			saddr <= 0;
		end
		else
			case(init_CNT)
				0              : command <= C_NOP;
									
				init_PRE_TIME  : begin 
					command <= C_PRE;
					saddr[10] <= 1; 
				end
				init_REF_TIME1 : begin
					command <= C_AREF;
				end	
				init_REF_TIME2 : begin
					command <= C_AREF;
				end
					
				init_LMR_TIME  : begin
					command <= C_MSET;
					saddr   <= {2'b00,OP_CODE,2'b00,SDR_CL,SDR_BT,SDR_BL};
				end
				default: begin
					command <= C_NOP;
					saddr <= 0;
				end 
			endcase

endmodule