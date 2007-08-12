#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#import  <assert.h>
#import  <sys/types.h>


extern int cnxptiee(char *from, int fromtype, char *to, int totype);
int IEEEtoIBM(double *ieee, double *ibm );

int main(int argc, char *argv)
{
  double ieee;
  double ibm_sas, ieee_sas;
  double ibm_our, ieee_our;
  char *ibm_sas_c = (char*) &ibm_sas;
  char *ibm_our_c = (char*) &ibm_our;


  for(int i=0; i<10; i++)
    {
      ieee = pow(2.0, ((double) i)) + 1.0 + 1.0 / ( ((double) i) + 1.0);

      /* from ieee to ibm, SAS code */
      cnxptiee( (char*) &ieee, 0, (char*) &ibm_sas, 1 );

      /* and back again, SAS code */
      cnxptiee( (char*) &ibm_sas, 1, (char*) &ieee_sas, 0  ); 
     

      /* from ieee to ibm, our code */
      IEEEtoIBM( &ieee, &ibm_our );

      /* and back again, SAS code */
      cnxptiee( (char*) &ibm_our, 1, (char*) &ieee_our, 0  );


      printf("i=%5d, ieee=%10f, ieee_sas=%10f ieee_our=%10f \n", i, 
	     ieee, ieee_sas, ieee_our);

      for(int index=0; index<8; index++)
	{
	  printf("  ");
	  printf("%2x ", ibm_sas_c[index]);
	  printf("%2x ", ibm_our_c[index]);
	  printf("\n");
	}
      printf("\n");

    }

  return 0;
}

