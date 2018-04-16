//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module space_invaders( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
	parameter hitbox_threshold = 10'd20;
    logic reset_h, Clk, shoot, shoot_in, left, right;
    logic [7:0] keycode;
	logic [9:0] DrawX, DrawY;
	logic is_player;
    logic [9:0] player_x_pos, player_y_pos;
	logic [9:0] projectile_y_pos[3], projectile_x_pos[3];

	logic is_hit[10][3], is_alien[10], is_missile[3], is_alien_hit[10];
	logic [9:0] alien_x_pos[10], alien_y_pos[10];

	logic is_hit_total, is_alien_total, is_missile_total;
	logic is_hit_missile[3];
	logic end_game_hits, end_game_boundary;

	logic [1:0] missile_select;
	
	int score;
	
	always_comb begin
		is_hit_missile[0] = is_hit[0][0] || is_hit[1][0] || is_hit[2][0] || is_hit[3][0] || is_hit[4][0] || is_hit[5][0] || is_hit[6][0] || is_hit[7][0] || is_hit[8][0] || is_hit[9][0];
		is_hit_missile[1] = is_hit[0][1] || is_hit[1][1] || is_hit[2][1] || is_hit[3][1] || is_hit[4][1] || is_hit[5][1] || is_hit[6][1] || is_hit[7][1] || is_hit[8][1] || is_hit[9][1];
		is_hit_missile[2] = is_hit[0][2] || is_hit[1][2] || is_hit[2][2] || is_hit[3][2] || is_hit[4][2] || is_hit[5][2] || is_hit[6][2] || is_hit[7][2] || is_hit[8][2] || is_hit[9][2];

		is_hit_total = is_hit_missile[0] || is_hit_missile[1] || is_hit_missile[2];

		is_alien_total = is_alien[0] || is_alien[1] || is_alien[2] || is_alien[3] || is_alien[4] || is_alien[5] || is_alien[6] || is_alien[7] || is_alien[8] || is_alien[9];

		// FIXME: Use alien outputs
		score = is_alien_hit[0] + is_alien_hit[1] + is_alien_hit[2] + is_alien_hit[3] + is_alien_hit[4] + is_alien_hit[5] + is_alien_hit[6] + is_alien_hit[7] + is_alien_hit[8] + is_alien_hit[9];
		end_game_hits = (score == 'd10);
		is_missile_total = is_missile[0] || is_missile[1] || is_missile[2];
	end
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        reset_h <= ~(KEY[0]);        // The push buttons are active low
		  shoot <= shoot_in;
		  left <= ~(KEY[2]);
		  right <= ~(KEY[1]);
    end

	always_comb begin
		shoot_in = ~(KEY[3]) || (keycode == 8'd44); 
	end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     final_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    VGA_controller vga_controller_instance(.Clk,         // 50 MHz clock
                                           .Reset(reset_h),       // Active-high reset signal
										   .VGA_HS,      // Horizontal sync pulse.  Active low
                                           .VGA_VS,      // Vertical sync pulse.  Active low
										   .VGA_CLK,     // 25 MHz VGA clock input
										   .VGA_BLANK_N, // Blanking interval indicator.  Active low.
                                           .VGA_SYNC_N,  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
										   .DrawX,       // horizontal coordinate
                                           .DrawY);

	// Player
	 
	player player_instance(.Clk,
							.Reset(reset_h),
							.frame_clk(VGA_VS),
							.keycode,
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

	alien alien0(.Clk, .Reset(reset_h), .is_hit(is_hit[0][0] || is_hit[0][1] || is_hit[0][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd20), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[0]), .alien_x_pos(alien_x_pos[0]), .alien_y_pos(alien_y_pos[0]), .is_alien_hit(is_alien_hit[0]));
    
	alien alien1(.Clk, .Reset(reset_h), .is_hit(is_hit[1][0] || is_hit[1][1] || is_hit[1][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd40), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[1]), .alien_x_pos(alien_x_pos[1]), .alien_y_pos(alien_y_pos[1]), .is_alien_hit(is_alien_hit[1]));
						
	alien alien2(.Clk, .Reset(reset_h), .is_hit(is_hit[2][0] || is_hit[2][1] || is_hit[2][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd60), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[2]), .alien_x_pos(alien_x_pos[2]), .alien_y_pos(alien_y_pos[2]), .is_alien_hit(is_alien_hit[2]));
						
	alien alien3(.Clk, .Reset(reset_h), .is_hit(is_hit[3][0] || is_hit[3][0] || is_hit[3][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd80), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[3]), .alien_x_pos(alien_x_pos[3]), .alien_y_pos(alien_y_pos[3]), .is_alien_hit(is_alien_hit[3]));					
    
	alien alien4(.Clk, .Reset(reset_h), .is_hit(is_hit[4][0] || is_hit[4][1] || is_hit[4][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd100), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[4]), .alien_x_pos(alien_x_pos[4]), .alien_y_pos(alien_y_pos[4]), .is_alien_hit(is_alien_hit[4]));
						
	alien alien5(.Clk, .Reset(reset_h), .is_hit(is_hit[5][0] || is_hit[5][1] || is_hit[5][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd120), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[5]), .alien_x_pos(alien_x_pos[5]), .alien_y_pos(alien_y_pos[5]), .is_alien_hit(is_alien_hit[5]));
						
	alien alien6(.Clk, .Reset(reset_h), .is_hit(is_hit[6][0] || is_hit[6][1] || is_hit[6][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd140), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[6]), .alien_x_pos(alien_x_pos[6]), .alien_y_pos(alien_y_pos[6]), .is_alien_hit(is_alien_hit[6]));
						
	alien alien7(.Clk, .Reset(reset_h), .is_hit(is_hit[7][0] || is_hit[7][1] || is_hit[7][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd160), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[7]), .alien_x_pos(alien_x_pos[7]), .alien_y_pos(alien_y_pos[7]), .is_alien_hit(is_alien_hit[7]));
						
	alien alien8(.Clk, .Reset(reset_h), .is_hit(is_hit[8][0] || is_hit[8][1] || is_hit[8][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd180), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[8]), .alien_x_pos(alien_x_pos[8]), .alien_y_pos(alien_y_pos[8]), .is_alien_hit(is_alien_hit[8]));
						
	alien alien9(.Clk, .Reset(reset_h), .is_hit(is_hit[9][0] || is_hit[9][1] || is_hit[9][2]), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd200), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien[9]), .alien_x_pos(alien_x_pos[9]), .alien_y_pos(alien_y_pos[9]), .is_alien_hit(is_alien_hit[9]));

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
								 .end_game(end_game_hits),
                         .DrawX, 
								 .DrawY,
								 .VGA_R, 
								 .VGA_G, 
								 .VGA_B
	 );
    
    // Display keycode on hex display
	 /*
    HexDriver hex_inst_0 (4'b0, HEX0);
    HexDriver hex_inst_1 (4'b0, HEX1);
	 */
	 int_driver int_driver_0 (score % 10, HEX0);
	 int_driver int_driver_1 (score / 10, HEX1);
endmodule
