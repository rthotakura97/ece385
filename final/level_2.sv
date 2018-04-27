module level_2(input Reset, Clk, shoot, left, right, frame_clk,
			   input [9:0] DrawX, DrawY,
			   output [7:0] VGA_R, VGA_B, VGA_G,
			   output is_lost, is_won,
			   output int score);
	parameter hitbox_threshold = 10'd20;
	logic is_player;
	logic [9:0] player_x_pos, player_y_pos;
	logic [9:0] projectile_y_pos[3], projectile_x_pos[3], alien_projectile_x_pos[3], alien_projectile_y_pos[3];

	logic is_hit[10][3], is_alien[10], is_missile[3], is_alien_hit[10], is_alien_oob[10];
	logic [9:0] alien_x_pos[10], alien_y_pos[10];

	logic is_hit_total, is_alien_total, is_missile_total;
	logic is_hit_missile[3];

	logic [1:0] missile_select;

	int alien_shoot_signal[10];
	logic is_alien_missile[10];
	logic is_hit_player[10];
	logic is_player_hit, is_player_hit_in;

	always_ff @ (posedge Clk) begin
		if (Reset) begin
			is_player_hit <= 0;
		end
		else begin
			if (is_player_hit == 1)
				is_player_hit <= 1;
			else
				is_player_hit <= is_player_hit_in; 
		end
	end

	always_comb begin
		is_hit_missile[0] = is_hit[0][0] || is_hit[1][0] || is_hit[2][0] || is_hit[3][0] || is_hit[4][0] || is_hit[5][0] || is_hit[6][0] || is_hit[7][0] || is_hit[8][0] || is_hit[9][0];
		is_hit_missile[1] = is_hit[0][1] || is_hit[1][1] || is_hit[2][1] || is_hit[3][1] || is_hit[4][1] || is_hit[5][1] || is_hit[6][1] || is_hit[7][1] || is_hit[8][1] || is_hit[9][1];
		is_hit_missile[2] = is_hit[0][2] || is_hit[1][2] || is_hit[2][2] || is_hit[3][2] || is_hit[4][2] || is_hit[5][2] || is_hit[6][2] || is_hit[7][2] || is_hit[8][2] || is_hit[9][2];

		is_alien_total = is_alien[0] || is_alien[1] || is_alien[2] || is_alien[3] || is_alien[4] || is_alien[5] || is_alien[6] || is_alien[7] || is_alien[8] || is_alien[9];

		score = is_alien_hit[0] + is_alien_hit[1] + is_alien_hit[2] + is_alien_hit[3] + is_alien_hit[4] + is_alien_hit[5] + is_alien_hit[6] + is_alien_hit[7] + is_alien_hit[8] + is_alien_hit[9];
		is_won = (score == 'd10);
		is_lost = is_alien_oob[0] || is_alien_oob[1] || is_alien_oob[2] || is_alien_oob[3] || is_alien_oob[4] || is_alien_oob[5] || is_alien_oob[6] || is_alien_oob[7] || is_alien_oob[8] || is_alien_oob[9] || is_player_hit; 
		
		is_missile_total = is_missile[0] || is_missile[1] || is_missile[2] || is_alien_missile[0] || is_alien_missile[1] || is_alien_missile[2] || is_alien_missile[3] || is_alien_missile[4] || is_alien_missile[5] || is_alien_missile[6] || is_alien_missile[7] || is_alien_missile[8] || is_alien_missile[9];

		is_player_hit_in = is_hit_player[0] || is_hit_player[1] || is_hit_player[2] || is_hit_player[3] || is_hit_player[4] || is_hit_player[5] || is_hit_player[6] || is_hit_player[7] || is_hit_player[8] || is_hit_player[9];
	end

	// Color Mapper
	color_mapper color_instance( .*, .is_missile(is_missile_total), .is_alien(is_alien_total), .end_game_won(is_won), .end_game_lost(is_lost));

	// Player
	player player_inst(.*);

	// Missiles
	
	missile_control missile_controller(.*);
									
	player_projectile missile0(.*, .shoot(shoot && (missile_select == 2'd0)), .is_hit(is_hit_missile[0]), .is_missile(is_missile[0]), .projectile_y_pos(projectile_y_pos[0]), .projectile_x_pos(projectile_x_pos[0]));

	player_projectile missile1(.*, .shoot(shoot && (missile_select == 2'd1)), .is_hit(is_hit_missile[1]), .is_missile(is_missile[1]), .projectile_y_pos(projectile_y_pos[1]), .projectile_x_pos(projectile_x_pos[1]));

	player_projectile missile2(.*, .shoot(shoot && (missile_select == 2'd2)), .is_hit(is_hit_missile[2]), .is_missile(is_missile[2]), .projectile_y_pos(projectile_y_pos[2]), .projectile_x_pos(projectile_x_pos[2]));

	// Aliens

	alien alien0(.*, .is_hit(is_hit[0][0] || is_hit[0][1] || is_hit[0][2]), .init_direction(1'b1), .alien_x_start(10'd20), .alien_y_start(10'd20), .is_alien(is_alien[0]), .alien_x_pos(alien_x_pos[0]), .alien_y_pos(alien_y_pos[0]), .is_alien_hit(is_alien_hit[0]), .is_alien_oob(is_alien_oob[0]));

	alien alien1(.*, .is_hit(is_hit[1][0] || is_hit[1][1] || is_hit[1][2]), .init_direction(1'b1), .alien_x_start(10'd80), .alien_y_start(10'd20), .is_alien(is_alien[1]), .alien_x_pos(alien_x_pos[1]), .alien_y_pos(alien_y_pos[1]), .is_alien_hit(is_alien_hit[1]), .is_alien_oob(is_alien_oob[1]));
						
	alien alien2(.*, .is_hit(is_hit[2][0] || is_hit[2][1] || is_hit[2][2]), .init_direction(1'b1), .alien_x_start(10'd140), .alien_y_start(10'd20), .is_alien(is_alien[2]), .alien_x_pos(alien_x_pos[2]), .alien_y_pos(alien_y_pos[2]), .is_alien_hit(is_alien_hit[2]), .is_alien_oob(is_alien_oob[2]));
						
	alien alien3(.*, .is_hit(is_hit[3][0] || is_hit[3][0] || is_hit[3][2]), .init_direction(1'b1), .alien_x_start(10'd200), .alien_y_start(10'd20), .is_alien(is_alien[3]), .alien_x_pos(alien_x_pos[3]), .alien_y_pos(alien_y_pos[3]), .is_alien_hit(is_alien_hit[3]), .is_alien_oob(is_alien_oob[3]));	
    
	alien alien4(.*, .is_hit(is_hit[4][0] || is_hit[4][1] || is_hit[4][2]), .init_direction(1'b1), .alien_x_start(10'd260), .alien_y_start(10'd20), .is_alien(is_alien[4]), .alien_x_pos(alien_x_pos[4]), .alien_y_pos(alien_y_pos[4]), .is_alien_hit(is_alien_hit[4]), .is_alien_oob(is_alien_oob[4]));
						
	alien alien5(.*, .is_hit(is_hit[5][0] || is_hit[5][1] || is_hit[5][2]), .init_direction(1'b1), .alien_x_start(10'd320), .alien_y_start(10'd20), .is_alien(is_alien[5]), .alien_x_pos(alien_x_pos[5]), .alien_y_pos(alien_y_pos[5]), .is_alien_hit(is_alien_hit[5]), .is_alien_oob(is_alien_oob[5]));
						
	alien alien6(.*, .is_hit(is_hit[6][0] || is_hit[6][1] || is_hit[6][2]), .init_direction(1'b1), .alien_x_start(10'd380), .alien_y_start(10'd20), .is_alien(is_alien[6]), .alien_x_pos(alien_x_pos[6]), .alien_y_pos(alien_y_pos[6]), .is_alien_hit(is_alien_hit[6]), .is_alien_oob(is_alien_oob[6]));
						
	alien alien7(.*, .is_hit(is_hit[7][0] || is_hit[7][1] || is_hit[7][2]), .init_direction(1'b1), .alien_x_start(10'd440), .alien_y_start(10'd20), .is_alien(is_alien[7]), .alien_x_pos(alien_x_pos[7]), .alien_y_pos(alien_y_pos[7]), .is_alien_hit(is_alien_hit[7]), .is_alien_oob(is_alien_oob[7]));
						
	alien alien8(.*, .is_hit(is_hit[8][0] || is_hit[8][1] || is_hit[8][2]), .init_direction(1'b1), .alien_x_start(10'd500), .alien_y_start(10'd20), .is_alien(is_alien[8]), .alien_x_pos(alien_x_pos[8]), .alien_y_pos(alien_y_pos[8]), .is_alien_hit(is_alien_hit[8]), .is_alien_oob(is_alien_oob[8]));
						
	alien alien9(.*, .is_hit(is_hit[9][0] || is_hit[9][1] || is_hit[9][2]), .init_direction(1'b1), .alien_x_start(10'd560), .alien_y_start(10'd20), .is_alien(is_alien[9]), .alien_x_pos(alien_x_pos[9]), .alien_y_pos(alien_y_pos[9]), .is_alien_hit(is_alien_hit[9]), .is_alien_oob(is_alien_oob[9]));

	logic [7:0] pseudo[10];
	
	lsfr rand0(.Clk(frame_clk), .Reset, .seed(231), .q(pseudo[0]);
	lsfr rand1(.Clk(frame_clk), .Reset, .seed(21), .q(pseudo[1]);
	lsfr rand2(.Clk(frame_clk), .Reset, .seed(31), .q(pseudo[2]);
	lsfr rand3(.Clk(frame_clk), .Reset, .seed(23), .q(pseudo[3]);
	lsfr rand4(.Clk(frame_clk), .Reset, .seed(1), .q(pseudo[4]);
	lsfr rand5(.Clk(frame_clk), .Reset, .seed(88), .q(pseudo[5]);
	lsfr rand6(.Clk(frame_clk), .Reset, .seed(22), .q(pseudo[6]);
	lsfr rand7(.Clk(frame_clk), .Reset, .seed(63), .q(pseudo[7]);
	lsfr rand8(.Clk(frame_clk), .Reset, .seed(90), .q(pseudo[8]);
	lsfr rand9(.Clk(frame_clk), .Reset, .seed(131), .q(pseudo[9]);

	always_ff @ (posedge frame_clk) begin
		alien_shoot_signal[0] <= (pseudo[0] == 1);
		alien_shoot_signal[1] <= (pseudo[1] == 1);
		alien_shoot_signal[2] <= (pseudo[2] == 1);
		alien_shoot_signal[3] <= (pseudo[3] == 1);
		alien_shoot_signal[4] <= (pseudo[4] == 1);
		alien_shoot_signal[5] <= (pseudo[5] == 1);
		alien_shoot_signal[6] <= (pseudo[6] == 1);
		alien_shoot_signal[7] <= (pseudo[7] == 1);
		alien_shoot_signal[8] <= (pseudo[8] == 1);
		alien_shoot_signal[9] <= (pseudo[9] == 1);
	end

	
		// Alien missiles

	alien_projectile alien_missile0(.*,.alien_x_pos(alien_x_pos[0]), .alien_y_pos(alien_y_pos[0]),  .shoot(alien_shoot_signal[0] && !is_alien_hit[0]), .is_hit(is_hit_player[0]), .is_missile(is_alien_missile[0]), .projectile_y_pos(alien_projectile_y_pos[0]), .projectile_x_pos(alien_projectile_x_pos[0]));
                                      
	alien_projectile alien_missile1(.*,.alien_x_pos(alien_x_pos[1]), .alien_y_pos(alien_y_pos[1]),  .shoot(alien_shoot_signal[1] && !is_alien_hit[1]), .is_hit(is_hit_player[1]), .is_missile(is_alien_missile[1]), .projectile_y_pos(alien_projectile_y_pos[1]), .projectile_x_pos(alien_projectile_x_pos[1]));
                                      
	alien_projectile alien_missile2(.*,.alien_x_pos(alien_x_pos[2]), .alien_y_pos(alien_y_pos[2]),  .shoot(alien_shoot_signal[2] && !is_alien_hit[2]), .is_hit(is_hit_player[2]), .is_missile(is_alien_missile[2]), .projectile_y_pos(alien_projectile_y_pos[2]), .projectile_x_pos(alien_projectile_x_pos[2]));
                                      
	alien_projectile alien_missile3(.*,.alien_x_pos(alien_x_pos[3]), .alien_y_pos(alien_y_pos[3]),  .shoot(alien_shoot_signal[3] && !is_alien_hit[3]), .is_hit(is_hit_player[3]), .is_missile(is_alien_missile[3]), .projectile_y_pos(alien_projectile_y_pos[3]), .projectile_x_pos(alien_projectile_x_pos[3]));
                                      
	alien_projectile alien_missile4(.*,.alien_x_pos(alien_x_pos[4]), .alien_y_pos(alien_y_pos[4]),  .shoot(alien_shoot_signal[4] && !is_alien_hit[4]), .is_hit(is_hit_player[4]), .is_missile(is_alien_missile[4]), .projectile_y_pos(alien_projectile_y_pos[4]), .projectile_x_pos(alien_projectile_x_pos[4]));
                                      
	alien_projectile alien_missile5(.*,.alien_x_pos(alien_x_pos[5]), .alien_y_pos(alien_y_pos[5]),  .shoot(alien_shoot_signal[5] && !is_alien_hit[5]), .is_hit(is_hit_player[5]), .is_missile(is_alien_missile[5]), .projectile_y_pos(alien_projectile_y_pos[5]), .projectile_x_pos(alien_projectile_x_pos[5]));
                                      
	alien_projectile alien_missile6(.*,.alien_x_pos(alien_x_pos[6]), .alien_y_pos(alien_y_pos[6]),  .shoot(alien_shoot_signal[6] && !is_alien_hit[6]), .is_hit(is_hit_player[6]), .is_missile(is_alien_missile[6]), .projectile_y_pos(alien_projectile_y_pos[6]), .projectile_x_pos(alien_projectile_x_pos[6]));
                                      
	alien_projectile alien_missile7(.*,.alien_x_pos(alien_x_pos[7]), .alien_y_pos(alien_y_pos[7]),  .shoot(alien_shoot_signal[7] && !is_alien_hit[7]), .is_hit(is_hit_player[7]), .is_missile(is_alien_missile[7]), .projectile_y_pos(alien_projectile_y_pos[7]), .projectile_x_pos(alien_projectile_x_pos[7]));
                                      
	alien_projectile alien_missile8(.*,.alien_x_pos(alien_x_pos[8]), .alien_y_pos(alien_y_pos[8]),  .shoot(alien_shoot_signal[8] && !is_alien_hit[8]), .is_hit(is_hit_player[8]), .is_missile(is_alien_missile[8]), .projectile_y_pos(alien_projectile_y_pos[8]), .projectile_x_pos(alien_projectile_x_pos[8]));
                                      
	alien_projectile alien_missile9(.*,.alien_x_pos(alien_x_pos[9]), .alien_y_pos(alien_y_pos[9]),  .shoot(alien_shoot_signal[9] && !is_alien_hit[9]), .is_hit(is_hit_player[9]), .is_missile(is_alien_missile[9]), .projectile_y_pos(alien_projectile_y_pos[9]), .projectile_x_pos(alien_projectile_x_pos[9]));
	// Hitboxes
	// alien missile hitboxes
	hitbox hitbox_player_detector0(.target1_x_pos(alien_projectile_x_pos[0]), .target1_y_pos(alien_projectile_y_pos[0]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[0]));

	hitbox hitbox_player_detector1(.target1_x_pos(alien_projectile_x_pos[1]), .target1_y_pos(alien_projectile_y_pos[1]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[1]));

	hitbox hitbox_player_detector2(.target1_x_pos(alien_projectile_x_pos[2]), .target1_y_pos(alien_projectile_y_pos[2]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[2]));

	hitbox hitbox_player_detector3(.target1_x_pos(alien_projectile_x_pos[3]), .target1_y_pos(alien_projectile_y_pos[3]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[3]));

	hitbox hitbox_player_detector4(.target1_x_pos(alien_projectile_x_pos[4]), .target1_y_pos(alien_projectile_y_pos[4]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[4]));

	hitbox hitbox_player_detector5(.target1_x_pos(alien_projectile_x_pos[5]), .target1_y_pos(alien_projectile_y_pos[5]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[5]));

	hitbox hitbox_player_detector6(.target1_x_pos(alien_projectile_x_pos[6]), .target1_y_pos(alien_projectile_y_pos[6]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[6]));

	hitbox hitbox_player_detector7(.target1_x_pos(alien_projectile_x_pos[7]), .target1_y_pos(alien_projectile_y_pos[7]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[7]));

	hitbox hitbox_player_detector8(.target1_x_pos(alien_projectile_x_pos[8]), .target1_y_pos(alien_projectile_y_pos[8]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[8]));

	hitbox hitbox_player_detector9(.target1_x_pos(alien_projectile_x_pos[9]), .target1_y_pos(alien_projectile_y_pos[9]), .target2_x_pos(player_x_pos), .target2_y_pos(player_y_pos), .threshold(hitbox_threshold), .is_hit(is_hit_player[9]));
	 
	// Alien0
	hitbox hitbox_detector00(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[0]), .target2_y_pos(alien_y_pos[0]), .threshold(hitbox_threshold), .is_hit(is_hit[0][0]));

	hitbox hitbox_detector01(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[0]), .target2_y_pos(alien_y_pos[0]), .threshold(hitbox_threshold), .is_hit(is_hit[0][1]));

	hitbox hitbox_detector02(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[0]), .target2_y_pos(alien_y_pos[0]), .threshold(hitbox_threshold), .is_hit(is_hit[0][2]));

	// Alien1
	hitbox hitbox_detector10(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[1]), .target2_y_pos(alien_y_pos[1]), .threshold(hitbox_threshold), .is_hit(is_hit[1][0]));

	hitbox hitbox_detector11(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[1]), .target2_y_pos(alien_y_pos[1]), .threshold(hitbox_threshold), .is_hit(is_hit[1][1]));

	hitbox hitbox_detector12(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[1]), .target2_y_pos(alien_y_pos[1]), .threshold(hitbox_threshold), .is_hit(is_hit[1][2]));

	// Alien2
	hitbox hitbox_detector20(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[2]), .target2_y_pos(alien_y_pos[2]), .threshold(hitbox_threshold), .is_hit(is_hit[2][0]));

	hitbox hitbox_detector21(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[2]), .target2_y_pos(alien_y_pos[2]), .threshold(hitbox_threshold), .is_hit(is_hit[2][1]));

	hitbox hitbox_detector22(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[2]), .target2_y_pos(alien_y_pos[2]), .threshold(hitbox_threshold), .is_hit(is_hit[2][2]));

	// Alien3
	hitbox hitbox_detector30(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[3]), .target2_y_pos(alien_y_pos[3]), .threshold(hitbox_threshold), .is_hit(is_hit[3][0]));

	hitbox hitbox_detector31(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[3]), .target2_y_pos(alien_y_pos[3]), .threshold(hitbox_threshold), .is_hit(is_hit[3][1]));

	hitbox hitbox_detector32(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[3]), .target2_y_pos(alien_y_pos[3]), .threshold(hitbox_threshold), .is_hit(is_hit[3][2]));

	// Alien4
	hitbox hitbox_detector40(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[4]), .target2_y_pos(alien_y_pos[4]), .threshold(hitbox_threshold), .is_hit(is_hit[4][0]));

	hitbox hitbox_detector41(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[4]), .target2_y_pos(alien_y_pos[4]), .threshold(hitbox_threshold), .is_hit(is_hit[4][1]));

	hitbox hitbox_detector42(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[4]), .target2_y_pos(alien_y_pos[4]), .threshold(hitbox_threshold), .is_hit(is_hit[4][2]));

	// Alien5
	hitbox hitbox_detector50(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[5]), .target2_y_pos(alien_y_pos[5]), .threshold(hitbox_threshold), .is_hit(is_hit[5][0]));

	hitbox hitbox_detector51(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[5]), .target2_y_pos(alien_y_pos[5]), .threshold(hitbox_threshold), .is_hit(is_hit[5][1]));

	hitbox hitbox_detector52(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[5]), .target2_y_pos(alien_y_pos[5]), .threshold(hitbox_threshold), .is_hit(is_hit[5][2]));

	// Alien6
	hitbox hitbox_detector60(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[6]), .target2_y_pos(alien_y_pos[6]), .threshold(hitbox_threshold), .is_hit(is_hit[6][0]));

	hitbox hitbox_detector61(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[6]), .target2_y_pos(alien_y_pos[6]), .threshold(hitbox_threshold), .is_hit(is_hit[6][1]));

	hitbox hitbox_detector62(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[6]), .target2_y_pos(alien_y_pos[6]), .threshold(hitbox_threshold), .is_hit(is_hit[6][2]));

	// Alien7
	hitbox hitbox_detector70(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[7]), .target2_y_pos(alien_y_pos[7]), .threshold(hitbox_threshold), .is_hit(is_hit[7][0]));

	hitbox hitbox_detector71(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[7]), .target2_y_pos(alien_y_pos[7]), .threshold(hitbox_threshold), .is_hit(is_hit[7][1]));

	hitbox hitbox_detector72(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[7]), .target2_y_pos(alien_y_pos[7]), .threshold(hitbox_threshold), .is_hit(is_hit[7][2]));

	// Alien8
	hitbox hitbox_detector80(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[8]), .target2_y_pos(alien_y_pos[8]), .threshold(hitbox_threshold), .is_hit(is_hit[8][0]));

	hitbox hitbox_detector81(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[8]), .target2_y_pos(alien_y_pos[8]), .threshold(hitbox_threshold), .is_hit(is_hit[8][1]));

	hitbox hitbox_detector82(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[8]), .target2_y_pos(alien_y_pos[8]), .threshold(hitbox_threshold), .is_hit(is_hit[8][2]));

	// Alien9
	hitbox hitbox_detector90(.target1_x_pos(projectile_x_pos[0]), .target1_y_pos(projectile_y_pos[0]), .target2_x_pos(alien_x_pos[9]), .target2_y_pos(alien_y_pos[9]), .threshold(hitbox_threshold), .is_hit(is_hit[9][0]));

	hitbox hitbox_detector91(.target1_x_pos(projectile_x_pos[1]), .target1_y_pos(projectile_y_pos[1]), .target2_x_pos(alien_x_pos[9]), .target2_y_pos(alien_y_pos[9]), .threshold(hitbox_threshold), .is_hit(is_hit[9][1]));

	hitbox hitbox_detector92(.target1_x_pos(projectile_x_pos[2]), .target1_y_pos(projectile_y_pos[2]), .target2_x_pos(alien_x_pos[9]), .target2_y_pos(alien_y_pos[9]), .threshold(hitbox_threshold), .is_hit(is_hit[9][2]));

endmodule
