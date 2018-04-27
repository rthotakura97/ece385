//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input    is_player,            // Whether current pixel belongs to ball 
										  is_missile,
										  is_alien,
										  end_game_won, 
										  end_game_lost,
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
		 if(end_game_won)
		 begin
				Red = 8'h7f - {1'b0, DrawX[9:3]}; 
				Green = 8'hb0;
				Blue = 8'h8a;
		 end
		 else if(end_game_lost)
		 begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
		 end
		 else begin
		 if (is_missile == 1'b1)
			begin
				// Red Ball
					Red = 8'hff;
					Green = 8'h0;
					Blue = 8'h0;
			end
			  else if (is_player == 1'b1) 
			  begin
					// White ball
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
			  end
			else if (is_alien == 1'b1)
			begin
					// Green ball
					Red = 8'h00;
					Green = 8'hff;
					Blue = 8'h00;
			end
			  else 
			  begin
					// Background with nice color gradient
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
			  end
		end
    end 
    
endmodule
