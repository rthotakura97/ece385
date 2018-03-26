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

void key_expansion(unsigned char key[4 * NB], unsigned int w[4 * (NR + 1)]) {

}
