#ifndef AES_UTILS
#define AES_UTILS

#define NK 4
#define NB 4
#define NR 10

void KeyExpansion(unsigned char * key, unsigned int * w, int nk);
void sub_bytes(unsigned char * state);
void add_round_key(unsigned char * state, unsigned int * w);
void shift_rows(unsigned char * state);
void mix_columns(unsigned char * state);

void inv_sub_bytes(unsigned char * state);
void inv_shift_rows(unsigned char * state);
void inv_mix_columns(unsigned char * state);

#endif
