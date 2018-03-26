#include "aesutils.h"

unsigned int rotate_word(unsigned int in){
	int i;
	unsigned char char_temp[4], char_out[4];

	for (i = 0; i < 4; i++) {
		char_temp[i] = *((unsigned char *)&in + i);
	}

	char_out[0] = char_temp[1];
	char_out[1] = char_temp[2];
	char_out[2] = char_temp[3];
	char_out[3] = char_temp[0];

	return (unsigned int)(*char_out);
}

void KeyExpansion(unsigned char * key, unsigned int * w, int NK){

	word temp;
	int i =0;

	while(i < NK){
		unsigned char byte0 = key[4*i];
		unsigned char byte1 = key[4*i+1];
		unsigned char byte2 = key[4*i+2];
		unsigned char byte3 = key[4*i+3];

		unsigned int u = byte0;
		u << 8;
		u |= byte1;
		u << 8;
		u |= byte2;
		u << 8;
		u |= byte3;

		w[i] = u;
		i = i + 1;
	}

	i = NK;

	while(i < (NB*(NR+1))){
		temp = w[i-1];
		if (i % NK == 0){
			temp = SubWord(RotWord(temp)) ^ Rcon[i/NK];
		}
		w[i] = w[i-NK] ^ temp;
		i = i+1;
	}

}