module level_1(input reset_h, Clk, shoot, left, right, VGA_VS,
					input [9:0] DrawX, DrawY,
					output [7:0] VGA_R, VGA_G, VGA_B,
					output is_lost, is_won,
					output int score);
	
	parameter hitbox_threshold = 10'd20;
	
	logic is_player;
   logic [9:0] player_x_pos, player_y_pos;
	logic [9:0] projectile_y_pos[3], projectile_x_pos[3];

	logic is_hit[10][3], is_alien[10], is_missile[3], is_alien_hit[10], is_alien_oob[10];
	logic [9:0] alien_x_pos[10], alien_y_pos[10];

	logic is_hit_total, is_alien_total, is_missile_total;
	logic is_hit_missile[3];

	logic [1:0] missile_select;
	
	always_comb begin
		is_hit_missile[0] = is_hit[0][0] || is_hit[1][0] || is_hit[2][0] || is_hit[3][0] || is_hit[4][0] || is_hit[5][0] || is_hit[6][0] || is_hit[7][0] || is_hit[8][0] || is_hit[9][0];
		is_hit_missile[1] = is_hit[0][1] || is_hit[1][1] || is_hit[2][1] || is_hit[3][1] || is_hit[4][1] || is_hit[5][1] || is_hit[6][1] || is_hit[7][1] || is_hit[8][1] || is_hit[9][1];
		is_hit_missile[2] = is_hit[0][2] || is_hit[1][2] || is_hit[2][2] || is_hit[3][2] || is_hit[4][2] || is_hit[5][2] || is_hit[6][2] || is_hit[7][2] || is_hit[8][2] || is_hit[9][2];

		is_alien_total = is_alien[0] || is_alien[1] || is_alien[2] || is_alien[3] || is_alien[4] || is_alien[5] || is_alien[6] || is_alien[7] || is_alien[8] || is_alien[9];

		score = is_alien_hit[0] + is_alien_hit[1] + is_alien_hit[2] + is_alien_hit[3] + is_alien_hit[4] + is_alien_hit[5] + is_alien_hit[6] + is_alien_hit[7] + is_alien_hit[8] + is_alien_hit[9];
		is_won = (score == 'd10);
		is_lost = is_alien_oob[0] || is_alien_oob[1] || is_alien_oob[2] || is_alien_oob[3] || is_alien_oob[4] || is_alien_oob[5] || is_alien_oob[6] || is_alien_oob[7] || is_alien_oob[8] || is_alien_oob[9]; 
		
		is_missile_total = is_missile[0] || is_missile[1] || is_missile[2];
	end
 
	player player_instance(.Clk,
							.Reset(reset_h),
							.frame_clk(VGA_VS),
							.DrawX,
							.DrawY,
							.left,
							.right,
							.player_x_pos,
							.player_y_pos,
							.is_player);

	// Missiles
	
	missile_control missile_controller(.Clk, .Reset(reset_h), .shoot, .missile_select);
									
	player_projectile missile0(.Clk, .shoot(shoot && (missile_select == 2'd0)), .is_hit(is_hit_missile[0]), .Reset(reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .player_x_pos, .player_y_pos, .is_missile(is_missile[0]), .projectile_y_pos(projectile_y_pos[0]), .projectile_x_pos(projectile_x_pos[0]));

	player_projectile missile1(.Clk, .shoot(shoot && (missile_select == 2'd1)), .is_hit(is_hit_missile[1]), .Reset(reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .player_x_pos, .player_y_pos, .is_missile(is_missile[1]), .projectile_y_pos(projectile_y_pos[1]), .projectile_x_pos(projectile_x_pos[1]));

	player_projectile missile2(.Clk, .shoot(shoot && (missile_select == 2'd2)), .is_hit(is_hit_missile[2]), .Reset(reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .player_x_pos, .player_y_pos, .is_missile(is_missile[2]), .projectile_y_pos(projectile_y_pos[2]), .projectile_x_pos(projectile_x_pos[2]));

	// Aliens

	alien alien0(.Clk, .Reset(reset_h), .is_hit(is_hit[0][0] || is_hit[0][1] || is_hit[0][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd20), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[0]), .alien_x_pos(alien_x_pos[0]), .alien_y_pos(alien_y_pos[0]), .is_alien_hit(is_alien_hit[0]), .is_alien_oob(is_alien_oob[0]));
    
	alien alien1(.Clk, .Reset(reset_h), .is_hit(is_hit[1][0] || is_hit[1][1] || is_hit[1][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd80), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[1]), .alien_x_pos(alien_x_pos[1]), .alien_y_pos(alien_y_pos[1]), .is_alien_hit(is_alien_hit[1]), .is_alien_oob(is_alien_oob[1]));
						
	alien alien2(.Clk, .Reset(reset_h), .is_hit(is_hit[2][0] || is_hit[2][1] || is_hit[2][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd140), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[2]), .alien_x_pos(alien_x_pos[2]), .alien_y_pos(alien_y_pos[2]), .is_alien_hit(is_alien_hit[2]), .is_alien_oob(is_alien_oob[2]));
						
	alien alien3(.Clk, .Reset(reset_h), .is_hit(is_hit[3][0] || is_hit[3][0] || is_hit[3][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd200), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[3]), .alien_x_pos(alien_x_pos[3]), .alien_y_pos(alien_y_pos[3]), .is_alien_hit(is_alien_hit[3]), .is_alien_oob(is_alien_oob[3]));					
    
	alien alien4(.Clk, .Reset(reset_h), .is_hit(is_hit[4][0] || is_hit[4][1] || is_hit[4][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd260), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[4]), .alien_x_pos(alien_x_pos[4]), .alien_y_pos(alien_y_pos[4]), .is_alien_hit(is_alien_hit[4]), .is_alien_oob(is_alien_oob[4]));
						
	alien alien5(.Clk, .Reset(reset_h), .is_hit(is_hit[5][0] || is_hit[5][1] || is_hit[5][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd320), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[5]), .alien_x_pos(alien_x_pos[5]), .alien_y_pos(alien_y_pos[5]), .is_alien_hit(is_alien_hit[5]), .is_alien_oob(is_alien_oob[5]));
						
	alien alien6(.Clk, .Reset(reset_h), .is_hit(is_hit[6][0] || is_hit[6][1] || is_hit[6][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd380), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[6]), .alien_x_pos(alien_x_pos[6]), .alien_y_pos(alien_y_pos[6]), .is_alien_hit(is_alien_hit[6]), .is_alien_oob(is_alien_oob[6]));
						
	alien alien7(.Clk, .Reset(reset_h), .is_hit(is_hit[7][0] || is_hit[7][1] || is_hit[7][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd440), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[7]), .alien_x_pos(alien_x_pos[7]), .alien_y_pos(alien_y_pos[7]), .is_alien_hit(is_alien_hit[7]), .is_alien_oob(is_alien_oob[7]));
						
	alien alien8(.Clk, .Reset(reset_h), .is_hit(is_hit[8][0] || is_hit[8][1] || is_hit[8][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd500), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[8]), .alien_x_pos(alien_x_pos[8]), .alien_y_pos(alien_y_pos[8]), .is_alien_hit(is_alien_hit[8]), .is_alien_oob(is_alien_oob[8]));
						
	alien alien9(.Clk, .Reset(reset_h), .is_hit(is_hit[9][0] || is_hit[9][1] || is_hit[9][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd560), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[9]), .alien_x_pos(alien_x_pos[9]), .alien_y_pos(alien_y_pos[9]), .is_alien_hit(is_alien_hit[9]), .is_alien_oob(is_alien_oob[9]));

	// Hitboxes
	 
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

	// Color_mapper
										
	color_mapper color_instance( .is_player,
								 .is_missile(is_missile_total),
								 .is_alien(is_alien_total),
								 .end_game_won(is_won),
								 .end_game_lost(is_lost),
                         .DrawX, 
								 .DrawY,
								 .VGA_R, 
								 .VGA_G, 
								 .VGA_B
	 );

endmodule
