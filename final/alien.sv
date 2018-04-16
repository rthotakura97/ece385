module alien (input Clk,
			  		Reset,
					frame_clk, is_hit, 
					init_direction, // 0 for left, 1 for right
			  input [9:0] alien_x_start, alien_y_start,
			  input [9:0] DrawX, DrawY,
			  output is_alien,
			  output [9:0] alien_x_pos, alien_y_pos
			 );
	
	parameter [9:0] alien_x_min = 10'd10;
	parameter [9:0] alien_x_max = 10'd629;
	parameter [9:0] alien_y_max = 10'd349;
	parameter [9:0] alien_x_step = 10'd1;
	parameter [9:0] alien_y_step = 10'd30;
	parameter [9:0] alien_size = 10'd4;

	//logic [9:0] alien_x_pos, alien_y_pos;
	logic [9:0] alien_x_pos_in, alien_y_pos_in;
	logic [9:0] alien_x_motion, alien_x_motion_in, alien_y_motion, alien_y_motion_in;
	logic [1:0] direction, direction_in; //0 for left, 1 for right, 2 for down
	logic is_hit_curr;

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end

	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			is_hit_curr <= 1'b0;
			alien_x_pos <= alien_x_start;	
			alien_y_pos <= alien_y_start;	
			if (direction == 1'b0)
				alien_x_motion <= alien_x_step;
			else
				alien_x_motion <= ~(alien_x_step) + 1'b1;
			alien_y_motion <= 10'd0;
		end
		else
		begin
			alien_x_pos <= alien_x_pos_in;	
			alien_y_pos <= alien_y_pos_in;	
			alien_x_motion <= alien_x_motion_in;
			alien_y_motion <= alien_y_motion_in;
			direction <= direction_in;
			is_hit_curr <= is_hit;
		end
	end

	//know when to move, know direction to move
	always_comb
	begin
		alien_x_pos_in = alien_x_pos;
		alien_y_pos_in = alien_y_pos;
		alien_x_motion_in = alien_x_motion;
		alien_y_motion_in = alien_y_motion;
		
		direction_in = direction;

		if (frame_clk_rising_edge && !is_hit_curr)
		begin
			case (direction)
				2'd0:begin // Left
					if (alien_x_pos <= alien_x_min + alien_size) begin
						direction_in = 2'd2;
						alien_x_motion_in = 0;
						alien_y_motion_in = 0;
					end
					else begin
						direction_in = 2'd0;
						alien_y_motion_in = 0;
						alien_x_motion_in = ~(alien_x_step) + 1'b1;
					end
				end
				2'd1: begin // Right
					if (alien_x_pos + alien_size >= alien_x_max) begin
						direction_in = 2'd2;
						alien_x_motion_in = 0;
						alien_y_motion_in = 0;
					end
					else 
					begin
						direction_in = 2'd1;
						alien_y_motion_in = 0;
						alien_x_motion_in = alien_x_step;
					end
				end
				2'd2: begin // Down
					alien_y_motion_in = alien_y_step;
					alien_x_motion_in = 0;
					if (alien_x_pos > 320) // go left 
						direction_in = 2'd0;
					else // go right
						direction_in = 2'd1;
				end
				default: begin
					direction_in = 2'd3;
					alien_x_motion_in = 0;
					alien_y_motion_in = 0;
				end
			endcase

			


			alien_x_pos_in = alien_x_pos + alien_x_motion;
			alien_y_pos_in = alien_y_pos + alien_y_motion;
		end
		else if (is_hit_curr) begin
			alien_x_pos_in = 10'b0;
			alien_y_pos_in = 10'b0;
			alien_x_motion_in = 10'b0;
			alien_x_motion_in = 10'b0;
		end
	end

	int DistX, DistY, Size;
   assign DistX = DrawX - alien_x_pos;
   assign DistY = DrawY - alien_y_pos;
   assign Size = alien_size;
   always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) && !is_hit_curr ) 
            is_alien = 1'b1;
        else
            is_alien = 1'b0;
    end
endmodule
