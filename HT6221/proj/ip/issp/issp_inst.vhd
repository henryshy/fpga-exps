	component issp is
		port (
			probe : in std_logic_vector(31 downto 0) := (others => 'X')  -- probe
		);
	end component issp;

	u0 : component issp
		port map (
			probe => CONNECTED_TO_probe  -- probes.probe
		);

