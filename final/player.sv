module player (input Clk,
					 Reset,
					 frame_clk, left, right,
			   input [7:0] keycode,
				input [9:0] DrawX, DrawY,
			   output logic [9:0] player_X_Pos, player_Y_Pos,
				output is_player
		   );


    parameter [9:0] player_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] player_Y_Center = 10'd450;  // Center position on the Y axis
    parameter [9:0] player_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] player_X_Max = 10'd639;     // Rightmost point on the X axis
	//TODO: Determine size and shape of the player
    parameter [9:0] player_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] player_Size = 10'd4;        // player size

	logic [9:0] player_X_Motion, player_X_Pos_in, player_X_Motion_in;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			player_X_Pos <= player_X_Center;
			player_Y_Pos <= player_Y_Center;
			player_X_Motion <= 10'd0;
		end
		else
		begin
			player_X_Pos <= player_X_Pos_in;
			player_Y_Pos <= player_Y_Center;
			player_X_Motion <= player_X_Motion_in;
		end
	end

	always_comb
	begin
		player_X_Pos_in = player_X_Pos;
		player_X_Motion_in = player_X_Motion;

		if (frame_clk_rising_edge)
		begin
		if (left == 1'b1)
			begin 
				if (player_X_Pos <= player_X_Min + player_Size)
					player_X_Motion_in = 0;
				else 
					player_X_Motion_in = (~(player_X_Step) + 1'b1);//left
			end
		else if (right == 1'b1)
			begin
				if (player_X_Pos + player_Size >= player_X_Max) 
					player_X_Motion_in = 0;
				else
					player_X_Motion_in = player_X_Step;//right
			end
		else
			player_X_Motion_in = 0;
			
			/*case (keycode)
				8'd80: begin 
						 if (player_X_Pos <= player_X_Min + player_Size)
							player_X_Motion_in = 0;
						 else 
							player_X_Motion_in = (~(player_X_Step) + 1'b1);//left
						 end
				8'd79: begin
						 if (player_X_Pos + player_Size >= player_X_Max) 
							player_X_Motion_in = 0;
						 else
							player_X_Motion_in = player_X_Step;//right
						 end
				default:player_X_Motion_in = 0;
			endcase*/
		
		player_X_Pos_in = player_X_Pos + player_X_Motion;
		end
	end
	
	int DistX, DistY, Size;
   assign DistX = DrawX - player_X_Pos;
   assign DistY = DrawY - player_Y_Pos;
   assign Size = player_Size;
   always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
            is_player = 1'b1;
        else
            is_player = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end

endmodule
