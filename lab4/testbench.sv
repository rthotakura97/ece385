module testbench();

timeunit 1ns;

timeprecision 1ns;

logic clk;
logic Reset;
logic LoadB;
logic Run;
logic[15:0] SW;

logic CO;
logic[15:0] Sum;
logic[6:0] Ahex0, Ahex1, Ahex2, Ahex3;
logic[6:0] Bhex0, Bhex1, Bhex2, Bhex3;

always begin: CLOCK_GENERATION

#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

lab4_adders tp(.*);

initial begin: TEST_VECTORS

Reset = 0;
LoadB = 1;
Run = 1;

#2 Reset = 1;

#2 LoadB = 0;
	SW = 16'h0001;
	
#2 LoadB = 1;
	SW = 16'h0002;
	
#2 Run = 0;

#22 ;

end

endmodule
