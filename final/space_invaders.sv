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
    
    logic reset_h, Clk, shoot, left, right, is_hit;
    logic [7:0] keycode;
	 logic [9:0] DrawX, DrawY;
	 logic is_player, is_missile, is_showing, is_alien;
    logic [9:0] player_X_Pos, player_Y_Pos, alien_X_Pos, alien_Y_Pos;
	 logic [9:0] projectile_y_pos, projectile_x_pos;
	 
	 logic [9:0] alien_X_Pos_2, alien_Y_Pos_2;
	 logic is_hit_2, is_alien_2;
	 
	 logic [9:0] alien_X_Pos_3, alien_Y_Pos_3;
	 logic is_hit_3, is_alien_3;
	 
	 logic [9:0] alien_X_Pos_4, alien_Y_Pos_4;
	 logic is_hit_4, is_alien_4;
	 
	 logic [9:0] alien_X_Pos_5, alien_Y_Pos_5;
	 logic is_hit_5, is_alien_5;
	 
	 logic [9:0] alien_X_Pos_6, alien_Y_Pos_6;
	 logic is_hit_6, is_alien_6;
	 
	 logic [9:0] alien_X_Pos_7, alien_Y_Pos_7;
	 logic is_hit_7, is_alien_7;
	 
	 logic [9:0] alien_X_Pos_8, alien_Y_Pos_8;
	 logic is_hit_8, is_alien_8;
	 
	 logic [9:0] alien_X_Pos_9, alien_Y_Pos_9;
	 logic is_hit_9, is_alien_9;
	 
	 logic [9:0] alien_X_Pos_10, alien_Y_Pos_10;
	 logic is_hit_10, is_alien_10;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        reset_h <= ~(KEY[0]);        // The push buttons are active low
		  shoot <= ~(KEY[3]);
		  left <= ~(KEY[2]);
		  right <= ~(KEY[1]);
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
    
    // TODO: Fill in the connections for the rest of the modules 
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
	 
	 player player_instance(.Clk,
									.Reset(reset_h),
									.frame_clk(VGA_VS),
									.keycode,
									.DrawX,
									.DrawY,
									.left,
									.right,
									.player_X_Pos,
									.player_Y_Pos,
									.is_player);
									
	player_projectile missile(.Clk, .shoot, .is_hit(is_hit || is_hit_2 || is_hit_3 || is_hit_4 || is_hit_5 || is_hit_6 || is_hit_7 || is_hit_8 || is_hit_9 || is_hit_10), .Reset(reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY,
							 .player_x_pos(player_X_Pos), .player_y_pos(player_Y_Pos), .keycode, .is_missile, .is_showing, .projectile_y_pos, .projectile_x_pos);

	alien alien1(.Clk, .Reset(reset_h), .is_hit, .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd20), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien, 
						.alien_x_pos(alien_X_Pos), .alien_y_pos(alien_Y_Pos));
    
	 alien alien2(.Clk, .Reset(reset_h), .is_hit(is_hit_2), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd40), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_2), 
						.alien_x_pos(alien_X_Pos_2), .alien_y_pos(alien_Y_Pos_2));
						
	alien alien3(.Clk, .Reset(reset_h), .is_hit(is_hit_3), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd60), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_3), 
						.alien_x_pos(alien_X_Pos_3), .alien_y_pos(alien_Y_Pos_3));
						
	alien alien4(.Clk, .Reset(reset_h), .is_hit(is_hit_4), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd80), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_4), 
						.alien_x_pos(alien_X_Pos_4), .alien_y_pos(alien_Y_Pos_4));					
    
	 alien alien5(.Clk, .Reset(reset_h), .is_hit(is_hit_5), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd100), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_5), 
						.alien_x_pos(alien_X_Pos_5), .alien_y_pos(alien_Y_Pos_5));
						
	alien alien6(.Clk, .Reset(reset_h), .is_hit(is_hit_6), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd120), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_6), 
						.alien_x_pos(alien_X_Pos_6), .alien_y_pos(alien_Y_Pos_6));
						
	alien alien7(.Clk, .Reset(reset_h), .is_hit(is_hit_7), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd140), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_7), 
						.alien_x_pos(alien_X_Pos_7), .alien_y_pos(alien_Y_Pos_7));
						
	alien alien8(.Clk, .Reset(reset_h), .is_hit(is_hit_8), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd160), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_8), 
						.alien_x_pos(alien_X_Pos_8), .alien_y_pos(alien_Y_Pos_8));
						
	alien alien9(.Clk, .Reset(reset_h), .is_hit(is_hit_9), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd180), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_9), 
						.alien_x_pos(alien_X_Pos_9), .alien_y_pos(alien_Y_Pos_9));
						
						
	alien alien10(.Clk, .Reset(reset_h), .is_hit(is_hit_10), .frame_clk(VGA_VS), .init_direction(1'b1), .alien_x_start(10'd200), .alien_y_start(10'd20), .DrawX, .DrawY, .is_alien(is_alien_10), 
						.alien_x_pos(alien_X_Pos_10), .alien_y_pos(alien_Y_Pos_10));
	 
	 hitbox hitbox_detector(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos)
										, .target2_y_pos(alien_Y_Pos), .threshold(10'd20), .is_hit);
										
	hitbox hitbox_detector_2(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_2)
										, .target2_y_pos(alien_Y_Pos_2), .threshold(10'd20), .is_hit(is_hit_2));
										
	hitbox hitbox_detector_3(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_3)
										, .target2_y_pos(alien_Y_Pos_3), .threshold(10'd20), .is_hit(is_hit_3));
										
	hitbox hitbox_detector_4(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_4)
										, .target2_y_pos(alien_Y_Pos_4), .threshold(10'd20), .is_hit(is_hit_4));
										
										
	hitbox hitbox_detector_5(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_5)
										, .target2_y_pos(alien_Y_Pos_5), .threshold(10'd20), .is_hit(is_hit_5));
										
	hitbox hitbox_detector_6(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_6)
										, .target2_y_pos(alien_Y_Pos_6), .threshold(10'd20), .is_hit(is_hit_6));
										
										
	hitbox hitbox_detector_7(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_7)
										, .target2_y_pos(alien_Y_Pos_7), .threshold(10'd20), .is_hit(is_hit_7));
										
	hitbox hitbox_detector_8(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_8)
										, .target2_y_pos(alien_Y_Pos_8), .threshold(10'd20), .is_hit(is_hit_8));
										
	hitbox hitbox_detector_9(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_9)
										, .target2_y_pos(alien_Y_Pos_9), .threshold(10'd20), .is_hit(is_hit_9));
									
	hitbox hitbox_detector_10(.target1_x_pos(projectile_x_pos), .target1_y_pos(projectile_y_pos), .target2_x_pos(alien_X_Pos_10)
										, .target2_y_pos(alien_Y_Pos_10), .threshold(10'd20), .is_hit(is_hit_10));
	 
	 color_mapper color_instance( .is_player,            // Whether current pixel belongs to ball 
											.is_missile,
											.is_alien(is_alien || is_alien_2 || is_alien_3 || is_alien_4 || is_alien_5 || is_alien_6 || is_alien_7 || is_alien_8 || is_alien_9 || is_alien_10),
                                 .DrawX, 
										   .DrawY,       // Current pixel coordinates
											.VGA_R, 
											.VGA_G, 
											.VGA_B
	 );
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (4'b0, HEX0);
    HexDriver hex_inst_1 (4'b0, HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
