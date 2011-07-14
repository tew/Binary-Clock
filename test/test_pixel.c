
/****************************************************************************
 * Standard includes
 ****************************************************************************/
#include <stdint.h>
#include <stdio.h>

/****************************************************************************
 * Project includes
 ****************************************************************************/
#include "pixel.pde"



int main()
{
    uint8_t R,G,B,H,S,L;
    uint16_t i;
    
    S= HLSMAX;
    L= HLSMAX/2;
    printf("H\tS\tL\tR\tG\tB\n");
    for(i=0;i<=HLSMAX;i++)
    {
        pix_calHSLtoRGB(i,S,L,&R,&G,&B);
        //printf("%u\t%u\t%u\t%u\t%u\t%u\n", i,S,L,R,G,B);
    }
    return 0;
}
