// digital_display_issp.v

// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module digital_display_issp (
		output wire [31:0] source  // sources.source
	);

	altsource_probe_top #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("NONE"),
		.probe_width             (0),
		.source_width            (32),
		.source_initial_value    ("0"),
		.enable_metastability    ("NO")
	) in_system_sources_probes_0 (
		.source     (source), // sources.source
		.source_ena (1'b1)    // (terminated)
	);

endmodule