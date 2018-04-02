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

// state register
// Requires a 4:1 mux going into state register from subbytes, mixcolumns,
// shiftrows, and addroundkey

// 16 inv sub bytes
// Input: Byte
// Output: Byte
// 
// This will pull from the state and write back to the state

// keyexpansion
// Input: CipherKey
// Output: KeySchedule

// invmixcolumns
// Input: Word of state
// Output: Mixed word
//
// This will need a 4:1 Mux from the 4 words in the state

// invshiftrows
// Input: state
// Output: shifted state
//
// This will pull from the state and write back to the state

// addroundkey
// Input: state, key schedule, and round
// Output: state ^ round key
//
// This will pull from the state and write back to the state

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
