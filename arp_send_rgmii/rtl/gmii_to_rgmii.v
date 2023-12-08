`timescale 1ps/1ps
module ddo_x4 (
	datain_h,
	datain_l,
	outclock,
	dataout);

	input	[3:0]  datain_h;
	input	[3:0]  datain_l;
	input	  outclock;
	output	[3:0]  dataout;

	wire [3:0] sub_wire0;
	wire [3:0] dataout = sub_wire0[3:0];

	altddio_out	ALTDDIO_OUT_component (
				.datain_h (datain_h),
				.datain_l (datain_l),
				.outclock (outclock),
				.dataout (sub_wire0),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component.invert_output = "OFF",
		ALTDDIO_OUT_component.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component.lpm_type = "altddio_out",
		ALTDDIO_OUT_component.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component.power_up_high = "OFF",
		ALTDDIO_OUT_component.width = 4;

endmodule

module ddo_x1 (
	datain_h,
	datain_l,
	outclock,
	dataout);

	input	[0:0]  datain_h;
	input	[0:0]  datain_l;
	input	  outclock;
	output	[0:0]  dataout;

	wire [0:0] sub_wire0;
	wire [0:0] dataout = sub_wire0[0:0];

	altddio_out	ALTDDIO_OUT_component (
				.datain_h (datain_h),
				.datain_l (datain_l),
				.outclock (outclock),
				.dataout (sub_wire0),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component.invert_output = "OFF",
		ALTDDIO_OUT_component.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component.lpm_type = "altddio_out",
		ALTDDIO_OUT_component.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component.power_up_high = "OFF",
		ALTDDIO_OUT_component.width = 1;

endmodule

module gmii_to_rgmii(
	gmii_tx_data,
	gmii_tx_en,
	gmii_tx_clk,
	
	rgmii_tx_data,
	rgmii_rx_ctl,
	rgmii_tx_clk

);
	
	input [7:0]gmii_tx_data;
	input gmii_tx_en;
	input gmii_tx_clk;
	
	output [3:0]rgmii_tx_data;
	output rgmii_rx_ctl;
	output rgmii_tx_clk;
	
	
	ddo_x4 ddo1 (
		.datain_h(gmii_tx_data[3:0]),
		.datain_l(gmii_tx_data[7:4]),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_tx_data)
	);
	
	wire gmii_tx_err;
	assign gmii_tx_err = 1'b0;
	ddo_x1 ddo2 (
		.datain_h(gmii_tx_en),
		.datain_l(gmii_tx_en ^ gmii_tx_err),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_rx_ctl)
	);
	
	ddo_x1 ddo3 (
		.datain_h(1'b1),
		.datain_l(1'b0),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_tx_clk)
	);
	


endmodule