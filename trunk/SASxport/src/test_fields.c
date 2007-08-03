#include <stdio.h>
#include <string.h>
#import "writeSAS.h"

#import <assert.h>

#define BIG   1024
#define SMALL 5

#define MIN(x,y)  (x>y?y:x)

int test_blankFill( int bufsize )
{
  char prebuffer = 'c';
  char buffer[bufsize];
  char postbuffer = 'c';
  
  /* fill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* call blankfill to fill the first bufsize spaces with blanks */
  blankFill( buffer, bufsize );

  /* check we've got blanks in first bufsize positions */
  for(int i=0; i<bufsize; i++)
    assert( buffer[i] == ' ' );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  return 0;
}


int test_blankCopy( int bufsize )
{
  char prebuffer = 'c';
  char buffer[bufsize];
  char postbuffer = 'c';
  char *shortstr = "abc";
  char *longstr  = "123456789012345678901234567890";
  
  /* fill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* copy the short string */
  blankCopy( buffer, bufsize, shortstr );

  /* check we copied correctly */
  for(int i=0; i<MIN(bufsize, strlen(shortstr)); i++)
    assert( buffer[i] == shortstr[i] );

  /* check we filled the rest of the space with blanks (and don't have a null) */
  for(int i=strlen(shortstr); i<bufsize; i++)
    assert( buffer[i] == ' ' );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  /* refill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* copy the long string */
  blankCopy( buffer, bufsize, longstr );

  /* check we copied correctly */
  for(int i=0; i<MIN(bufsize, strlen(longstr)); i++)
      assert( buffer[i] == longstr[i] );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  return 0;
}



int test_zeroFill(int bufsize)
{
  char prebuffer = 'c';
  char buffer[bufsize];
  char postbuffer = 'c';
  
  /* fill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* call blankfill to fill the first bufsize spaces with blanks */
  zeroFill( buffer, bufsize );

  /* check we've got blanks in first bufsize positions */
  for(int i=0; i<bufsize; i++)
    assert( buffer[i] == 0 );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  return 0;
}


int test_zeroCopy(int bufsize)
{
  char prebuffer = 'c';
  char buffer[bufsize];
  char postbuffer = 'c';
  char *shortstr = "abc";
  char *longstr  = "123456789012345678901234567890123456789012345678901234567890";
  
  /* fill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* copy the short string */
  zeroCopy( buffer, bufsize, shortstr );

  /* check we copied correctly */
  for(int i=0; i<MIN(bufsize, strlen(shortstr)); i++)
    assert( buffer[i] == shortstr[i] );

  /* check we filled the rest of the space with blanks (and don't have a null) */
  for(int i=strlen(shortstr); i<bufsize; i++)
    assert( buffer[i] == 0 );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  /* refill the buffer with 'x' */
  for(int i=0; i<bufsize; i++)
    buffer[i] = 'x';

  /* copy the long string */
  blankCopy( buffer, bufsize, longstr );

  /* check we copied correctly */
  for(int i=0; i<MIN(bufsize, strlen(longstr)); i++)
    assert( buffer[i] == longstr[i] );

  /* and that we've still got 'c' before and after the buffer (no overrun) */
  assert( prebuffer == 'c' );
  assert( postbuffer == 'c' );

  return 0;
}

void doTest()
{
  /* small buffer */
  test_blankFill(SMALL);
  test_zeroFill(SMALL);

  test_blankCopy(SMALL);
  test_zeroCopy(SMALL);

  
  /* big buffer */
  test_blankFill(BIG);
  test_zeroFill(BIG);

  test_blankCopy(BIG);
  test_zeroCopy(BIG);
}
  
