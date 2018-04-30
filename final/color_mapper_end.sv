module color_mapper_end (input is_won, is_lost,                                //   or background (computed in ball.sv)
						 input int score,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
	parameter playerCenterX = 320;
	parameter playerCenterY = 240;
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	int tens, ones;
	int DistX, DistY;
    
	// x312 - 328
	//
    always_comb
    begin
		tens = score % 10;
		ones = score / 10;
		DistX = (playerCenterX - DrawX) >>> 3;
		DistY = (playerCenterY - DrawY) >>> 3;
		if (DistY == 2 && DistX == 0) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (DistY == 1 && DistX <= 1 && DistX >= -1) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (DistY == 0 && DistX <= 4 && DistX >= -4) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (DistY >= -3 && DistY <= -1 && DistX <= 5 && DistX >= -5) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if(is_won)
		begin
			Red = 8'h7f - {1'b0, DrawX[9:3]}; 
			Green = 8'hb0;
			Blue = 8'h8a;
		end
		else
		begin
			Red = 8'hff;
			Green = 8'h7a;
			Blue = 8'h29 - {1'b0, DrawY[9:3]};
		end
	end 
endmodule
