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
    
   logic reset_h, Clk, shoot, shoot_in, left, right, right_in, left_in;
   logic [7:0] keycode;
	logic [9:0] DrawX, DrawY;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        reset_h <= ~(KEY[0]);        // The push buttons are active low
		  shoot <= shoot_in;
		  left <= left_in;
		  right <= right_in;
    end

	always_comb begin
		shoot_in = ~(KEY[3]) || (keycode == 8'd44); 
		left_in = ~(KEY[2]) || (keycode == 8'd80);
		right_in = ~(KEY[1]) || (keycode == 8'd79);
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

	
	logic is_lost, is_won, is_lost_lev[3], is_won_lev[3]; 
	int score, score_lev[3];
	logic [1:0] level, color_mapper_select;

	logic [7:0] VGA_R_LEV[4], VGA_G_LEV[4], VGA_B_LEV[4];
	logic level_reset;

	int_driver int_driver_0 (score % 10, HEX0);
	int_driver int_driver_1 (score / 10, HEX1);

	state_machine states(.*, .Reset(reset_h));

	always_comb begin
		VGA_R = VGA_R_LEV[color_mapper_select];
		VGA_G = VGA_G_LEV[color_mapper_select];
		VGA_B = VGA_B_LEV[color_mapper_select];
		score = score_lev[level];
		is_won = is_won_lev[level];
		is_lost = is_lost_lev[level];
	end
	 
	level_1 level_1_instance(.*, .reset_h(reset_h || level_reset), .VGA_R(VGA_R_LEV[0]), .VGA_G(VGA_G_LEV[0]), .VGA_B(VGA_B_LEV[0]), .is_lost(is_lost_lev[0]), .is_won(is_won_lev[0]), .score(score_lev[0]));

	level_2 level_2_instance(.*, .Reset(reset_h || level_reset), .frame_clk(VGA_VS), .VGA_R(VGA_R_LEV[1]), .VGA_G(VGA_G_LEV[1]), .VGA_B(VGA_B_LEV[1]), .is_lost(is_lost_lev[1]), .is_won(is_won_lev[1]), .score(score_lev[1]));

	level_3 level_3_instance(.*, .Reset(reset_h || level_reset), .frame_clk(VGA_VS), .VGA_R(VGA_R_LEV[2]), .VGA_G(VGA_G_LEV[2]), .VGA_B(VGA_B_LEV[2]), .is_lost(is_lost_lev[2]), .is_won(is_won_lev[2]), .score(score_lev[2]));
	 
	color_mapper_end endgame_mapper(.*,.VGA_R(VGA_R_LEV[3]), .VGA_G(VGA_G_LEV[3]), .VGA_B(VGA_B_LEV[3]));
	
endmodule
