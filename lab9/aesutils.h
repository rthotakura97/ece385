#ifndef AES_UTILS
#define AES_UTILS

#define NK 4
#define NB 4
#define NR 10

void key_expansion(unsigned char key[4 * NB], unsigned int w[4 * (NR + 1)]);

#endif
