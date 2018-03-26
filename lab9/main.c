/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017 Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aesutils.h"

#define BYTES 8

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 1;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void print_arr(unsigned char * arr) {
	printf("state:\n");
	for (int i = 0; i < 16; i++) {
		printf("%02x ", arr[i]);
		if (i % 4 == 3)
			printf("\n");
	}
}

void print_key(unsigned char * arr) {
	printf("key:\n");
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			printf("%02x ", arr[j*4 + i]);
		}
		printf("\n");
	}
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	unsigned char msg_mem[16], key_mem[16], state[16];
	int i,j;
	for (i = 0; i < 16; i++) {
		msg_mem[i] = charsToHex(msg_ascii[i*2], msg_ascii[i*2+1]);	
		key_mem[i] = charsToHex(key_ascii[i*2], key_ascii[i*2+1]);	
	}

	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			state[i*4 + j] = msg_mem[j*4 + i];
		}
	}
	
	// run key expansion to fill w
	unsigned int *w = malloc(NB * (NR + 1) * BYTES);
	KeyExpansion(key_mem, w, NK);

	add_round_key(state, w);
	for (i = 1; i < NR; i++) {
		sub_bytes(state);
		shift_rows(state);
		mix_columns(state);
		add_round_key(state, w+i*4);
	}
	sub_bytes(state);
	shift_rows(state);
	add_round_key(state, w+NR*4);

	msg_enc = (unsigned int *)state;
	key = w;
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	unsigned char msg_mem[16], state[16];
	int i,j;
	state = (unsigned char *)msg_enc;

	// run key expansion to fill w
	unsigned int *w = malloc(NB * (NR + 1) * BYTES);
	KeyExpansion(key_mem, w, NK);

	add_round_key(state, w);
	for (i = 1; i < NR; i++) {
		sub_bytes(state);
		shift_rows(state);
		mix_columns(state);
		add_round_key(state, w+i*4);
	}
	sub_bytes(state);
	shift_rows(state);
	add_round_key(state, w+NR*4);
}

void blehbleh(int x){
}
/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	/*
	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	int x = scanf("%d", &run_mode);
	blehbleh(x);
	*/

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
//			x = scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
//			x = scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		char plaintext_test[32]  = {'e', 'c', 'e', '2', '9', '8', 'd', 'c', 'e', 'c', 'e', '2', '9', '8', 'd', 
									'c', 'e', 'c', 'e', '2', '9', '8', 'd', 'c', 'e', 'c', 'e', '2', '9', '8', 'd', 'c'};
		char key_test[32] = {'0', '0', '0', '1', '0', '2', '0', '3', '0', '4', '0', '5', '0', '6', '0', 
								'7', '0', '8', '0', '9', '0', 'a', '0', 'b', '0', 'c', '0', 'd', '0', 'e', '0', 'f'};
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			//msg_ascii[i] = 'a';
			//key_ascii[i] = 'b';
			msg_ascii[i] = plaintext_test[i];
			key_ascii[i] = key_test[i];
		}
		encrypt(msg_ascii, key_ascii, msg_enc, key);
		/*
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
		*/
	}
	return 0;
}
