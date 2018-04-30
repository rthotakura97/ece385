module boss (input Clk,
			  		Reset,
					frame_clk, is_hit, 
			  input [9:0] DrawX, DrawY,
			  output is_boss, is_boss_dead,
			  output [9:0] boss_x_pos, boss_y_pos,
			  output [3:0] hit_count
			 );

	parameter [9:0] boss_x_start = 10'd320;
	parameter [9:0] boss_y_start = 10'd160;
	parameter [9:0] boss_x_min = 10'd60;
	parameter [9:0] boss_x_max = 10'd590;
	parameter [9:0] boss_x_step = 10'd2;
	parameter [9:0] boss_size = 10'd50;

	logic [9:0] boss_x_pos_in;
	logic [9:0] boss_x_motion, boss_x_motion_in;
	logic direction, direction_in; //0 for left, 1 for right
	//logic [3:0] hit_count;
	logic is_hit_curr;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_comb begin
		is_boss_dead = (hit_count >= 10);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			is_hit_curr <= 1'b0;
			boss_x_pos <= boss_x_start;	
			boss_y_pos <= boss_y_start;	
			direction <= 1'b0;
			boss_x_motion <= 10'd0;
			hit_count = 4'd0;
		end
		else
		begin
			boss_x_pos <= boss_x_pos_in;	
			boss_x_motion <= boss_x_motion_in;
			direction <= direction_in;
			if (is_hit_curr) begin
				if (is_hit == 1'b0) begin
					is_hit_curr <= 1'b0;
				end
			end
			else if (is_hit) begin
				is_hit_curr <= 1;
				hit_count <= hit_count + 1;
			end
		end
	end

	always_comb
	begin
		boss_x_pos_in = boss_x_pos;
		boss_x_motion_in = boss_x_motion;
		
		direction_in = direction;

		if (frame_clk_rising_edge)
		begin
			case (direction)
				2'd0:begin // Left
					if (boss_x_pos <= boss_x_min + boss_size) begin
						direction_in = 2'd1;
						boss_x_motion_in = 0;
					end
					else begin
						direction_in = 2'd0;
						boss_x_motion_in = ~(boss_x_step) + 1'b1;
					end
				end
				2'd1: begin // Right
					if (boss_x_pos + boss_size >= boss_x_max) begin
						direction_in = 2'd0;
						boss_x_motion_in = 0;
					end
					else 
					begin
						direction_in = 2'd1;
						boss_x_motion_in = boss_x_step;
					end
				end 
			endcase
			boss_x_pos_in = boss_x_pos + boss_x_motion;
		end
	end
	

// Picture 128*176

	int DistX, DistY;
	int DistXtemp, DistYtemp;
   	always_comb begin
		DistXtemp = (boss_x_pos - DrawX);
		DistYtemp = (boss_y_pos - DrawY);

		DistX = DistXtemp >>> 4;
		DistY = DistYtemp >>> 4;

		is_boss = 0;
		if (!is_hit_curr) begin
			case (DistY)
				3: begin
					if (DistX == 3 || DistX == -3)
						is_boss = 1;
				end
				2: begin
					if (DistX == 2 || DistX == -2)
						is_boss = 1;
				end
				1: begin
					if (DistX <= 3 && DistX >= -3)
						is_boss = 1;
				end
				0: begin
					if (DistX == -4 || DistX == -3 || DistX == -1 || DistX == 0 || DistX == 1 || DistX == 3 || DistX == 4)
						is_boss = 1;
				end
				-1: begin
					if (DistX >= -5 && DistX <= 5)
						is_boss = 1;
				end
				-2: begin
					if (DistX == -5 || DistX == 5 || (DistX >= -3 && DistX <= 3))
						is_boss = 1;
				end
				-3: begin
					if (DistX == 5 || DistX == 3 || DistX == -3 || DistX == -5)
						is_boss = 1;
				end
				-4: begin
					if (DistX <= 2 && DistX >= -2 && DistX != 0)
						is_boss = 1;
				end
				default: is_boss = 0;
			endcase
		end
    end
endmodule
