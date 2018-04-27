module state_machine (input Clk, Reset, Run, is_lost, is_won,
							 output [1:0] level, color_mapper);
							 
enum logic [FILLIN] {Reset, Level_1_Setup, Level_1_Wait, Level_1_Won, Level_1_Lost, Level_2_Setup, Level_2_Wait, Level_2_Won, Level_2_Lost, Level_} curr_state, next_state;

endmodule
