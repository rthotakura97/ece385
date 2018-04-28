module level_3(input Reset, Clk, shoot, left, right, frame_clk,
			   input [9:0] DrawX, DrawY,
			   output [7:0] VGA_R, VGA_B, VGA_G,
			   output is_lost, is_won,
			   output int score);
	parameter hitbox_threshold = 10'd50;
	logic is_player;
	logic [9:0] player_x_pos, player_y_pos;
	logic [9:0] projectile_y_pos[3], projectile_x_pos[3];
	logic [9:0] boss_projectile_y_pos[15], boss_projectile_x_pos[15];

	logic is_boss_hit_total, is_boss, is_boss_dead, is_missile[3], is_alien_missile[15];
	logic [9:0] boss_x_pos, boss_y_pos;

	logic is_missile_total;
	logic is_hit_missile[3];

	logic [1:0] missile_select;
	logic is_hit[3], is_hit_boss_missile[15];

	always_comb begin
		score = 0; // TODO: figure out boss score
		is_won = is_boss_dead;
		is_lost = is_hit_boss_missile[0] || is_hit_boss_missile[1] || is_hit_boss_missile[2] || is_hit_boss_missile[3] || is_hit_boss_missile[4] || is_hit_boss_missile[5] || is_hit_boss_missile[6] || is_hit_boss_missile[7] || is_hit_boss_missile[8] || is_hit_boss_missile[9] || is_hit_boss_missile[10] || is_hit_boss_missile[11] || is_hit_boss_missile[12] || is_hit_boss_missile[13] || is_hit_boss_missile[14]; 
		is_hit_missile[0] = is_hit[0];
		is_hit_missile[1] = is_hit[1];
		is_hit_missile[2] = is_hit[2];
		
		is_boss_hit_total = is_hit[0] || is_hit[1] || is_hit[2];
		is_missile_total = is_missile[0] || is_missile[1] || is_missile[2] || is_alien_missile[0] || is_alien_missile[1] || is_alien_missile[2] || is_alien_missile[3] || is_alien_missile[4] || is_alien_missile[5] || is_alien_missile[6] || is_alien_missile[7] || is_alien_missile[8] || is_alien_missile[9] || is_alien_missile[10] || is_alien_missile[11] || is_alien_missile[12] || is_alien_missile[13] || is_alien_missile[14];
	end

	// Color Mapper
	color_mapper colormapper(.*, .is_alien(is_boss), .is_missile(is_missile_total));

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
	
	logic [6:0] pseudo[3];
	logic shoot_signal[3];
	
	lsfr_2 rand0(.Clk(frame_clk), .Reset, .seed(103), .q(pseudo[0]));
	lsfr_2 rand1(.Clk(frame_clk), .Reset, .seed(58), .q(pseudo[1]));
	lsfr_2 rand2(.Clk(frame_clk), .Reset, .seed(97), .q(pseudo[2]));

	always_ff @ (posedge frame_clk) begin
		shoot_signal[0] <= (pseudo[0] == 1);
		shoot_signal[1] <= (pseudo[1] == 1);
		shoot_signal[2] <= (pseudo[2] == 1);
	end

	// Wave 1
	boss_projectile boss_missile0(.*, .shoot(shoot_signal[0]), .is_hit(is_hit_boss_missile[0]), .negative_x(0), .projectile_x_step('d0), .projectile_y_step('d3), .is_missile(is_alien_missile[0]), .projectile_y_pos(boss_projectile_y_pos[0]), .projectile_x_pos(boss_projectile_x_pos[0]));
	boss_projectile boss_missile1(.*, .shoot(shoot_signal[0]), .is_hit(is_hit_boss_missile[1]), .negative_x(0), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[1]), .projectile_y_pos(boss_projectile_y_pos[1]), .projectile_x_pos(boss_projectile_x_pos[1]));
	boss_projectile boss_missile2(.*, .shoot(shoot_signal[0]), .is_hit(is_hit_boss_missile[2]), .negative_x(1), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[2]), .projectile_y_pos(boss_projectile_y_pos[2]), .projectile_x_pos(boss_projectile_x_pos[2]));
	boss_projectile boss_missile3(.*, .shoot(shoot_signal[0]), .is_hit(is_hit_boss_missile[3]), .negative_x(0), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[3]), .projectile_y_pos(boss_projectile_y_pos[3]), .projectile_x_pos(boss_projectile_x_pos[3]));
	boss_projectile boss_missile4(.*, .shoot(shoot_signal[0]), .is_hit(is_hit_boss_missile[4]), .negative_x(1), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[4]), .projectile_y_pos(boss_projectile_y_pos[4]), .projectile_x_pos(boss_projectile_x_pos[4]));

	// Wave 2
	boss_projectile boss_missile5(.*, .shoot(shoot_signal[1]), .is_hit(is_hit_boss_missile[5]), .negative_x(0), .projectile_x_step('d0), .projectile_y_step('d3), .is_missile(is_alien_missile[5]), .projectile_y_pos(boss_projectile_y_pos[5]), .projectile_x_pos(boss_projectile_x_pos[5]));
	boss_projectile boss_missile6(.*, .shoot(shoot_signal[1]), .is_hit(is_hit_boss_missile[6]), .negative_x(0), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[6]), .projectile_y_pos(boss_projectile_y_pos[6]), .projectile_x_pos(boss_projectile_x_pos[6]));
	boss_projectile boss_missile7(.*, .shoot(shoot_signal[1]), .is_hit(is_hit_boss_missile[7]), .negative_x(1), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[7]), .projectile_y_pos(boss_projectile_y_pos[7]), .projectile_x_pos(boss_projectile_x_pos[7]));
	boss_projectile boss_missile8(.*, .shoot(shoot_signal[1]), .is_hit(is_hit_boss_missile[8]), .negative_x(0), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[8]), .projectile_y_pos(boss_projectile_y_pos[8]), .projectile_x_pos(boss_projectile_x_pos[8]));
	boss_projectile boss_missile9(.*, .shoot(shoot_signal[1]), .is_hit(is_hit_boss_missile[9]), .negative_x(1), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[9]), .projectile_y_pos(boss_projectile_y_pos[9]), .projectile_x_pos(boss_projectile_x_pos[9]));
	
	// Wave 3
	boss_projectile boss_missile10(.*, .shoot(shoot_signal[2]), .is_hit(is_hit_boss_missile[10]), .negative_x(0), .projectile_x_step('d0), .projectile_y_step('d3), .is_missile(is_alien_missile[10]), .projectile_y_pos(boss_projectile_y_pos[10]), .projectile_x_pos(boss_projectile_x_pos[10]));
	boss_projectile boss_missile11(.*, .shoot(shoot_signal[2]), .is_hit(is_hit_boss_missile[11]), .negative_x(0), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[11]), .projectile_y_pos(boss_projectile_y_pos[11]), .projectile_x_pos(boss_projectile_x_pos[11]));
	boss_projectile boss_missile12(.*, .shoot(shoot_signal[2]), .is_hit(is_hit_boss_missile[12]), .negative_x(1), .projectile_x_step('d1), .projectile_y_step('d3), .is_missile(is_alien_missile[12]), .projectile_y_pos(boss_projectile_y_pos[12]), .projectile_x_pos(boss_projectile_x_pos[12]));
	boss_projectile boss_missile13(.*, .shoot(shoot_signal[2]), .is_hit(is_hit_boss_missile[13]), .negative_x(0), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[13]), .projectile_y_pos(boss_projectile_y_pos[13]), .projectile_x_pos(boss_projectile_x_pos[13]));
	boss_projectile boss_missile14(.*, .shoot(shoot_signal[2]), .is_hit(is_hit_boss_missile[14]), .negative_x(1), .projectile_x_step('d2), .projectile_y_step('d3), .is_missile(is_alien_missile[14]), .projectile_y_pos(boss_projectile_y_pos[14]), .projectile_x_pos(boss_projectile_x_pos[14]));
	
	// Hitboxes
	// Player hitboxes
	hitbox player_hit0(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[0]), .target2_y_pos(boss_projectile_y_pos[0]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[0]));
	hitbox player_hit1(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[1]), .target2_y_pos(boss_projectile_y_pos[1]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[1]));
	hitbox player_hit2(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[2]), .target2_y_pos(boss_projectile_y_pos[2]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[2]));
	hitbox player_hit3(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[3]), .target2_y_pos(boss_projectile_y_pos[3]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[3]));
	hitbox player_hit4(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[4]), .target2_y_pos(boss_projectile_y_pos[4]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[4]));

	hitbox player_hit5(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[5]), .target2_y_pos(boss_projectile_y_pos[5]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[5]));
	hitbox player_hit6(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[6]), .target2_y_pos(boss_projectile_y_pos[6]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[6]));
	hitbox player_hit7(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[7]), .target2_y_pos(boss_projectile_y_pos[7]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[7]));
	hitbox player_hit8(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[8]), .target2_y_pos(boss_projectile_y_pos[8]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[8]));
	hitbox player_hit9(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[9]), .target2_y_pos(boss_projectile_y_pos[9]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[9]));

	hitbox player_hit10(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[10]), .target2_y_pos(boss_projectile_y_pos[10]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[10]));
	hitbox player_hit11(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[11]), .target2_y_pos(boss_projectile_y_pos[11]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[11]));
	hitbox player_hit12(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[12]), .target2_y_pos(boss_projectile_y_pos[12]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[12]));
	hitbox player_hit13(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[13]), .target2_y_pos(boss_projectile_y_pos[13]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[13]));
	hitbox player_hit14(.target1_x_pos(player_x_pos), .target1_y_pos(player_y_pos), .target2_x_pos(boss_projectile_x_pos[14]), .target2_y_pos(boss_projectile_y_pos[14]), .threshold(player_threshold), .is_hit(is_hit_boss_missile[14]));

	// Boss hitboxes
	hitbox boss_hit0(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[0]), .target2_y_pos(projectile_y_pos[0]), .threshold(hitbox_threshold), .is_hit(is_hit[0]));

	hitbox boss_hit1(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[1]), .target2_y_pos(projectile_y_pos[1]), .threshold(hitbox_threshold), .is_hit(is_hit[1]));

	hitbox boss_hit2(.target1_x_pos(boss_x_pos), .target1_y_pos(boss_y_pos), .target2_x_pos(projectile_x_pos[2]), .target2_y_pos(projectile_y_pos[2]), .threshold(hitbox_threshold), .is_hit(is_hit[2]));

endmodule
