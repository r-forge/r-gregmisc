//#include "writeSAS.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#import  <assert.h>
#import  <sys/types.h>

typedef struct {                    /* IBM floating point format */
  unsigned sign    :   1;   /* Sign bit */
  unsigned exponent:   7;   /* Exponent */
  //unsigned fraction:  56;   /* Fraction */
  unsigned fraction1:  24;    /* Top half of fraction */
  unsigned fraction2:  32;    /* Lower half of fraction */
} IBM_fp_struct;


typedef struct {                    /* IEEE floating point format */
  unsigned sign    :   1;   /* Sign bit */
  unsigned exponent:  11;   /* Exponent */
  //  unsigned fraction:  52;   /* Fraction */
  unsigned fraction1:  20;    /* Top half of fraction */
  unsigned fraction2:  32;    /* Lower half of fraction */
} IEEE_fp_struct;


int IEEEtoIBM(double *ieee, double *ibm )
{
  IEEE_fp_struct *ieee_fp = (IEEE_fp_struct*) ieee;
  IBM_fp_struct  *ibm_fp  = (IBM_fp_struct* ) ibm;
  int64_t        sign;
  int64_t        exponent;
  int64_t        fraction;
  short          low_exp_bits;
  
  /*** Extract Pieces ***/
  //  Sign     = Ieee & Ieee_Sign;
  //  Exponent = *Ieee & Ieee_Exp;
  //  Fraction = *Ieee & Ieee_Frac;

  printf("1\n");

  /*** copy IEEE sign to IBM sign ***/
  ibm_fp->sign = ieee_fp->sign;

  printf("2\n");

  /*** convert IEEE exponent to IBM exponent ***/
  exponent = ieee_fp->exponent;

  printf("3\n");

  /* store lowest 2 bits from exponent */
  low_exp_bits = exponent % 16;   
  

  printf("4\n");

  /* divide exponent by 4 to get from IEEE pow(2) exponent to IBM pow(16) exponent  */  
  exponent = exponent >> 2;

  printf("5\n");

  
  /* put it into the return value */
  ibm_fp->exponent = exponent;

  printf("6\n");


  /*** convert IEEE fraction to IBM fraction */
  fraction = ((int64_t) ieee_fp->fraction1 ) << 32 | ((int64_t) ieee_fp->fraction2);

  printf("7\n");


  /* shift left by low order bits lost from exponent */
  fraction = fraction  <<   (low_exp_bits && 0x03);


  printf("8\n");

  /* add leading 1 bit */
  fraction >> 1;
  fraction = fraction | ( ((int64_t) 1) <<55 );

  printf("9\n");


  ibm_fp->fraction1 = (int32_t) (fraction >> 32) | 0x0FFFFF;
  ibm_fp->fraction2 = (int32_t) fraction;


  printf("10\n");

  
  char *buf= (char*) ibm;
  char tmp;
  int i;
  for(i=0; i<8; i++)
    {
      tmp = buf[7-i];
      buf[7-i] = buf[i];
      buf[i] = tmp;
    }

  return 0;
}

