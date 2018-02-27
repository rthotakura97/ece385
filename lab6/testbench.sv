module testbench();

timeunit 1ns;
timeprecision 1ns;

logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic CE, UB, LB, OE, WE, BEN, N, Z, P;
logic [15:0] MAR, MDR, IR, PC, R7, R6, R5, R4, R3, R2, R1, R0;
logic [19:0] ADDR;
wire [15:0] Data;


always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
Clk=0;
end
lab6_toplevel toplevel(.*);

initial begin: TEST_VECTORS
Reset = 0;
Run = 1;
Continue = 1;

#2 Reset = 1;
	S = 16'h0006;

#2 Run = 0;

#2 Run = 1;

#20 Continue = 0;
#2 Continue = 1;
#20 Continue = 0;
#2 Continue = 1;


#22;
end
endmodule
