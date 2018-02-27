module testbench();
	timeunit 10ns;
	timeprecision 1ns;	

	logic [15:0] S;
	logic Clk, Reset, Run, Continue;
	logic [11:0] LED;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic CE, UB, LB, OE, WE, BEN, N, Z, P;
	logic [19:0] ADDR;
	wire [15:0] Data;
	
	logic [15:0] MAR, MDR, IR, PC, R7, R6, R5, R4, R3, R2, R1, R0; // Part 1

	always begin : CLOCK_GENERATION
		#1 Clk = ~Clk;
	end
	
	initial begin: CLOCK_INITIALIZATION
		Clk = 0;
	end
	
	lab6_toplevel tl(.*);

	initial begin: CPU_TEST
	/**
	//Program 1: Basic I/O Test 1
			//Reset
			Reset = 0;
			Run = 1;
			Continue = 1;
			
			//End Reset Select Test 1
		#2  Reset = 1;
			S = 16'h0003;
			
			//Run Test
		#2	Run = 0;
		#1  Run = 1;
		
			//Modify Switch Values
		#25 S = 16'h0005;
		#25 S = 16'h0010;
		#25 S = 16'h000B;
	**/
	
	
		
	
	//Program 2
			//Reset
			Reset = 0;
			Run = 1;
			Continue = 1;
			
			//End Reset Set Test 2
		#2  Reset = 1;
			S = 16'h0006;
			
			//Run Test
		#2	Run = 0;
		#25  Run = 1;
		
			//ask for input
		#100 S = 16'h0110;
			 Continue = 0;
		#25	 Continue = 1;
		
			//display x02/ask for input
		#100 S = 16'h0560;
			 Continue = 0;
		#25	 Continue = 1;
		
			//display x02/ask for input
		#100 S = 16'h0009;
			 Continue = 0;
		#25	 Continue = 1;

	
	
	/**
	//Program 3
					//Reset
		#100	Reset = 0;
			Run = 1;
			Continue = 1;
			//End Reset Set Test 1
		#2  Reset = 1;
			S = 16'h000B;
			//Run Test
		#2	Run = 0;
			//End Test
		#1  Run = 1;
	**/
	
	
	
		
	//Program 4
	/**
					//Reset
		#100	Reset = 0;
			Run = 1;
			Continue = 1;
			//End Reset Set Test 1
		#2  Reset = 1;
			S = 16'h0014;
			//Run Test
		#2	Run = 0;
			//End Test
		#1  Run = 1;
		
		
		
	//Program 5
					//Reset
		#100	Reset = 0;
			Run = 1;
			Continue = 1;
			//End Reset Set Test 1
		#2  Reset = 1;
			S = 16'h0031;
			//Run Test
		#2	Run = 0;
			//End Test
		#1  Run = 1;
		
		
		
	//Program 6
				//Reset
		#100	Reset = 0;
			Run = 1;
			Continue = 1;
			//End Reset Set Test 1
		#2  Reset = 1;
			S = 16'h005A;
			//Run Test
		#2	Run = 0;
			//End Test
		#1  Run = 1;
	**/
	end
	
endmodule
