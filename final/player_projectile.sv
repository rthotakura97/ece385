module player_projectile (input Clk,
								Reset,
								shoot,
								frame_clk, is_hit,
								input [9:0] DrawX, DrawY,
						  input [9:0] player_x_pos, player_y_pos,
						  input [7:0] keycode,
						  output is_missile, is_showing,
						  output [9:0] projectile_y_pos, projectile_x_pos
					  );

	parameter [9:0] projectile_step = ~(10'd4) + 1'b1;
	parameter [9:0] projectile_size = 10'd3;
	parameter [9:0] projectile_y_min = 10'd0;

	logic [9:0] projectile_y_motion, projectile_x_pos_in, projectile_y_pos_in,
		projectile_y_motion_in;
	//logic [9:0] projectile_y_pos;
	//logic [9:0] projectile_x_pos;
		
	//logic is_showing;
	logic is_showing_in;
	logic is_hit_curr, is_hit_in;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			is_showing <= 10'b0;
			projectile_x_pos <= 10'b0;
			projectile_y_pos <= 10'b0;
			projectile_y_motion <= 10'b0;
			is_hit_curr <= 10'b0;
		end
		else
		begin
			is_showing <= is_showing_in;
			projectile_x_pos <= projectile_x_pos_in;
			projectile_y_pos <= projectile_y_pos_in;
			projectile_y_motion <= projectile_y_motion_in;
			is_hit_curr <= is_hit_in;
		end
	end

	always_comb
	begin
		is_showing_in = is_showing;
		projectile_x_pos_in = projectile_x_pos;
		projectile_y_pos_in = projectile_y_pos;
		projectile_y_motion_in = projectile_y_motion;

		if (is_hit)
			is_hit_in = 1'b1;
		else
			is_hit_in = 1'b0;

		if (is_hit_curr)
			begin
				is_showing_in = 1'b0;
				projectile_y_motion_in = 10'b0;
				projectile_x_pos_in = 10'b0;
				projectile_y_pos_in = 10'b0;
				is_hit_in = 1'b0;
			end


		if (frame_clk_rising_edge)
		begin
			if (is_showing == 1'b1) // Moving up
			begin
				if (projectile_y_pos <= projectile_y_min + projectile_size) // Missle stops
				begin
					is_showing_in = 1'b0;
					projectile_y_motion_in = 10'b0;
					projectile_x_pos_in = 10'b0;
					projectile_y_pos_in = 10'b0;
					is_hit_in = 1'b0;
				end
				else
				begin
					projectile_y_motion_in = projectile_step;
					projectile_y_pos_in = projectile_y_pos + projectile_y_motion;
				end

			end
			else if (shoot == 1'b1) //(keycode == 8'h2c) // Start moving
			begin
				is_showing_in = 1'b1;
				projectile_x_pos_in = player_x_pos;
				projectile_y_pos_in = player_y_pos;
				projectile_y_motion_in = projectile_step;
			end

		end
	end

	int DistX, DistY, Size;
   assign DistX = DrawX - projectile_x_pos;
   assign DistY = DrawY - projectile_y_pos;
   assign Size = projectile_size;
	always_comb
	begin
		if (is_showing == 1'b1) begin
			if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
				is_missile = 1'b1;
			else
				is_missile = 1'b0;
		end
		else begin
			is_missile = 1'b0;
		end
	end
endmodule
