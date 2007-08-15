#include "writeSAS.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#import  <assert.h>
#import  <sys/types.h>

/* reverse: convert current byte order to little endian */
void reverse( u_char *intp, size_t size)
{
  static u_char endianTest[2] =   {0x01,0x00};
  size_t i;
  u_char tmp;

#if !defined(BIG_ENDIAN) && !defined(LITTLE_ENDIAN)
  /* Test if we are on a big endian or little endian platform */
  if( (short) *endianTest == 1 ) 
    {  
      /* Little Endian */
      /* Do nothing    */
      return;  
    }
#endif

  /* Big Endian */
  /* Swap bytes */
  for(i=0; i < size/2; i++)
    {
      tmp = (u_char) intp[i];
      intp[i] = intp[size-i-1];
      intp[size-i] = tmp;
    }
  
  return;
}


/* test code */
void test_reverse()
{
  u_char  byte_pattern[1] = { 0x00 };
  u_char  byte_value      = 0x00;
  
  u_char  short_pattern[2] = { 0x00, 0x01 };  /* NB: little endian byte pattern */
  short   short_value       = 0x0100;          /* NB: hex is written big endian */
  
  u_char  int_pattern[4]   = { 0x0, 0x01, 0x02, 0x03 };
  int     int_value        = 0x03020100; 

  u_char  long_pattern[4]  = { 0x0, 0x01, 0x02, 0x03 };
  long    long_value       = 0x03020100; 

  /* Do the reverse, then test */

  /* byte */
  REVERSE( &byte_value, sizeof(u_char) );
  assert( (u_char) *byte_pattern == byte_value );

  /* short */
  REVERSE( &short_value, sizeof(short) );
  assert( *((short *) short_pattern) == short_value );

  /* int */
  REVERSE( &int_value, sizeof(int) );
  assert( *((int *) int_pattern) == int_value );

  /* long */
  REVERSE( &long_value, sizeof(long) );
  assert( *((long*) long_pattern) == long_value );

}


#ifdef DO_TEST
int main(int argc, u_char *argv)
{
  test_reverse();
}



#endif
