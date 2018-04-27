module state_machine (input Clk, Reset, Run, is_lost, is_won,
							 output [1:0] level, color_mapper);
							 
enum logic [3:0] {Start, Level_1_Setup, Level_1_Wait, Level_2_Setup, Level_2_Wait, Level_3_Setup, Level_3_Wait, Won, Lost} curr_state, next_state;

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
							if(is_lost) next_state = Lost;
							if(is_won) next_state = Level_2_Setup;
						  end
		Level_2_Setup: next_state = Level_2_Wait;
		Level_2_Wait: begin 
							if(is_lost) next_state = Lost;
							if(is_won) next_state = Level_3_Setup;
						  end
		Level_3_Setup: next_state = Level_3_Wait;
		Level_3_Wait: begin
						   if(is_lost) next_state = Lost;
							if(is_won) next_state = Won;
		Won: if(Reset) next_state = Start;
		Lost: if(Reset) next_state = Start;
	endcase
	
	case (curr_state)
		Start: 
		begin
			level = 2'b00;
			color_mapper = 2'b00;
		end
		Level_1_Setup:
		begin
			level = 2'b00;
			color_mapper =2'b00;
		end
		Level_1_Wait:
		begin
			level = 2'b00;
			color_mapper = 2'b00;
		end
		Level_2_Setup:
		begin
			level = 2'b01;
			color_mapper =2'b01;
		end
		Level_2_Wait:
		begin
			level = 2'b01;
			color_mapper =2'b01;
		end
		Level_3_Setup:
		begin
			level = 2'b10;
			color_mapper =2'b10;
		end
		Level_3_Wait:
		begin
			level = 2'b10;
			color_mapper =2'b10;
		end
		Lost:
		begin
			level = 2'b00;
			color_mapper = 2'b11;
		end
		Won:
		begin
			level = 2'b00;
			color_mapper = 2'b11;
		end
		default:
		begin
			level = 2'b00;
			color_mapper = 2'b00;
		end
		
	endcase
		

end

endmodule
