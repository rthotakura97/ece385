module player_projectile (input Clk,
								Reset,
								shoot,
								frame_clk, is_hit,
						  input [9:0] DrawX, DrawY,
						  input [9:0] player_x_pos, player_y_pos,
						  output is_missile,
						  output [9:0] projectile_y_pos, projectile_x_pos
					  );

	parameter [9:0] projectile_step = ~(10'd4) + 1'b1;
	parameter [9:0] projectile_size = 10'd3;
	parameter [9:0] projectile_y_min = 10'd0;

	logic [9:0] projectile_y_motion, projectile_x_pos_in, projectile_y_pos_in,
		projectile_y_motion_in;
		
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
			else if (shoot == 1'b1) // Start moving
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

module missile_control(input Clk, Reset, shoot,
					   output [1:0] missile_select);

	enum logic[2:0] {Select0_0, Select0_1, Select1_0, Select1_1, Select2_0, Select2_1} curr_state, next_state;

	always_ff @ (posedge Clk)
	begin
		if (Reset)
			curr_state <= Select0;
		else
			curr_state <= next_state;
	end

	always_comb
	begin
		next_state = curr_state
		missile_select = 0;

		case (curr_state)
			Select0_0: begin
				missile_select = 2'd0;
				if (shoot == 1) next_state = Select0_1;
			end
			Select0_0: begin
				missile_select = 2'd0;
				if (shoot == 0) next_state = Select1_0;
			end
			Select1_0: begin
				missile_select = 2'd1;
				if (shoot == 1) next_state = Select1_1;
			end
			Select1_1: begin
				missile_select = 2'd1;
				if (shoot == 0) next_state = Select2_0;
			end
			Select2_0: begin
				missile_select = 2'd2;
				if (shoot == 1) next_state = Select2_1;
			end
			Select2_1: begin
				missile_select = 2'd2;
				if (shoot == 0) next_state = Select0_0;
			end
			default: begin 
				missile_select = 2'd0;
				next_state = Select0;
			end
		endcase
	end
endmodule
