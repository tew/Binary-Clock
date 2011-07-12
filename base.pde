
/* This project uses 3 libraries

http://www.arduino.cc/playground/uploads/Main/MsTimer2.zip
git://github.com/adafruit/RTClib.git

IR library available at
http://www.arcfn.com/2009/08/multi-protocol-infrared-remote-library.html
http://arcfn.com/files/IRremote.zip
However IRlibrary and MSTimers2 both use the timer2 interrupt.
We need to modify them to make them compatible. So their are included in the code, not as library.

*/

#define PERIODIC_BASE_US  50
#define BUFFERS_REFRESH_PERIOD_MS  100UL
#define HOUR_REFRESH_PERIOD_MS  1000UL
#define KEY_PERIODIC_MS  50UL

#include "MsTimer2.h"
#include "event.h"
#include "hour.h"


unsigned long cpt_us= 0;
unsigned long cpt_buffers=0;
unsigned long cpt_hour=0;
unsigned long cpt_key=0;
uint8_t Rbck,Gbck,Bbck= 0;
//uint8_t Hbck,Sbck,Lbck= 0;
uint8_t mode_rgb= 1;

/***********************************************************************/
void periodic(void)
{
//digitalWrite(11, HIGH); //debugUp();
  irPeriodic();  // 12,4µs
  cpt_us+= PERIODIC_BASE_US;  // 6,8µs
  
  if (cpt_us>=1000)
  {
    cpt_us -= 1000;
    cpt_buffers++;  // 6.4µs
    if (cpt_buffers == BUFFERS_REFRESH_PERIOD_MS)  // 20µs
    {
      cpt_buffers= 0;
      buffersPeriodic();
    }

    cpt_hour++;  // 6.4µs
    if (cpt_hour == HOUR_REFRESH_PERIOD_MS) {  // 1.4µs
      cpt_hour= 0;
      event_addEvent(EVENT_HOUR, 0);
    }

    cpt_key++;  // 6.6µs
    if (cpt_key == KEY_PERIODIC_MS) {
      cpt_key= 0;
      keyPeriodic();
    }
  }
//digitalWrite(11, LOW); //debugDown();
}


/***********************************************************************/
void periodicSetup()
{
  MsTimer2::set(periodic);  // it period is 50µs, we need a call each it
  MsTimer2::start();
}


/***********************************************************************/
void setup() {
  Serial.begin(9600);
  backSetup();
  event_init();
  buffersSetup();
  //setupDebug();
  hourSetup();
  periodicSetup();
  irSetup();
  setupDebug();
}
  
  

enum {
  STATE_NORMAL,
  STATE_SECONDS
};

unsigned char state= STATE_NORMAL;

//#define  KEY_PRERIOD_MS  500
//unsigned char keyState= 0;
//int key;
void loop() {
/*#ifdef BUFFERS_WITH_DIMMING
  static int i,j;
  const unsigned char levels[]={0,1,2,4,2,1};

//  buffersSetValues(hh,mm);
  delay(150);
  
  i++;
  i%=6;
  //i%=7;
  for(j=0; j<6; j++)
  {
    buffersLuminosity[0][j]=levels[i]; //(i)%BUFFERS_NB_LEVELS;
  }
/*  buffersValue(0, hh);
  buffersValue(1, hh);
  delay(100);
  if (hh) hh=0;
  else hh=0xff;r/
#endif*/
  unsigned long mil= millis();
  
  //if ((mil % KEY_PRERIOD_MS) == 0)
  {
    //keyState++;
    //Serial.println(keyState, DEC);
    //key= keyLoop();
    
    /*if (key && (keyState==0))
    {
      // on a un appui touche
      gererKey(key);
      //key+=32;
    }*/
    //keyState= key;
//    hourSS= keyState;
  }
/*  int ss,mm,hh;
  mil /= 1000;
  ss= mil % 60;
  mil /= 60;
  mm= mil % 60;
  mil /= 60;
  hh= mil % 24;
  */
  //DateTime now = RTC.now();
  //hourMM= now.minute();
  //hourSS= now.second();
/*  hourMM=0;
  hourSS= keyLoop();*/
//  keyState= hourSS+1;
  irLoop();
  unsigned char event, param;
  
  event= event_getEvent(0, &param);
  switch (event)
  {
    case EVENT_KEY:
      if (param == 3)
      {
        hourHH ++;
        if (hourHH>23) hourHH=0;
        hourRTCsave();
      }
      
      if (param == 5)
      {
        hourMM ++;
        if (hourMM>59) hourMM=0;
        hourSS= 0;
        hourRTCsave();
      }

      if (param == 4) state= STATE_SECONDS;
      if (param == 4 | 0x80) state= STATE_NORMAL;
      
      //XXX
      if (param == 2)
      {
        hourSetup();
      }
      break;
      
    case EVENT_IR:
      //hourHH= param;
      switch(param)
      {
        case 0: Rbck= Gbck= Bbck=   0; backSetRVB(Rbck, Gbck, Bbck); break;
        case 1: Rbck= Gbck= Bbck=   1; backSetRVB(Rbck, Gbck, Bbck); break;
        case 2: Rbck= Gbck= Bbck=  10; backSetRVB(Rbck, Gbck, Bbck); break;
        case 3: Rbck= Gbck= Bbck=  50; backSetRVB(Rbck, Gbck, Bbck); break;
        case 4: Rbck= Gbck= Bbck= 100; backSetRVB(Rbck, Gbck, Bbck); break;
        case 5: Rbck= Gbck= Bbck= 150; backSetRVB(Rbck, Gbck, Bbck); break;
        case 6: Rbck= Gbck= Bbck= 200; backSetRVB(Rbck, Gbck, Bbck); break;
        case 7: Rbck= Gbck= Bbck= 253; backSetRVB(Rbck, Gbck, Bbck); break;
        case 8: Rbck= Gbck= Bbck= 254; backSetRVB(Rbck, Gbck, Bbck); break;
        case 9: Rbck= Gbck= Bbck= 255; backSetRVB(Rbck, Gbck, Bbck); break;
        case IR_PLUS: Rbck++; Gbck++; Bbck++; refreshBacklight(); break;
        case IR_MOINS: Rbck--; Gbck--; Bbck--; refreshBacklight(); break;
        case IR_R_PLUS: Rbck++; refreshBacklight(); break;
        case IR_R_MOINS: Rbck--; refreshBacklight(); break;
        case IR_G_PLUS: Gbck++; refreshBacklight(); break;
        case IR_G_MOINS: Gbck--; refreshBacklight(); break;
        case IR_B_PLUS: Bbck++; refreshBacklight(); break;
        case IR_B_MOINS: Bbck--; refreshBacklight(); break;
		case IR_MODIFY_HSL:
			if (mode_rgb)
			{
				// convertir RGB en HSL;
				pix_calRGBtoHSL(Rbck, Gbck, Bbck, &Rbck, &Gbck, &Bbck);
                                Serial.println("Mode HSL");
				mode_rgb= 0;
			}
			break;
		case IR_MODIFY_RGB:
			if (!mode_rgb)
			{
				// convertir RGB en HSL;
				pix_calHSLtoRGB(Rbck, Gbck, Bbck, &Rbck, &Gbck, &Bbck);
                                Serial.println("Mode RGB");
				mode_rgb= 1;
			}
			break;
      }
      break;

/*    case EVENT_IR_PLUS:
      hourHH++;
      bck++;
      backSetRVB(bck, bck, bck);
      break;
      
    case EVENT_IR_MOINS:
      hourHH--;
      bck--;
      backSetRVB(bck, bck, bck);
      break;
  */
	case EVENT_HOUR:
	  hourPeriodic();
	  break;
    // no event
    default:
      luminoPeriodic();
      break;
  }
  if  (getKey() == 4) state= STATE_SECONDS;
  else state= STATE_NORMAL;
  
  switch(state)
  {
    case STATE_NORMAL:
      hourDisplay();
      break;
      
    case STATE_SECONDS:
      hourDisplaySeconds();
      break;
  }
/*if ((mil % 1000) == 0)
{
  DateTime now = RTC.now();

  hourSS=now.second();
  hourMM=now.minute();
  hourHH=now.hour();
    Serial.print(hourHH, DEC);
    Serial.print(':');
    Serial.print(hourMM, DEC);
    Serial.print(':');
    Serial.print(hourSS, DEC);
    Serial.println();
}*/
}

void refreshBacklight(void)
{
	uint8_t	v1,v2,v3;

	if (!mode_rgb)
	{
		// convertir en RGB
                Serial.print("Convert HSL2RGB: ");
		pix_calHSLtoRGB(Rbck, Gbck, Bbck, &v1, &v2, &v3);
                Serial.print(Rbck, DEC);
                Serial.print('.');
                Serial.print(Gbck, DEC);
                Serial.print('.');
                Serial.print(Bbck, DEC);
                Serial.print("->");
                Serial.print(v1, DEC);
                Serial.print('.');
                Serial.print(v2, DEC);
                Serial.print('.');
                Serial.println(v3, DEC);
        	backSetRVB(v1, v2, v3);
	}
        else
        {
                Serial.print("Set RGB: ");
                Serial.print(Rbck, DEC);
                Serial.print('.');
                Serial.print(Gbck, DEC);
                Serial.print('.');
                Serial.println(Bbck, DEC);
        	backSetRVB(Rbck, Gbck, Bbck);
        }
}


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
void pix_calRGBtoHSL(uint8_t R_u8, uint8_t G_u8, uint8_t B_u8, uint8_t *H_u8, uint8_t *S_u8, uint8_t *L_u8)
{
	//PixelHSL	Result;
	int tbl[3];

	uint16_t H, L, S;	// Pour récupérer les infos de la fonction
	//uint8_t R_u8, G_u8, B_u8;
    uint16_t R, G, B;          /* input RGB values */
    uint8_t cMax,cMin;      /* max and min RGB values */
    uint16_t  Rdelta,Gdelta,Bdelta; /* intermediate value: % of spread from max*/
	const uint16_t HLSMAX = 240;
	const uint16_t RGBMAX = 255;

	// Place mes couleurs dans les variables du code
	tbl[0]=R= R_u8;
	tbl[1]=G= G_u8;
	tbl[2]=B= B_u8;

    /* calculate lightness */
    cMax = maxi_tbl(tbl, 3);
    cMin = mini_tbl(tbl, 3);
    
    L = ( ((cMax+cMin)*HLSMAX) + RGBMAX )/(2*RGBMAX);

    if (cMax == cMin) {           /* r=g=b --> achromatic case */
        S = 0;                     /* saturation */
        H = 255;             /* hue */
	}
    else {                        /* chromatic case */
        /* saturation */
        if (L <= (HLSMAX/2))
           S = ( ((cMax-cMin)*HLSMAX) + ((cMax+cMin)/2) ) / (cMax+cMin);
        else
           S = ( ((cMax-cMin)*HLSMAX) + ((2*RGBMAX-cMax-cMin)/2) )
              / (2*RGBMAX-cMax-cMin);

	    /* hue */
	    Rdelta = ( ((cMax-R)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
		Gdelta = ( ((cMax-G)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
		Bdelta = ( ((cMax-B)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);

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
	*S_u8=(unsigned char)S;
	*L_u8=(unsigned char)L;
/*	if (*S_u8 ==0)
	{
		*H_u8= PIX_REDUCED_HUE_NB_MAX;
	}
	else
	{*/
		*H_u8=(unsigned char)H;
	/*}*/
}

 //===========================================================================//
 // Fonction qui passe de H à RGB ( copier coller du SDK ) //
 //===========================================================================//
 uint16_t HueToRGB(uint16_t n1,uint16_t n2,uint16_t hue)
 {
 const uint16_t HLSMAX = 240;

 /* range check: note values passed add/subtract thirds of range */
 while (hue < 0)
 hue += HLSMAX;

 if (hue > HLSMAX)
 hue = hue%HLSMAX;

 /* return r,g, or b value from this tridrant */
 if (hue < (HLSMAX/6))
 return ( n1 + (((n2-n1)*hue+(HLSMAX/12))/(HLSMAX/6)) );
 if (hue < (HLSMAX/2))
 return ( n2 );
 if (hue < ((HLSMAX*2)/3))
 return ( n1 + (((n2-n1)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6)));
 else
 return ( n1 );
}


void pix_calHSLtoRGB(uint8_t H_u8, uint8_t S_u8, uint8_t L_u8, uint8_t *R_u8, uint8_t *G_u8, uint8_t *B_u8)
{
	const uint16_t HLSMAX = 240;
	const uint16_t RGBMAX = 255;

	uint16_t R,G,B; /* RGB component values */
	uint16_t Magic1,Magic2; /* calculated magic numbers (really!) */
	uint16_t hue, lum, sat;

	// Initialise les variables
	hue=H_u8;
	sat=S_u8;
	lum=L_u8;

	if (sat == 0) { /* achromatic case */
		R=G=B=(lum*RGBMAX)/HLSMAX;
		if (hue != 120) {
			/* ERROR */
		}
	}
	else { /* chromatic case */
		/* set up magic numbers */
		if (lum <= (HLSMAX/2))
			Magic2 = (lum*(HLSMAX + sat) + (HLSMAX/2))/HLSMAX;
		else
			Magic2 = lum + sat - ((lum*sat) + (HLSMAX/2))/HLSMAX;
		Magic1 = 2*lum-Magic2;

		/* get RGB, change units from HLSMAX to RGBMAX */
		R = (HueToRGB(Magic1,Magic2,hue+(HLSMAX/3))*RGBMAX +(HLSMAX/2))/HLSMAX;
		G = (HueToRGB(Magic1,Magic2,hue)*RGBMAX + (HLSMAX/2)) / HLSMAX;
		B = (HueToRGB(Magic1,Magic2,hue-(HLSMAX/3))*RGBMAX +(HLSMAX/2))/HLSMAX;
	}

	*R_u8= R;
	*G_u8= G;
	*B_u8= B;
} 
