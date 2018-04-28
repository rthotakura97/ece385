module boss (input Clk,
			  		Reset,
					frame_clk, is_hit, 
			  input [9:0] DrawX, DrawY,
			  output is_boss, is_boss_dead,
			  output [9:0] boss_x_pos, boss_y_pos
			 );

	parameter [9:0] boss_x_start = 10'd320;
	parameter [9:0] boss_y_start = 10'd200;
	parameter [9:0] boss_x_min = 10'd60;
	parameter [9:0] boss_x_max = 10'd590;
	parameter [9:0] boss_x_step = 10'd2;
	parameter [9:0] boss_size = 10'd50;

	logic [9:0] boss_x_pos_in;
	logic [9:0] boss_x_motion, boss_x_motion_in;
	logic direction, direction_in; //0 for left, 1 for right
	logic [3:0] hit_count;
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
			boss_y_motion <= 10'd0;
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

	int DistX, DistY, Size;
	assign DistX = DrawX - boss_x_pos;
	assign DistY = DrawY - boss_y_pos;
	assign Size = boss_size;
	always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) && !is_boss_dead) 
            is_boss = 1'b1;
        else
            is_boss = 1'b0;
	end
endmodule
