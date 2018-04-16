module hitbox(input logic [9:0] target1_x_pos, target1_y_pos,
								target2_x_pos, target2_y_pos,
								threshold,
			  output logic is_hit);
	int dist_x, dist_y, thresh;
	assign dist_x = target1_x_pos - target2_x_pos;
	assign dist_y = target1_y_pos - target2_y_pos;
	assign thresh = threshold;
	always_comb begin
		if ((dist_x * dist_x + dist_y * dist_y) <= (thresh * thresh))
			is_hit = 1;
		else
			is_hit = 0;
	end
endmodule
