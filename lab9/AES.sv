/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);
  
// outputs of each type of function will be stored here
  logic [127:0]output_invsubbytes, output_invmixcolumns, output_invshiftrows, output_addroundkey, round_key;
  logic [3:0] round;
  logic [31:0] mix_cols_in, mix_cols_out;
  logic [1:0] mix_cols_idx;
//key schedule
	logic [1407:0] key_schedule;

// state register
// Requires a 4:1 mux going into state register from subbytes, mixcolumns,
// shiftrows, and addroundkey
  logic ld_state;
  logic [1:0] state_select;
  logic [127:0] STATE_REGISTER, state_mux_out;
  
  // mux implementation to choose outputs from different functions into the state register
  always_comb
  begin
    if(state_select == 0)
			state_mux_out = output_addroundkey;
    if(state_select == 1)
  		state_mux_out = output_invsubbytes;
    if(state_select == 2)
  		state_mux_out = output_invmixcolumns;
    if(state_select == 3)
  		state_mux_out = output_invshiftrows;
  end
  
  always_ff @ (posedge CLK)
  begin
    if (RESET)
      STATE_REGISTER <= 0;
    if (ld_state)
      STATE_REGISTER <= state_mux_out;
  end

// 16 inv sub bytes0
// Input: Byte
// Output: Byte
// 
// This will pull from the state and write back to the state
  InvSubBytes inv_sub_bytes_0(.clk(CLK), .in(STATE_REGISTER[127:120]), .out(output_invsubbytes[127:120]));
  InvSubBytes inv_sub_bytes_1(.clk(CLK), .in(STATE_REGISTER[119:112]), .out(output_invsubbytes[119:112]));
  InvSubBytes inv_sub_bytes_2(.clk(CLK), .in(STATE_REGISTER[111:104]), .out(output_invsubbytes[111:104]));
  InvSubBytes inv_sub_bytes_3(.clk(CLK), .in(STATE_REGISTER[103:96]), .out(output_invsubbytes[103:96]));
  InvSubBytes inv_sub_bytes_4(.clk(CLK), .in(STATE_REGISTER[95:88]), .out(output_invsubbytes[95:88]));
  InvSubBytes inv_sub_bytes_5(.clk(CLK), .in(STATE_REGISTER[87:80]), .out(output_invsubbytes[87:80]));
  InvSubBytes inv_sub_bytes_6(.clk(CLK), .in(STATE_REGISTER[79:72]), .out(output_invsubbytes[79:72]));
  InvSubBytes inv_sub_bytes_7(.clk(CLK), .in(STATE_REGISTER[71:64]), .out(output_invsubbytes[71:64]));
  InvSubBytes inv_sub_bytes_8(.clk(CLK), .in(STATE_REGISTER[63:56]), .out(output_invsubbytes[63:56]));
  InvSubBytes inv_sub_bytes_9(.clk(CLK), .in(STATE_REGISTER[55:48]), .out(output_invsubbytes[55:48]));
  InvSubBytes inv_sub_bytes_10(.clk(CLK), .in(STATE_REGISTER[47:40]), .out(output_invsubbytes[47:40]));
  InvSubBytes inv_sub_bytes_11(.clk(CLK), .in(STATE_REGISTER[39:32]), .out(output_invsubbytes[39:32]));
  InvSubBytes inv_sub_bytes_12(.clk(CLK), .in(STATE_REGISTER[31:24]), .out(output_invsubbytes[31:24]));
  InvSubBytes inv_sub_bytes_13(.clk(CLK), .in(STATE_REGISTER[23:16]), .out(output_invsubbytes[23:16]));
  InvSubBytes inv_sub_bytes_14(.clk(CLK), .in(STATE_REGISTER[15:8]), .out(output_invsubbytes[15:8]));
  InvSubBytes inv_sub_bytes_15(.clk(CLK), .in(STATE_REGISTER[7:0]), .out(output_invsubbytes[7:0]));
  
// keyexpansion
// Input: CipherKey
// Output: KeySchedule
	KeyExpansion key_exp_inst(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(key_schedule));

// invmixcolumns
// Input: Word of state
// Output: Mixed word
  InvMixColumns inv_mix_cols_inst(.in(mix_cols_in), .out(mix_cols_out));
  always_comb
  begin
    if (mix_cols_idx == 0)
      mix_cols_in = STATE_REGISTER[127:96];
    else if (mix_cols_idx == 1)
      mix_cols_in = STATE_REGISTER[95:64];
    else if (mix_cols_idx == 2)
      mix_cols_in = STATE_REGISTER[63:32];
    else if (mix_cols_idx == 3)
      mix_cols_in = STATE_REGISTER[31:0];
    else
      mix_cols_in = 0;
  end
  
  always_comb
  begin
    if (mix_cols_idx == 0)
      output_invmixcolumns[127:96] = mix_cols_out;
    else if (mix_cols_idx == 1)
      output_invmixcolumns[95:64] = mix_cols_out;
    else if (mix_cols_idx == 2)
      output_invmixcolumns[63:32] = mix_cols_out;
    else if (mix_cols_idx == 3)
      output_invmixcolumns[31:0] = mix_cols_out;
    else
      output_invmixcolumns = 0;
  end

// invshiftrows
// Input: state
// Output: shifted state
//
// This will pull from the state and write back to the state
  InvShiftRows inv_shift_rows_inst(.data_in(STATE_REGISTER), .out(output_invshiftrows));
  
// addroundkey
// Input: state, key schedule, and round
// Output: state ^ round key
//
// This will pull from the state and write back to the state
  always_comb
  begin
    output_addroundkey = round_key ^ STATE_REGISTER;
  end
  
  always_comb
  begin
    if (round == 0)
      round_key = key_schedule[1407:1280];
    else if (round == 1)
      round_key = key_schedule[1279:1152];
    else if (round == 2)
      round_key = key_schedule[1151:1024];
    else if (round == 3)
      round_key = key_schedule[1023:896];
    else if (round == 4)
      round_key = key_schedule[895:768];
    else if (round == 5)
      round_key = key_schedule[767:640];
    else if (round == 6)
      round_key = key_schedule[639:512];
    else if (round == 7)
      round_key = key_schedule[511:384];
    else if (round == 8)
      round_key = key_schedule[383:256];
    else if (round == 9)
      round_key = key_schedule[255:128];
    else if (round == 10)
      round_key = key_schedule[127:0];
    else
      round_key = 0;
  end

// state machine
// Input: CLK, AES_START, RESET
// Output: StateRegister Mux signal [2:0],
// 		   MixCols Mux Signal [2:0],
// 		   MixCols byte enable,
// 		   Round number, 
// 		   AES_DONE
//
//

endmodule

/**

states:
	* Wait start
	* keyexpansion + waiting
	* AddRoundKey0
	* InvShiftRows1
	* InvSubBytes1
	* AddRoundKey1
	* InvMixColumns1_1
	* InvMixColumns1_2
	* InvMixColumns1_3
	* InvMixColumns1_4
	* InvShiftRows2
	* InvSubBytes2
	* AddRoundKey2
	* InvMixColumns2_1
	* InvMixColumns2_2
	* InvMixColumns2_3
	* InvMixColumns2_4
	* InvShiftRows3
	* InvSubBytes3
	* AddRoundKey3
	* InvMixColumns3_1
	* InvMixColumns3_2
	* InvMixColumns3_3
	* InvMixColumns3_4
	* InvShiftRows4
	* InvSubBytes4
	* AddRoundKey4
	* InvMixColumns4_1
	* InvMixColumns4_2
	* InvMixColumns4_3
	* InvMixColumns4_4
	* InvShiftRows5
	* InvSubBytes5
	* AddRoundKey5
	* InvMixColumns5_1
	* InvMixColumns5_2
	* InvMixColumns5_3
	* InvMixColumns5_4
	* InvShiftRows6
	* InvSubBytes6
	* AddRoundKey6
	* InvMixColumns6_1
	* InvMixColumns6_2
	* InvMixColumns6_3
	* InvMixColumns6_4
	* InvShiftRows7
	* InvSubBytes7
	* AddRoundKey7
	* InvMixColumns7_1
	* InvMixColumns7_2
	* InvMixColumns7_3
	* InvMixColumns7_4
	* InvShiftRows8
	* InvSubBytes8
	* AddRoundKey8
	* InvMixColumns8_1
	* InvMixColumns8_2
	* InvMixColumns8_3
	* InvMixColumns8_4
	* InvShiftRows9
	* InvSubBytes9
	* AddRoundKey9
	* InvMixColumns9_1
	* InvMixColumns9_2
	* InvMixColumns9_3
	* InvMixColumns9_4
	* InvShiftRows10
	* InvSubBytes10
	* AddRoundKey10
	* Done

*/

