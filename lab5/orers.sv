module orers(input logic ClrA_X, Reset_SH, Add, Sub,
				 output logic ClrsA_X, LdA_X); 


		assign ClrsA_X = ClrA_X | Reset_SH;
		assign LdA_X = Add | Sub;
	   
	 
endmodule
