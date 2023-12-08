`timescale 1ps/1ps
module ddi_x4 (
	datain,
	inclock,
	dataout_h,
	dataout_l);

	input	[3:0]  datain;
	input	  inclock;
	output	[3:0]  dataout_h;
	output	[3:0]  dataout_l;

	wire [3:0] sub_wire0;
	wire [3:0] sub_wire1;
	wire [3:0] dataout_h = sub_wire0[3:0];
	wire [3:0] dataout_l = sub_wire1[3:0];

	altddio_in	ALTDDIO_IN_component (
				.datain (datain),
				.inclock (inclock),
				.dataout_h (sub_wire0),
				.dataout_l (sub_wire1),
				.aclr (1'b0),
				.aset (1'b0),
				.inclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_IN_component.invert_input_clocks = "OFF",
		ALTDDIO_IN_component.lpm_hint = "UNUSED",
		ALTDDIO_IN_component.lpm_type = "altddio_in",
		ALTDDIO_IN_component.power_up_high = "OFF",
		ALTDDIO_IN_component.width = 4;

endmodule

module ddi_x1 (
	datain,
	inclock,
	dataout_h,
	dataout_l);

	input	[0:0]  datain;
	input	  inclock;
	output	[0:0]  dataout_h;
	output	[0:0]  dataout_l;

	wire [0:0] sub_wire0;
	wire [0:0] sub_wire1;
	wire [0:0] dataout_h = sub_wire0[0:0];
	wire [0:0] dataout_l = sub_wire1[0:0];

	altddio_in	ALTDDIO_IN_component (
				.datain (datain),
				.inclock (inclock),
				.dataout_h (sub_wire0),
				.dataout_l (sub_wire1),
				.aclr (1'b0),
				.aset (1'b0),
				.inclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_IN_component.invert_input_clocks = "OFF",
		ALTDDIO_IN_component.lpm_hint = "UNUSED",
		ALTDDIO_IN_component.lpm_type = "altddio_in",
		ALTDDIO_IN_component.power_up_high = "OFF",
		ALTDDIO_IN_component.width = 1;

endmodule


module rgmii_to_gmii(
	rgmii_rx_data,
	rgmii_rx_ctl,
	rgmii_rx_clk,
	
	gmii_rx_clk,
	gmii_rx_data,
	gmii_rx_dv

);

	input [3:0]rgmii_rx_data;
	input rgmii_rx_ctl;
	input rgmii_rx_clk;
	
	output [7:0]gmii_rx_data;
	output gmii_rx_clk;
	output gmii_rx_dv;
	

	assign gmii_rx_clk = rgmii_rx_clk;
	
	ddi_x4 ddi1 (
		.datain(rgmii_rx_data),
		.inclock(gmii_rx_clk),
		.dataout_h(gmii_rx_data[7:4]),
		.dataout_l(gmii_rx_data[3:0])
	);
	
	ddi_x1 ddi2 (
		.datain(rgmii_rx_ctl),
		.inclock(gmii_rx_clk),
		.dataout_h(),
		.dataout_l(gmii_rx_dv)
	);
endmodule