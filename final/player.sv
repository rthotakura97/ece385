module player (input Clk,
					 Reset,
					 frame_clk,
			   input [7:0] keycode,
			   input [9:0] DrawX, DrawY,
			   output logic is_player
			   // should we output the player center?
		   );


    parameter [9:0] player_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] player_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] player_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] player_X_Max = 10'd639;     // Rightmost point on the X axis
	//TODO: Determine size and shape of the player
    parameter [9:0] player_Y_Min = 10'd436;       // Topmost point on the Y axis
    parameter [9:0] player_Y_Max = 10'd440;     // Bottommost point on the Y axis
    parameter [9:0] player_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] player_Size = 10'd4;        // player size

	logic [9:0] player_X_Pos, player_X_Motion, player_X_Pos_in, player_X_Motion_in;
	logic [9:0] player_Y_Pos;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		framce_clk_rising_edge <= (framce_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			player_X_Pos <= player_X_Center;
			player_Y_Pos <= player_Y_Center;
			player_X_Motion <= 10'd0;
			player_Y_Motion <= 10'd0;
		end
		else
		begin
			player_X_Pos <= player_X_Pos_in;
			player_Y_Pos <= player_Y_Center;
			player_X_Motion <= player_X_Motion_in;
			player_Y_Motion <= 10'd0;
		end
	end

	always_comb
	begin
		player_X_Pos_in = player_X_Pos;
		player_X_Motion_in = player_X_Motion;

		if (frame_clk_rising_edge)
		begin
			case (keycode)
				8'd80: player_X_Motion_in = (~(player_X_Step) + 1'b1);//left
				8'd79: player_X_Motion_in = player_X_Step;
		end

		if (player_X_Pos + player_Size >= player_X_Max) 
			player_X_Motion_in = 0;
		else if (player_X_Pos <= player_X_Min + player_Size)
			player_X_Motion_in = 0;
		
		player_X_Pos_in = player_X_Pos + player_X_Motion;
		end
	end

endmodule
