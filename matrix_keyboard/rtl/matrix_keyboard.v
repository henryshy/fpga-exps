module matrix_keyboard(
		
	clk,
	rst_n,
	keyboard_row_in,
	
	key_flag,
	keyboard_column_out,
	key_value
);
	input clk;
	input rst_n;
	input [3:0]keyboard_row_in;
	
	output reg key_flag;
	output reg [3:0] keyboard_column_out;
	output reg [3:0] key_value;
	
	reg [3:0] state;
	localparam
		idle          = 1 ,
		filter_p	     = 2 ,
		store_row_in = 3 ,
		scan_column_1 = 4 ,
		scan_column_2 = 5 ,
		scan_column_3 = 6 ,
		scan_column_4 = 7 , 
		result        = 8 ,
		wait_r        = 9 , 
		filter_r      = 10, 
		read_row_in   = 11; 
	
	reg [19:0]counter1;
	reg [19:0]counter2;
	
	reg cnt1_done;
	reg cnt2_done;
	
	reg cnt1_en;
	reg cnt2_en;
	
	
	reg [3:0] row_in_buffer;
	reg [3:0] column_out;
	reg key_flag_tmp;
	reg [7:0]key_press_result_tmp;
	
	always@(posedge clk or negedge rst_n)//20ms for scanning the keyboard or for filtering
		if(!rst_n)
			counter1 <= 0;
		else if(cnt1_en)
			if(counter1 == 999999)
				counter1 <= 0;
			else
				counter1 <= counter1 + 1'b1;
		else
			counter1 <= counter1;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt1_done <= 1'b0;
		else if(counter1 == 999999)
			cnt1_done <= 1'b1;
		else
			cnt1_done <= 1'b0;
	
	always@(posedge clk or negedge rst_n)//20ms for dealing with the glitch or coutinuous input
		if(!rst_n)
			counter2 <= 0;
		else if(cnt2_en)
			if(counter2 == 999999)
				counter2 <= 0;
			else
				counter2 <= counter2 + 1'b1;
		else
			counter2 <= counter2;
	
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt2_done <= 1'b0;
		else if(counter2 == 999999)
			cnt2_done <= 1'b1;
		else
			cnt2_done <= 1'b0;
	
	
	

	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			state <= idle;
			cnt1_en <= 0;
			cnt2_en <= 0;
			keyboard_column_out <= 0;
			row_in_buffer <= 4'b1111;
			column_out <= 0;
			key_flag_tmp <= 0;
			key_press_result_tmp <= 0;
		end
		else
			case(state)
				idle          : begin  
										if(keyboard_row_in == 4'b1111) begin
											state <= idle;
											cnt1_en <= 0;
										end
										else begin
											state <= filter_p;
											cnt1_en <=1;
										end
									 end
									 
				filter_p	     : begin   
										if(cnt1_done) begin
											state <= store_row_in;
											cnt1_en <= 0;
										end
										else	
											state <= filter_p;
									 end
									 
				store_row_in : begin    
										if(keyboard_row_in == 4'b1111) begin
											state <= idle;
											keyboard_column_out <= 0;
										end
										else begin
											state <= scan_column_1;
											row_in_buffer <= keyboard_row_in;
											keyboard_column_out <= 4'b1110; 
										end
									 end
									 
				scan_column_1 : begin
										if(keyboard_row_in != 4'b1111) //key input found
											column_out <= keyboard_column_out;
										else 
											column_out <= 4'b0001;

										state <= scan_column_2;
										keyboard_column_out <= 4'b1101;
											
									 end
									 
				scan_column_2 : begin 
				
										if(keyboard_row_in != 4'b1111) //key input found
											column_out <= column_out | 4'b0010;
										else 
											column_out <= column_out;

										state <= scan_column_3;
										keyboard_column_out <= 4'b1011;
										
									 end
									 
				scan_column_3 : begin  
				
									 	if(keyboard_row_in != 4'b1111) //key input found
											column_out <= column_out | 4'b0100;
										else 
											column_out <= column_out;

										state <= scan_column_4;
										keyboard_column_out <= 4'b0111;
										
									 end
									 
				scan_column_4 : begin   
				
										if(keyboard_row_in != 4'b1111) //key input found
											column_out <= column_out | 4'b1000;
										else 
											column_out <= column_out;

										state <= result;
										keyboard_column_out <= 4'b0000;
										
									 end
				result        : begin 
										
										if((row_in_buffer[3]+row_in_buffer[2]+row_in_buffer[1]+row_in_buffer[0]) == 3 && (column_out[3]+column_out[2]+column_out[1]+column_out[0]) == 1)
										begin
											state <= wait_r;
											key_flag_tmp <= 1;
											key_press_result_tmp <= {row_in_buffer,column_out};
										end
										else begin
											state <= idle;
											key_flag_tmp <= 0;
											key_press_result_tmp <= key_press_result_tmp;
										end
							
									 end
				wait_r        : begin  
										
										key_flag_tmp <= 0;
										if(keyboard_row_in == 4'b1111) begin
											cnt1_en <= 1;
											state <= filter_r;
											cnt2_en <= 0;
										end
										else begin
											cnt2_en <= 1;
											cnt1_en <= 0;
											state <= wait_r;
										end
																				
									 end
				filter_r      : begin 
										
										if(cnt1_done) begin
											state <= read_row_in;
											cnt1_en <= 0;
										end
										else
											state <= filter_r;
											cnt1_en <= 1;
											
									 end
									 
				read_row_in   : begin
				
										if(keyboard_row_in != 4'b1111) begin
											state <= filter_r;
											cnt1_en <= 1;
										end
										else
											state <= idle;
											
									 end
				default:;
			endcase
			
	always@(posedge clk or negedge rst_n)
		if(!rst_n) begin
			key_flag <= 0;
			key_value <=0;
		end
		else if(key_flag_tmp) begin
			key_flag <= key_flag_tmp | cnt2_done;
			
			case(key_press_result_tmp)
				8'b1110_0001 : key_value <= 4'd0;
				8'b1110_0010 : key_value <= 4'd1; 
				8'b1110_0100 : key_value <= 4'd2;  
				8'b1110_1000 : key_value <= 4'd3;   
				8'b1101_0001 : key_value <= 4'd4;  
				8'b1101_0010 : key_value <= 4'd5; 
				8'b1101_0100 : key_value <= 4'd6;   
				
				8'b1101_1000 : key_value <= 4'd7;   
				8'b1011_0001 : key_value <= 4'd8;  
				8'b1011_0010 : key_value <= 4'd9;   
				8'b1011_0100 : key_value <= 4'd10;  
				8'b1011_1000 : key_value <= 4'd11;  
				8'b0111_0001 : key_value <= 4'd12;  
				8'b0111_0010 : key_value <= 4'd13;  
				8'b0111_0100 : key_value <= 4'd14;
				8'b0111_1000 : key_value <= 4'd15;  
				default: begin 
								key_value <= key_value;
								key_flag <= key_flag;
							end 
			endcase 
		end
		
endmodule