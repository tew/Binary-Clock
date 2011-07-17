

#ifdef DEBUG_PIXEL
const uint16_t HLSMAX = 1530;
const uint16_t RGBMAX = 255;
#endif

// conversion RVB<->HSL: http://files.codes-sources.com/fichier.aspx?id=24541&f=Code\Calcul.cpp
int maxi_tbl(int* tbl, int taille)
{
    int i; // bcl
    int result=tbl[0];
    
    for(i=0; i<taille; i++)
    if(result<tbl[i])
    result=tbl[i];
    
    return result;
}

int mini_tbl(int* tbl, int taille)
{
    int i; // bcl
    int result=tbl[0];

    for(i=0; i<taille; i++)
    if(result>tbl[i])
    result=tbl[i];
    
    return result;
}


/* convertit en HSL un pixel au format RVB 888 */
void pix_calRGBtoHSL(uint16_t R, uint16_t G, uint16_t B, uint16_t *pH, uint16_t *pS, uint16_t *pL)
{
    //PixelHSL	Result;
    int tbl[3];

    uint16_t H, L, S;	// Pour récupérer les infos de la fonction
    //uint16_t R, G, B;          /* input RGB values */
    uint16_t cMax,cMin;      /* max and min RGB values */
    uint16_t  Rdelta,Gdelta,Bdelta; /* intermediate value: % of spread from max*/

    // Place mes couleurs dans les variables du code
    tbl[0]= R;
    tbl[1]= G;
    tbl[2]= B;

    /* calculate lightness */
    cMax = maxi_tbl(tbl, 3);
    cMin = mini_tbl(tbl, 3);
    
    L = ( ((uint32_t)(cMax+cMin)*HLSMAX) + RGBMAX )/(2*RGBMAX);

    if (cMax == cMin) {           /* r=g=b --> achromatic case */
        S = 0;                     /* saturation */
        H = (HLSMAX/2);            /* hue */
    }
    else {                        /* chromatic case */
        /* saturation */
        if (L <= (HLSMAX/2))
        S = ( ((uint32_t)(cMax-cMin)*HLSMAX) + ((cMax+cMin)/2) ) / (cMax+cMin);
        else
        S = ( ((uint32_t)(cMax-cMin)*HLSMAX) + ((2*RGBMAX-cMax-cMin)/2) )
        / (2*RGBMAX-cMax-cMin);

        /* hue */
        Rdelta = ( ((uint32_t)(cMax-R)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
        Gdelta = ( ((uint32_t)(cMax-G)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
        Bdelta = ( ((uint32_t)(cMax-B)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);

        if (R == cMax)
        H = Bdelta - Gdelta;
        else if (G == cMax)
        H = (HLSMAX/3) + Rdelta - Bdelta;
        else /* B == cMax */
        H = ((2*HLSMAX)/3) + Gdelta - Rdelta;

        while (H < 0)
        H += HLSMAX;
        if (H > HLSMAX)
        H = H%HLSMAX;
    }

    // Recupère les informations traitées
    *pS=(uint16_t)S;
    *pL=(uint16_t)L;
    /*	if (*S_u8 ==0)
    {
        *pH= PIX_REDUCED_HUE_NB_MAX;
    }
    else
    {*/
    *pH=(uint16_t)H;
    /*}*/
}

//===========================================================================//
// Fonction qui passe de H à RGB ( copier coller du SDK ) //
//===========================================================================//
uint16_t HueToRGB(uint16_t n1,uint16_t n2,int16_t hue)
{


    /* range check: note values passed add/subtract thirds of range */
    while (hue < 0)
    hue += HLSMAX;

    if (hue > HLSMAX)
    hue = hue%HLSMAX;

    /* return r,g, or b value from this tridrant */
    if (hue < (HLSMAX/6))
    return ( n1 + (((uint32_t)(n2-n1)*hue+(HLSMAX/12))/(HLSMAX/6)) );
    if (hue < (HLSMAX/2))
    return ( n2 );
    if (hue < ((HLSMAX*2)/3))
    return ( n1 + (((uint32_t)(n2-n1)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6)));
    else
    return ( n1 );
}


void pix_calHSLtoRGB(uint16_t H, uint16_t S, uint16_t L, uint16_t *pR, uint16_t *pG, uint16_t *pB)
{
    uint16_t R,G,B; /* RGB component values */
    uint16_t Magic1,Magic2; /* calculated magic numbers (really!) */
    uint16_t hue, lum, sat;

    // Initialise les variables
    hue=H;
    sat=S;
    lum=L;

    if (sat == 0) { /* achromatic case */
        R=G=B=(lum*RGBMAX)/HLSMAX;
        if (hue != (HLSMAX/2)) {
            /* ERROR */
        }
    }
    else { /* chromatic case */
        /* set up magic numbers */
        if (lum <= (HLSMAX/2))
        Magic2 = ((uint32_t)lum*(HLSMAX + sat) + (HLSMAX/2))/HLSMAX;
        else
        Magic2 = lum + sat - ((((uint32_t)lum)*sat) + (HLSMAX/2))/HLSMAX;
        Magic1 = 2*lum-Magic2;

        /* get RGB, change units from HLSMAX to RGBMAX */
        R = ((uint32_t)HueToRGB(Magic1,Magic2,hue+(HLSMAX/3))*RGBMAX +(HLSMAX/2))/HLSMAX;
        G = ((uint32_t)HueToRGB(Magic1,Magic2,hue)*RGBMAX + (HLSMAX/2)) / HLSMAX;
        B = ((uint32_t)HueToRGB(Magic1,Magic2,hue-(HLSMAX/3))*RGBMAX +(HLSMAX/2))/HLSMAX;
    }

    *pR= R;
    *pG= G;
    *pB= B;
#ifdef DEBUG_PIXEL
    fprintf(outfile, "%u\t%u\t%u\t%u\t%u\t%u\n", hue, Magic1, Magic2, *pR, *pG, *pB);
#endif
}
