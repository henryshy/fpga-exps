// issp.v

// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module issp (
		input  wire [31:0] probe  // probes.probe
	);

	altsource_probe_top #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("NONE"),
		.probe_width             (32),
		.source_width            (0),
		.enable_metastability    ("NO")
	) in_system_sources_probes_0 (
		.probe (probe)  // probes.probe
	);

endmodule
