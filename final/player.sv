module player (input Clk,
					 Reset,
					 frame_clk, left, right,
					 input [9:0] DrawX, DrawY,
			   output logic [9:0] player_x_pos, player_y_pos,
				output is_player
		   );


    parameter [9:0] player_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] player_Y_Center = 10'd450;  // Center position on the Y axis
    parameter [9:0] player_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] player_X_Max = 10'd639;     // Rightmost point on the X axis
	//TODO: Determine size and shape of the player
    parameter [9:0] player_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] player_Size = 10'd4;        // player size

	logic [9:0] player_X_Motion, player_x_pos_in, player_X_Motion_in;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			player_x_pos <= player_X_Center;
			player_y_pos <= player_Y_Center;
			player_X_Motion <= 10'd0;
		end
		else
		begin
			player_x_pos <= player_x_pos_in;
			player_y_pos <= player_Y_Center;
			player_X_Motion <= player_X_Motion_in;
		end
	end

	always_comb
	begin
		player_x_pos_in = player_x_pos;
		player_X_Motion_in = player_X_Motion;

		if (frame_clk_rising_edge)
		begin
		if (left == 1'b1)
			begin 
				if (player_x_pos <= player_X_Min + player_Size)
					player_X_Motion_in = 0;
				else 
					player_X_Motion_in = (~(player_X_Step) + 1'b1);//left
			end
		else if (right == 1'b1)
			begin
				if (player_x_pos + player_Size >= player_X_Max) 
					player_X_Motion_in = 0;
				else
					player_X_Motion_in = player_X_Step;//right
			end
		else
			player_X_Motion_in = 0;
		player_x_pos_in = player_x_pos + player_X_Motion;
		end
	end
	
	// Picture 6x11
	// Center is in 3,6 (one-indexed) 
	//
	// 0 0 0 0 0 1 0 0 0 0 0
	// 0 0 0 0 1 1 1 0 0 0 0
	// 0 1 1 1 1 C 1 1 1 1 0 
	// 1 1 1 1 1 1 1 1 1 1 1
	// 1 1 1 1 1 1 1 1 1 1 1
	// 1 1 1 1 1 1 1 1 1 1 1
	
	int DistX, DistY, Size;
	assign DistX = player_x_pos - DrawX;
   	assign DistY = player_y_pos - DrawY;
   	always_comb begin
		is_player = 0;
		if (DistY == 2 && DistX == 0)
			is_player = 1;
		else if (DistY == 1 && DistX <= 1 && DistX >= -1)
			is_player = 1;
		else if (DistY == 0 && DistX <= 4 && DistX >= -4)
			is_player = 1;
		else if (DistY >= -3 && DistY <= -1 && DistX <= 5 && DistX >= -5)
			is_player = 1;
    end

endmodule
