
`timescale 1ns/1ps

module SDRAM_init_tb;
`include "../rtl/params.h"
	reg CLK;
	reg RST_N;
	
	wire CS_N;
	wire RAS_N;
	wire CAS_N;
	wire WE_N;
	wire [`ASIZE-1:0]saddr;
	wire init_done;
	wire [3:0] command;
	wire sd_clk;
	
	assign sd_clk = ~CLK;
	assign {CS_N,RAS_N,CAS_N,WE_N} = command;
	
	SDRAM_init SDRAM_init( //clk 100m 
	
		.CLK(CLK),
		.RST_N(RST_N),
		.command(command),
		.saddr(saddr),
		.init_done(init_done)
	);

	sdr sdr (
		.Dq(), 
		.Addr(saddr),
		.Ba(), 
		.Clk(sd_clk), 
		.Cke(RST_N), 
		.Cs_n(CS_N), 
		.Ras_n(RAS_N), 
		.Cas_n(CAS_N), 
		.We_n(WE_N), 
		.Dqm()
	);
	
	
	initial CLK = 1;
	always #5 CLK= ~CLK;
	
	
	initial begin
		RST_N = 0;
		#200
		RST_N = 1;

		@(posedge init_done)
		#2000;
		$stop;
	
	end









endmodule