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
module  color_mapper ( input              is_player,            // Whether current pixel belongs to ball 
										  is_missile,
										  is_alien,
					   input [1:0] 	      level,
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	logic [7:0] addr;
	logic [7:0] data;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

	// Partition 16x8 for level
	// StartY = 450
	// EndY = 466
	// StartX = 40
	// EndX = 48
	// Partition 16x16 for score
	
	font_rom fonts(.*);
    
	logic should_draw;
	int diffX, diffY;
	//int offset;
    // Assign color based on is_ball signal
    always_comb
    begin
		//offset = level << 4;
		addr = 0;
		should_draw = 0;
		// Level partition
		if (DrawY <= 466 && DrawY >= 450 && DrawX <= 48 && DrawX >= 40) begin
			diffY = DrawY - 450;
			addr = diffY; // + offset
			diffX = DrawX - 40;
			should_draw = data[diffX];
			if (should_draw) begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			else begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
		end
		else if (is_missile == 1'b1)
			begin
					Red = 8'hff;
					Green = 8'h0;
					Blue = 8'h0;
			end
			  else if (is_player == 1'b1) 
			  begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
			  end
			else if (is_alien == 1'b1)
			begin
					Red = 8'h00;
					Green = 8'hff;
					Blue = 8'h00;
			end
			  else 
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
		end

    
endmodule

