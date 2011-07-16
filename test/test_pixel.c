
/****************************************************************************
 * Standard includes
 ****************************************************************************/
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/****************************************************************************
 * Global variables
 ****************************************************************************/
FILE *outfile;

/****************************************************************************
 * Project includes
 ****************************************************************************/
#include "pixel.pde"



int main()
{
    uint16_t R,G,B,H,S,L;
    //uint16_t i;
    
    S= HLSMAX;
    L= HLSMAX/2;
    outfile= fopen("test_pixel.txt", "w+");
    if (!outfile)
    {
        perror("Can nor create file writing");
        exit(1);
    }
    fprintf(outfile, "H\tS\tL\tR\tG\tB\n");
    for(H=0;H<=HLSMAX;H++)
    {
        pix_calHSLtoRGB(H,S,L,&R,&G,&B);
        //printf("%u\t%u\t%u\t%u\t%u\t%u\n", i,S,L,R,G,B);
    }
    
    fclose(outfile);
    return 0;
}
