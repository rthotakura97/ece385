module boss_projectile (input Clk,
								Reset,
								shoot,
								frame_clk, is_hit,
								negative_x,
						  input [2:0] projectile_x_step, projectile_y_step,
						  input [9:0] DrawX, DrawY,
						  input [9:0] boss_x_pos, boss_y_pos,
						  output is_missile,
						  output [9:0] projectile_y_pos, projectile_x_pos
					  );

	parameter [9:0] projectile_size = 10'd2;
	parameter [9:0] projectile_y_max = 10'd480;
	parameter [9:0] projectile_x_min = 10'd4;
	parameter [9:0] projectile_x_max = 10'd636;

	logic [9:0] projectile_y_motion, projectile_x_motion, projectile_x_motion_in, projectile_x_pos_in, projectile_y_pos_in, projectile_y_motion_in;
		
	logic is_showing;
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
			projectile_x_motion <= 10'b0;
			projectile_y_motion <= 10'b0;
			is_hit_curr <= 10'b0;
		end
		else
		begin
			is_showing <= is_showing_in;
			projectile_x_pos <= projectile_x_pos_in;
			projectile_y_pos <= projectile_y_pos_in;
			projectile_x_motion <= projectile_x_motion_in;
			projectile_y_motion <= projectile_y_motion_in;
			is_hit_curr <= is_hit_in;
		end
	end

	always_comb
	begin
		is_showing_in = is_showing;
		projectile_x_pos_in = projectile_x_pos;
		projectile_y_pos_in = projectile_y_pos;
		projectile_x_motion_in = projectile_x_motion;
		projectile_y_motion_in = projectile_y_motion;

		if (is_hit)
			is_hit_in = 1'b1;
		else
			is_hit_in = 1'b0;

		if (is_hit_curr)
			begin
				is_showing_in = 1'b0;
				projectile_x_motion_in = 10'b0;
				projectile_y_motion_in = 10'b0;
				projectile_x_pos_in = 10'b0;
				projectile_y_pos_in = 10'b0;
				is_hit_in = 1'b0;
			end


		if (frame_clk_rising_edge)
		begin
			if (is_showing == 1'b1) // Moving down
			begin
				if (projectile_y_pos + projectile_size >= projectile_y_max || projectile_x_pos <= projectile_x_min + projectile_size || projectile_x_pos + projectile_size >= projectile_x_max) // Missle stops
				begin
					is_showing_in = 1'b0;
					projectile_y_motion_in = 10'b0;
					projectile_x_motion_in = 10'b0;
					projectile_x_pos_in = 10'b0;
					projectile_y_pos_in = 10'b0;
					is_hit_in = 1'b0;
				end
				else
				begin
					projectile_y_motion_in = projectile_y_step;
					if (negative_x == 1) begin
						projectile_x_motion_in = ~(projectile_x_step) + 1;
					end
					else begin
						projectile_x_motion_in = projectile_x_step;
					end
					projectile_y_pos_in = projectile_y_pos + projectile_y_motion;
					projectile_x_pos_in = projectile_x_pos + projectile_x_motion;
				end

			end
			else if (shoot == 1'b1) // Start moving
			begin
				is_showing_in = 1'b1;
				projectile_x_pos_in = boss_x_pos;
				projectile_y_pos_in = boss_y_pos;
				if (negative_x == 1) begin
					projectile_x_motion_in = ~(projectile_x_step) + 1;
				end
				else begin
					projectile_x_motion_in = projectile_x_step;
				end
				projectile_y_motion_in = projectile_y_step;
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
