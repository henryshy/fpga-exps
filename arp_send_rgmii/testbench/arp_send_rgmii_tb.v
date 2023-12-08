`timescale 1ns/1ns
module arp_send_rgmii_tb();

	
	reg clk;
	reg rst_n;
	
	wire phy_rst_n;
	wire rgmii_tx_clk;
	wire [3:0]rgmii_tx_data;
	wire rgmii_tx_ctl;

	arp_send_rgmii arp_send_rgmii(

		.clk(clk),
		.phy_rst_n(phy_rst_n),
		.rst_n(rst_n),
		
		.rgmii_tx_clk(rgmii_tx_clk),
		.rgmii_tx_data(rgmii_tx_data),
		.rgmii_tx_ctl(rgmii_tx_ctl)
	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	initial begin	
		rst_n = 0 ;
		# 201;
		rst_n = 1;
		#5000;
		$stop;
	end
	
endmodule