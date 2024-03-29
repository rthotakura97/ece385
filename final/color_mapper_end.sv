module color_mapper_end (input is_won, is_lost,                                //   or background (computed in ball.sv)
						 input int score,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
	parameter playerCenterX = 328;
	parameter playerCenterY = 240;
    logic [7:0] Red, Green, Blue;
	logic [7:0] addr, data;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	int tens, ones;
	int DistX, DistY;
	int DistXtemp, DistYtemp;
	int diffX,diffY;

	font_rom fonts(.*);
	logic should_draw;
    
	// x312 - 328
	//
    always_comb
    begin 
		diffY = 0;
		addr = 0;
		diffX = 0;
		should_draw = 0;
		tens = score % 10;
		ones = score / 10;
		DistXtemp = (playerCenterX - DrawX);
		DistYtemp = (playerCenterY - DrawY);
		DistX = DistXtemp >>> 4;
		DistY = DistYtemp >>> 4;
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
		else if (DistY == 0 && DistX <= 3 && DistX >= -3) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if (DistY >= -3 && DistY <= -1 && DistX <= 4 && DistX >= -4) begin
			if (DrawX >= 312 && DrawX <= 319 && DrawY >= 240 && DrawY <= 255) begin
				diffY = DrawY - 240;
				addr = diffY + (ones << 4);
				diffX = DrawX - 312;
				should_draw = data[8-diffX];
				if (should_draw) begin
					Red = 8'h0;
					Green = 8'h0;
					Blue = 8'h0;
				end
				else begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			end
			else if (DrawX >= 320 && DrawX <= 327 && DrawY >= 240 && DrawY <= 255) begin
				diffY = DrawY - 240;
				addr = diffY + (tens << 4);
				diffX = DrawX - 320;
				should_draw = data[8-diffX];
				if (should_draw) begin
					Red = 8'h0;
					Green = 8'h0;
					Blue = 8'h0;
				end
				else begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			end
			else begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
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
			Green = 8'h7a - {1'b0, DrawX[9:3]};
			Blue = 8'h09;
		end
	end 
endmodule
