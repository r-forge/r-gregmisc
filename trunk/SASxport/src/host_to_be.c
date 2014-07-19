#include "writeSAS.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>

/* host_to_be: convert current host byte order to big endian */
void host_to_be( unsigned char *intp, size_t size)
{
  size_t i;
  unsigned char tmp;

  short twobytes = 0x0001;
  char  onebyte  = *(char*) &twobytes;

  /* Test if we are on a big endian or little endian platform */
  if (onebyte == 1) 
   { 
     /* Native byte order is little endian, so swap bytes */
     /* printf("Little Endian Machine!\n"); */

      for(i=0; i < size/2; i++)
        {
          tmp = (unsigned char) intp[i];
          intp[i] = intp[size-i-1];
          intp[size-i-1] = tmp;
        }
    }
  else
    {
      /* The native byte order is big endian, so do nothing */
      /* printf("Big Endian Machine!\n");  */
    }
 
  return;
}

/* test code */
void test_host_to_be()
{
  unsigned char  byte_pattern[1] = { 0x00 };
  unsigned char  byte_value      = 0x00;

  unsigned char  short_pattern[2] = { 0x01, 0x00 };   /* NB: big endian byte pattern */
  short   short_value       = 0x0100;          /* NB: hex is also written big endian */

  unsigned char  int_pattern[4]   = { 0x03, 0x02, 0x01, 0x00 };
  int     int_value        = 0x03020100;

  unsigned char  long_pattern[4]  = { 0x03, 0x02, 0x01, 0x00 };
  long    long_value       = 0x03020100;

  /* Do the host_to_be, then test */

  /* byte */
  host_to_be( &byte_value, sizeof(unsigned char) );
  ASSERT( (unsigned char) *byte_pattern == byte_value );

  /* short */
  host_to_be( (unsigned char*) &short_value, sizeof(short) );
  ASSERT( *((short *) short_pattern) == short_value );

  /* int */
  host_to_be( (unsigned char*) &int_value, sizeof(int) );
  ASSERT( *((int *) int_pattern) == int_value );

  /* long */
  host_to_be( (unsigned char*) &long_value, sizeof(long) );
  ASSERT( *((long*) long_pattern) == long_value );

}

#ifdef DO_TEST
int main(int argc, char *argv)
{
  test_host_to_be();
}
#endif
