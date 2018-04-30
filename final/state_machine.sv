module state_machine (input Clk, Reset, is_lost, is_won,
					  output level_reset,
					  output [1:0] level, color_mapper_select
					);
							 
enum logic [3:0] {Start, Level_1_Setup, Level_1_Wait, Level_2_Setup, Level_2_Wait, Level_3_Setup, Level_3_Wait, Won, Lost1, Lost2, Lost3} curr_state, next_state;

always_ff @ (posedge Clk)  
 begin
	  if (Reset)
			curr_state <= Start;
	  else 
			curr_state <= next_state;
 end
 
always_comb
begin
	next_state = curr_state;
	unique case (curr_state)
		Start: next_state = Level_1_Setup;
		Level_1_Setup: next_state = Level_1_Wait;
		Level_1_Wait: begin
							if(is_lost) next_state = Lost1;
							if(is_won) next_state = Level_2_Setup;
						  end
		Level_2_Setup: next_state = Level_2_Wait;
		Level_2_Wait: begin 
							if(is_lost) next_state = Lost2;
							if(is_won) next_state = Level_3_Setup;
						  end
		Level_3_Setup: next_state = Level_3_Wait;
		Level_3_Wait: begin
						   if(is_lost) next_state = Lost3;
							if(is_won) next_state = Won;
						  end
		Won: if(Reset) next_state = Start;
		Lost1: if(Reset) next_state = Start;
		Lost2: if(Reset) next_state = Start;
		Lost3: if(Reset) next_state = Start;
	endcase
	
	case (curr_state)
		Start: 
		begin
			level = 2'b00;
			level_reset = 0;
			color_mapper_select = 2'b00;
		end
		Level_1_Setup:
		begin
			level = 2'b00;
			level_reset = 1;
			color_mapper_select =2'b00;
		end
		Level_1_Wait:
		begin
			level = 2'b00;
			level_reset = 0;
			color_mapper_select = 2'b00;
		end
		Level_2_Setup:
		begin
			level = 2'b01;
			level_reset = 1;
			color_mapper_select =2'b01;
		end
		Level_2_Wait:
		begin
			level = 2'b01;
			level_reset = 0;
			color_mapper_select =2'b01;
		end
		Level_3_Setup:
		begin
			level = 2'b10;
			level_reset = 1;
			color_mapper_select =2'b10;
		end
		Level_3_Wait:
		begin
			level = 2'b10;
			level_reset = 0;
			color_mapper_select =2'b10;
		end
		Lost1:
		begin
			level = 2'b00;
			level_reset = 0;
			color_mapper_select = 2'b11;
		end
		Lost2:
		begin
			level = 2'b01;
			level_reset = 0;
			color_mapper_select = 2'b11;
		end
		Lost3:
		begin
			level = 2'b10;
			level_reset = 0;
			color_mapper_select = 2'b11;
		end
		Won:
		begin
			level = 2'b10;
			level_reset = 0;
			color_mapper_select = 2'b11;
		end
		default:
		begin
			level = 2'b00;
			level_reset = 0;
			color_mapper_select = 2'b00;
		end
		
	endcase
		

end

endmodule
