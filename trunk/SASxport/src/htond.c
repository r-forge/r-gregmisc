/*                         H T O N D . C
 * BRL-CAD
 *
 * Copyright (c) 2004-2007 United States Government as represented by
 * the U.S. Army Research Laboratory.
 *
 * Minor changes (c) 2007 Random Technologies LLC by Gregory R. Warnes
 *   <greg@random-technologies-llc.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this file; see the file named COPYING for more
 * information.
 */

#include "writeSAS.h"
#include <stdio.h>

/****************************/
/** NB: htond code ommitted */
/****************************/

/****************************
 * NB: The ntohd code assumes that 'in' points to a vector BIG-ENDIAN IEEE
 *   double precision value of length 'count'. This extracted routine
 *   returns IBM/360 format double precision values in *out
 ***************************/


void R_ntohd(double out[], double in[], int *count)
{
  int i;
  int j;
  unsigned char tmp;
  unsigned char *cptr;

  /* Flip byte order from little endian to big endian */
  for(i=0; i<*count; i++)
    reverse( (unsigned char*) &(in[i]), sizeof(double) );
  ieee2ibm( (unsigned char *) out, (unsigned char *) in, *count );
}

/**
 *			N T O H D
 *
 *  @brief Network to Host Doubles
 */
// Original function name: "ntohd"
void ieee2ibm(register unsigned char *out, register const unsigned char *in, int count)
{
	/*
	 *  IBM Format.
	 *  7-bit exponent, base 16.
	 *  No hidden bits in mantissa (56 bits).
	 */
	register int	i;
	for( i=count-1; i >= 0; i-- )  {
		register unsigned long left, right;
		register int fix, exp, signbit;

		left  = (in[0]<<24) | (in[1]<<16) | (in[2]<<8) | in[3];
		right = (in[4]<<24) | (in[5]<<16) | (in[6]<<8) | in[7];
		in += 8;

		exp = ((left >> 20) & 0x7FF);
		signbit = (left & 0x80000000) >> 24;
		if( exp == 0 || exp == 0x7FF )  {
ibm_undef:		*out++ = 0;		/* IBM zero.  No NAN */
			*out++ = 0;
			*out++ = 0;
			*out++ = 0;
			*out++ = 0;
			*out++ = 0;
			*out++ = 0;
			*out++ = 0;
			continue;
		}

		left = (left & 0x000FFFFF) | 0x00100000;/* replace "hidden" bit */

		exp += 129 - 1023 -1;	/* fudge, to make /4 and %4 work */
		fix = exp % 4;		/* 2^4 == 16^1;  get fractional exp */
		exp /= 4;		/* excess 32, base 16 */
		exp += (64-32+1);	/* excess 64, base 16, plus fudge */
		if( (exp & ~0xFF) != 0 )  {
		  //WARNING("ntohd:  IBM exponent overflow");
			fprintf(stderr,"ntohd:  IBM exponent overflow\n");
			goto ibm_undef;
		}

		if( fix )  {
			left = (left<<fix) | (right >> (32-fix));
			right <<= fix;
		}

		if( signbit )  {
			/* The IBM actually uses complimented mantissa
			 * and exponent.
			 */
			left  ^= 0xFFFFFFFF;
			right ^= 0xFFFFFFFF;
			if( right & 0x80000000 )  {
				/* There may be a carry */
				right += 1;
				if( (right & 0x80000000) == 0 )  {
					/* There WAS a carry */
					left += 1;
				}
			} else {
				/* There will be no carry to worry about */
				right += 1;
			}
			left &= 0x00FFFFFF;
			exp = (~exp) & 0x7F;
		}


		/*  Not actually required, but for comparison purposes,
		 *  normalize the number.  Remove for production speed.
		 */
		while( (left & 0x00F00000) == 0 && left != 0 )  {
			if( signbit && exp <= 0x41 )  break;

			left = (left << 4) | (right >> (32-4));
			right <<= 4;
			if(signbit)  exp--;
			else exp++;
		}

		*out++ = signbit | exp;
		*out++ = left>>16;
		*out++ = left>>8;
		*out++ = left;
		*out++ = right>>24;
		*out++ = right>>16;
		*out++ = right>>8;
		*out++ = right;
	}
	return;
}
