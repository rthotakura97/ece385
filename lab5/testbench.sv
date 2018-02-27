module testbench();

timeunit 1ns;

timeprecision 1ns;

logic Clk, Reset, Run, ClearA_LoadB;
logic [7:0] S;

logic [7:0] Aval, Bval;
logic X;
logic [6:0] AhexL, BhexL, AhexU, BhexU;

always begin: CLOCK_GENERATION

#1 Clk = ~Clk;

end

initial begin: CLOCK_INITIALIZATION
	Clk = 0;
end

multiplier_process tp(.*);

initial begin: TEST_VECTORS

Reset = 0;
ClearA_LoadB = 1;
Run = 1;

#2 Reset = 1;

#2 ClearA_LoadB = 0;
	S = 8'h02;
	
#2 ClearA_LoadB = 1;
	
#2 ClearA_LoadB = 0;
	S = 8'hff;
	
#2 ClearA_LoadB = 1;

#2 ClearA_LoadB = 0;
	S = 8'h02;
	
#2 ClearA_LoadB = 1;
	S = 8'h02;

#2	Run = 0;
	
#2 Run = 1;

#100 


#2 ClearA_LoadB = 0;
	S = 8'h02;
	
#2 ClearA_LoadB = 1;
	S = 8'hfe;

#2	Run = 0;
	
#2 Run = 1;

#100

#2 ClearA_LoadB = 0;
	S = 8'hfe;
	
#2 ClearA_LoadB = 1;
	S = 8'h02;

#2	Run = 0;
	
#2 Run = 1;

#100

#2 ClearA_LoadB = 0;
	S = 8'hfe;
	
#2 ClearA_LoadB = 1;
	S = 8'hfe;

#2	Run = 0;
	
#2 Run = 1;

#100 ;

end

endmodule
