/* Masks for IBM fields  */
#define IBM_SIGN  B64(10000000, 0000000, 0000000, 00000000, \
                      00000000, 0000000, 0000000, 00000000)

#define IBM_EXP   B64(01111111, 0000000, 0000000, 00000000, \
                      00000000, 0000000, 0000000, 00000000)

#define IBM_FRAC  B64(00000000, 1111111, 1111111, 11111111, \
		      11111111, 1111111, 1111111, 11111111)

#define IBM_FRAC_MSB B64(00000000, 1000000, 0000000, 00000000, \
                         00000000, 0000000, 0000000, 00000000)

/* Masks for IEEE fields  */
#define IEEE_SIGN B64(10000000, 0000000, 0000000, 00000000, \
                      00000000, 0000000, 0000000, 00000000)

#define IEEE_EXP  B64(01111111, 1111000, 0000000, 00000000, \
                      00000000, 0000000, 0000000, 00000000)

#define IEEE_FRAC B64(00000000, 0000111, 1111111, 11111111, \
		      11111111, 1111111, 1111111, 11111111)

