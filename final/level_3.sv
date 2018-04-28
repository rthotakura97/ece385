module level_3(input Reset, Clk, shoot, left, right, frame_clk,
			   input [9:0] DrawX, DrawY,
			   output [7:0] VGA_R, VGA_B, VGA_G,
			   output is_lost, is_won,
			   output int score);
	parameter hitbox_threshold = 10'd50;
	logic is_player;
	logic [9:0] player_x_pos, player_y_pos;
	logic [9:0] projectile_y_pos[3], projectile_x_pos[3];

	logic is_boss_hit_total, is_boss, is_boss_dead, is_missile[3];
	logic [9:0] boss_x_pos, boss_y_pos;

	logic is_missile_total;
	logic is_hit_missile[3];

	logic [1:0] missile_select;
	logic is_hit[3];

	always_comb begin
		score = 0; // TODO: figure out boss score
		is_won = is_boss_dead;
		is_lost = 0; // TODO is_player_dead
		is_hit_missile[0] = is_hit[0];
		is_hit_missile[1] = is_hit[1];
		is_hit_missile[2] = is_hit[2];
		
		is_boss_hit_total = is_hit[0] || is_hit[1] || is_hit[2];
		is_missile_total = is_missile[0] || is_missile[1] || is_missile[2];
	end

	// Color Mapper
	color_mapper colormapper(.*, .is_alien(is_boss));

	// Player
	player player_inst(.*);

	// Missiles
	
	missile_control missile_controller(.*);
									
	player_projectile missile0(.*, .shoot(shoot && (missile_select == 2'd0)), .is_hit(is_hit_missile[0]), .is_missile(is_missile[0]), .projectile_y_pos(projectile_y_pos[0]), .projectile_x_pos(projectile_x_pos[0]));

	player_projectile missile1(.*, .shoot(shoot && (missile_select == 2'd1)), .is_hit(is_hit_missile[1]), .is_missile(is_missile[1]), .projectile_y_pos(projectile_y_pos[1]), .projectile_x_pos(projectile_x_pos[1]));

	player_projectile missile2(.*, .shoot(shoot && (missile_select == 2'd2)), .is_hit(is_hit_missile[2]), .is_missile(is_missile[2]), .projectile_y_pos(projectile_y_pos[2]), .projectile_x_pos(projectile_x_pos[2]));

	// Boss
	boss boss_inst(.*, .is_hit(is_boss_hit_total));
	
	// Boss missiles
	
	// Hitboxes
	// Player hitboxes
	// Boss hitboxes
	hitbox boss_hit0(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[0]), .target2_y_pos(projectile_y_pos[0]), .threshold(hitbox_threshold), .is_hit(is_hit[0]));

	hitbox boss_hit1(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[1]), .target2_y_pos(projectile_y_pos[1]), .threshold(hitbox_threshold), .is_hit(is_hit[1]));

	hitbox boss_hit2(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[2]), .target2_y_pos(projectile_y_pos[2]), .threshold(hitbox_threshold), .is_hit(is_hit[2]));

endmodule
