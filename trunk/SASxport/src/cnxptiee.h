/* ********

Header file for cnxptiee.c based on code extracted from SAS TS140
(http://support.sas.com/techsup/technote/ts140.html) 

********* */

#ifndef CNXPTIEE
#define CNXPTIEE


#define CN_TYPE_NATIVE 0 
#define CN_TYPE_XPORT  1 
#define CN_TYPE_IEEEB  2 
#define CN_TYPE_IEEEL  3

int  cnxptiee(char *from, int fromtype, char *to, int totype);
void xpt2ieee(unsigned char *xport, unsigned char *ieee);
void ieee2xpt(unsigned char *ieee,  unsigned char *xport); 

#ifndef FLOATREP 
#define FLOATREP get_native()
int get_native(); 
#endif 

#ifdef BIG_ENDIAN
#define REVERSE(a,b)
#endif

#ifdef LITTLE_ENDIAN
#define DEFINE_REVERSE
void REVERSE();
#endif

#endif /* CNXPTIEE */
