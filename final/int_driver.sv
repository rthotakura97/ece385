module int_driver (input int digit,
                   output logic [6:0]  Out0);
	
	always_comb
	begin
		unique case (digit)
	 	   'd0 : Out0 = 7'b1000000; // '0'
	 	   'd1   : Out0 = 7'b1111001; // '1'
		   'd2   : Out0 = 7'b0100100; // '2'
	 	   'd3   : Out0 = 7'b0110000; // '3'
	 	   'd4   : Out0 = 7'b0011001; // '4'
		   'd5   : Out0 = 7'b0010010; // '5'
	 	   'd6   : Out0 = 7'b0000010; // '6'
	 	   'd7   : Out0 = 7'b1111000; // '7'
	 	   'd8   : Out0 = 7'b0000000; // '8'
		   'd9   : Out0 = 7'b0010000; // '9'
	 	   default   : Out0 = 7'bX;
	  	 endcase
	end
endmodule
