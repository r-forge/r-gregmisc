//#include "writeSAS.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>

/* reverse: convert current byte order to big endian */
void reverse( unsigned char *intp, size_t size)
{
  static unsigned char endianTest[2] =   {0x01,0x00};
  size_t i;
  unsigned char tmp;

#if !defined(BIG_ENDIAN) && !defined(LITTLE_ENDIAN)
  /* Test if we are on a big endian or little endian platform */
  if( (short) *endianTest != 1 ) 
    {  
      /* The native byte order is big endian, so do nothing */
      printf("Big Endian Machine!\n");
      return;  
    }
#endif

  /* If native byte order is little endian, we need to swap bytes */
  for(i=0; i < size/2; i++)
    {
      tmp = (unsigned char) intp[i];
      intp[i] = intp[size-i-1];
      intp[size-i-1] = tmp;
    }
  
  return;
}


/* test code */
void test_reverse()
{
  unsigned char  byte_pattern[1] = { 0x00 };
  unsigned char  byte_value      = 0x00;
  
  unsigned char  short_pattern[2] = { 0x01, 0x00 };   /* NB: big endian byte pattern */
  short   short_value       = 0x0100;          /* NB: hex is also written big endian */
  
  unsigned char  int_pattern[4]   = { 0x03, 0x02, 0x01, 0x00 };
  int     int_value        = 0x03020100; 

  unsigned char  long_pattern[4]  = { 0x03, 0x02, 0x01, 0x00 };
  long    long_value       = 0x03020100; 

  /* Do the reverse, then test */

  /* byte */
  reverse( &byte_value, sizeof(unsigned char) );
  assert( (unsigned char) *byte_pattern == byte_value );

  /* short */
  reverse( (unsigned char*) &short_value, sizeof(short) );
  assert( *((short *) short_pattern) == short_value );

  /* int */
  reverse( (unsigned char*) &int_value, sizeof(int) );
  assert( *((int *) int_pattern) == int_value );

  /* long */
  reverse( (unsigned char*) &long_value, sizeof(long) );
  assert( *((long*) long_pattern) == long_value );

}


#ifdef DO_TEST
int main(int argc, char *argv)
{
  test_reverse();
}


#endif
