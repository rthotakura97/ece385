// Top level module

module multiplier_process (input logic Clk,
                                         Reset,
                                         Run,
                                         ClearA_LoadB,
                             input logic [7:0] S,
                             output logic [6:0] AhexL,
                                                BhexL,
                                                AhexU,
                                                BhexU,
                             output logic [7:0] Aval,
                                                Bval,
                             output logic X);
    
    logic Reset_SH, ClearA_LoadB_SH, Run_SH; // LoadA_SH and LoadX_SH are used to clear the registers
    logic [7:0] S_S, mux_out, S_complement;
    logic ClrA_X, LdB, Shift, Add, Sub, M, ClrsA_X, LdA_X;
    logic X_in;
    logic A_out, X_out,B_out;
	 logic nine_bit_co, subber_co;
	 logic [8:0] nine_bit_sum;
	 
	 orers ors(.ClrA_X, .Reset_SH, .Add, .Sub, .ClrsA_X, .LdA_X);

    //FIXME: We need to expand the control unit (or add a new control unit)
    //       We need to select data from either the switches or the adder
    //       Mux implementation there
    //       Use overarching register unit that has a mux as well?

    control control_unit(.Reset(Reset_SH),
                         .Clk(Clk),
                         .Run(Run_SH),
                         .ClearA_LoadB(ClearA_LoadB_SH),
                         .M(M),
                         .ClrA_X(ClrA_X),
                         .LdB(LdB),
                         .Shift(Shift),
                         .Add(Add),
                         .Sub(Sub));
    // Many of these arguments will definitely change
    reg_8 A(.Clk,
            .Reset(ClrsA_X), //MAKE SURE TO TEST THIS
            .Shift_In(X),
            .Load(LdA_X),
            .Shift_En(Shift),
            .D(nine_bit_sum[7:0]),
            .Shift_Out(A_out),
            .Data_Out(Aval));
    
    reg_8 B(.Clk,
            .Reset(Reset_SH),
            .Shift_In(A_out),
            .Load(LdB),
            .Shift_En(Shift),
            .D(S_S),//Parallel input will only come from switches
            .Shift_Out(B_out),
            .Data_Out(Bval));

    reg_1 X_reg(.Clk(Clk),
            .Reset(ClrsA_X),
            .Shift_In(nine_bit_sum[8]),
            .Load(LdA_X),
            .Shift_En(Shift),
            .Data_Out(X));

    nine_bit_adder adder(.A(Aval),
								 .B(mux_out),
								 .cin(1'b0),
								 .S(nine_bit_sum),
								 .cout(nine_bit_co));//CO unused
	 
	 incrementer subber(.B(~S_S),
							  .cin(1'b0),
							  .S(S_complement),
							  .cout(subber_co));
								 
	 mux_2to1_8 muxy(.Din0(S_complement), 
						  .Din1(S_S), 
						  .select(Add), 
						  .Dout(mux_out));
	 //TODO: Need 2:1 mux to select from full adder or full subtracter
	 //		Need to implement subtracter
	 //		HexDriver
	 //		Testbench
	 
	 HexDriver        HexAL (
                        .In0(Aval[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(Aval[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                       .In0(Bval[7:4]),
                        .Out0(BhexU) );
	 assign M = Bval[0];						

	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
     sync S_sync[7:0] (Clk, S, S_S);
endmodule
