module arp_send_rgmii(

	clk,
	phy_rst_n,
	rst_n,
	
	rgmii_tx_clk,
	rgmii_tx_data,
	rgmii_tx_ctl
);


	input clk;
	input rst_n;
	
	output rgmii_tx_clk;
	output [3:0]rgmii_tx_data;
	output rgmii_tx_ctl;

	output phy_rst_n;
	
	wire [7:0] gmii_tx_data;
	wire gmii_tx_clk;
	wire gmii_tx_en;
	wire gmii_tx_er;
	
	gmii_to_rgmii gmii_to_rgmii(
		.gmii_tx_data(gmii_tx_data),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_clk(gmii_tx_clk),
		
		.rgmii_tx_data(rgmii_tx_data),
		.rgmii_rx_ctl(rgmii_tx_ctl),
		.rgmii_tx_clk(rgmii_tx_clk)

	);
	
	eth_send_frame eth_send_frame(

		.gmii_tx_data(gmii_tx_data),
		.gmii_tx_clk(gmii_tx_clk),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_er(gmii_tx_er),
		.rst_n(rst_n),
		.phy_rst_n(phy_rst_n)
	);

	pll pll (
		.inclk0(clk),
		.c0(gmii_tx_clk)
	);
endmodule