module color_mapper_end (input is_won, is_lost,                                //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    always_comb
    begin
		 if(is_won)
		 begin
				Red = 8'h7f - {1'b0, DrawX[9:3]}; 
				Green = 8'hb0;
				Blue = 8'h8a;
		 end
		 else
		 begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
		 end
	 end 

endmodule