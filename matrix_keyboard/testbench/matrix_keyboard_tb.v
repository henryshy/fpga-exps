module matrix_keyboard_tb();

	reg clk;
	reg rst_n;
	reg [3:0] keyboard_row_in;
	
	wire {3:0] key_flag;
	wire [3:0] keyboard_column_out;
	wire key_value;
	
	matrix_keyboard matrix_keyboard(
			
		.clk(clk),
		.rst_n(rst_n),
		.keyboard_row_in(keyboard_row_in),
		
		.key_flag(key_flag),
		.keyboard_column_out(keyboard_column_out),
		.key_value(key_value)
	);
	
	//懒得写了
	

endmodule