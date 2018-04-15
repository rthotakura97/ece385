module player_projectile (input Clk,
								Reset,
								frame_clk,
						  input [9:0] player_x_pos, player_y_pos,
						  input [7:0] keycode,
						  output is_missle
					  );

	parameter [9:0] projectile_step = 10'd2;
	parameter [9:0] projectile_size = ~(10'd3) + 1'b1;
	parameter [9:0] projectile_y_min = 10'd0;

	logic [9:0] projectile_y_motion, projectile_x_pos, projectile_x_pos_in, projectile_y_pos, projectile_y_pos_in;

	logic is_showing, is_showing_in;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			is_showing <= 0;
			projectile_x_pos <= 0;
			projectile_y_pos <= 0;
			projectile_y_motion <= 0;
		end
		else
		begin
			is_showing <= is_showing_in;
			projectile_x_pos <= projectile_x_pos_in;
			projectile_y_pos <= projectile_y_pos_in;
			projectile_y_motion <= projectile_y_motion_in;
		end
	end

	always_comb
	begin
		is_showing_in = is_showing;
		projectile_x_pos_in = projectile_x_pos;
		projectile_y_pos_in = projectile_y_pos;
		projectile_y_motion_in = projectile_y_motion;

		if (frame_clk_rising_edge)
		begin
			if (is_showing) // Moving up
			begin
				projectile_y_motion_in = projectile_step;
			end
			else if (keycode == 8'h2c) // Start moving
			begin
				is_showing_in = 1;
				projectile_x_pos_in = player_x_pos;
				projectile_y_pos_in = player_y_pos;
				projectile_y_motion_in = projectile_step;
			end
		end

		if (is_showing && projectile_y_pos < projectile_y_min) // Missle stops
		begin
			is_showing_in = 0;
			projectile_y_motion_in = 0;
			projectile_x_pos_in = 0;
			projectile_y_pos_in = 0;
		end
	end

	int DistX, DistY, Size;
   assign DistX = DrawX - projectile_x_pos;
   assign DistY = DrawY - projectile_y_pos;
   assign Size = projectile_size;
	always_comb
	begin
		if (is_showing) begin
			if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
				is_missle = 1'b1;
			else
				is_missle = 1'b0;
		end
		else begin
			is_missle = 0;
	end
endmodule
