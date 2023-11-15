	component digital_display_issp is
		port (
			source : out std_logic_vector(31 downto 0)   -- source
		);
	end component digital_display_issp;

	u0 : component digital_display_issp
		port map (
			source => CONNECTED_TO_source  -- sources.source
		);

