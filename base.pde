
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
unsigned long cpt_ms= 0;
unsigned long cpt_buffers=0;
unsigned long cpt_hour=0;
unsigned long cpt_key=0;

// backlight related variables
const uint16_t HLSMAX = 1530;
const uint16_t RGBMAX = 255;

// management of back LEDs
uint16_t	bck[3];	// this hold RGB (mode_rgb=1) or HSL (mode_rgb=0) values
uint8_t mode_rgb= 1;
uint8_t	bck_tempo=0;	// divisor for soem states

enum {
	BCK_OFF,
	BCK_STATIC,
	BCK_HUE_SHIFT_SLOW,
	BCK_HUE_SHIFT,
	BCK_HUE_SHIFT_FAST,
	BCK_MANUAL,
	BCK_NB
};
uint8_t state_bck= BCK_MANUAL;

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
    
    cpt_ms++;
    if (cpt_ms == 100)
    {
      cpt_ms= 0;
      event_addEvent(EVENT_BCK, 0);
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
  
  
/* state of pink LEDs. Those LEDs normally display the time (hours and minutes) */
enum {
  PINK_NORMAL,	// hour+minutes
  PINK_SECONDS,	// minutes+seconds
  PINK_OFF
};

unsigned char state_pink= PINK_NORMAL;

void bck_plus(uint16_t *value)
{
	(*value)++;
	
	if (mode_rgb)
        {
          if ((*value) > RGBMAX) (*value)= 0;
        }
        else
	{
          if ((*value) > HLSMAX) (*value)= 0;
	}
}

void bck_moins(uint16_t *value)
{
	(*value)--;
	
	if (mode_rgb)
        {
          if ((*value) > RGBMAX) (*value)= RGBMAX;
        }
        else
	{
          if ((*value) > HLSMAX) (*value)= HLSMAX;
	}
}

void manage_bck(void)
{
	static uint8_t divisor= 0;
	
	switch(state_bck)
	{
		case BCK_STATIC:
			break;

		case BCK_HUE_SHIFT_FAST:
			bck[0]= (bck[0]+2)%HLSMAX;
			refreshBacklight();
			break;

		case BCK_HUE_SHIFT:
			bck[0]=(bck[0]+1)%HLSMAX;
			refreshBacklight();
			break;

		case BCK_HUE_SHIFT_SLOW:
			divisor= (divisor+1)%2;
			if (!divisor)
			{
				bck[0]=(bck[0]+1)%HLSMAX;
				refreshBacklight();
			}
			break;

		case BCK_MANUAL:
			break;

		case BCK_OFF:
		default:
			state_bck= BCK_OFF;
			break;
        /*if (!mode_rgb)
        {
          bck_plus(&bck[0]); refreshBacklight();
        }*/
        }
}

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

      if (param == 4) state_pink= PINK_SECONDS;
      if (param == 4 | 0x80) state_pink= PINK_NORMAL;
      
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
        case 0: bck[0]= bck[1]= bck[2]=   0; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 1: bck[0]= bck[1]= bck[2]=   1; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 2: bck[0]= bck[1]= bck[2]=  10; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 3: bck[0]= bck[1]= bck[2]=  50; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 4: bck[0]= bck[1]= bck[2]= 100; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 5: bck[0]= bck[1]= bck[2]= 150; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 6: bck[0]= bck[1]= bck[2]= 200; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 7: bck[0]= bck[1]= bck[2]= 253; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 8: bck[0]= bck[1]= bck[2]= 254; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 9: bck[0]= bck[1]= bck[2]= 255; backSetRVB(bck[0], bck[1], bck[2]); break;
        case IR_PLUS: bck_plus(&bck[0]); bck_plus(&bck[1]); bck_plus(&bck[2]); refreshBacklight(); break;
        case IR_MOINS: bck_moins(&bck[0]); bck_moins(&bck[1]); bck_moins(&bck[2]); refreshBacklight(); break;
        case IR_R_PLUS: bck_plus(&bck[0]); refreshBacklight(); break;
        case IR_R_MOINS: bck_moins(&bck[0]); refreshBacklight(); break;
        case IR_G_PLUS: bck_plus(&bck[1]); refreshBacklight(); break;
        case IR_G_MOINS: bck_moins(&bck[1]); refreshBacklight(); break;
        case IR_B_PLUS: bck_plus(&bck[2]); refreshBacklight(); break;
        case IR_B_MOINS: bck_moins(&bck[2]); refreshBacklight(); break;
		case IR_MODIFY_HSL:
			if (mode_rgb)
			{
				// convertir RGB en HSL;
                Serial.print("Convert RGB2HSL: ");
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.print(bck[2], DEC);
                Serial.print("->");
		pix_calRGBtoHSL(bck[0], bck[1], bck[2], &bck[0], &bck[1], &bck[2]);
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.println(bck[2], DEC);
                                Serial.println("Mode HSL");
				mode_rgb= 0;
			}
			break;
		case IR_MODIFY_RGB:
			if (!mode_rgb)
			{
				// convertir RGB en HSL;
				pix_calHSLtoRGB(bck[0], bck[1], bck[2], &bck[0], &bck[1], &bck[2]);
                                Serial.println("Mode RGB");
				mode_rgb= 1;
			}
			break;
		
		// playing cases
		case IR_HUE_SHIFT:
			switch (state_bck)
			{
				case BCK_HUE_SHIFT_SLOW: state_bck= BCK_HUE_SHIFT; break;
				case BCK_HUE_SHIFT:		 state_bck= BCK_HUE_SHIFT_FAST; break;
				case BCK_HUE_SHIFT_FAST: state_bck= BCK_STATIC; break;
				default: state_bck= BCK_HUE_SHIFT_SLOW; break;
			}
			break;
			
		case IR_STOP:
			state_bck= BCK_OFF;
			break;
      }
      break;

      case EVENT_BCK:
		manage_bck();
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
  if  (getKey() == 4) state_pink= PINK_SECONDS;
  else state_pink= PINK_NORMAL;
  
  switch(state_pink)
  {
    case PINK_NORMAL:
      hourDisplay();
      break;
      
    case PINK_SECONDS:
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
	uint16_t	v1,v2,v3;

	if (!mode_rgb)
	{
		// convertir en RGB
                Serial.print("Convert HSL2RGB: ");
		pix_calHSLtoRGB(bck[0], bck[1], bck[2], &v1, &v2, &v3);
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.print(bck[2], DEC);
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
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.println(bck[2], DEC);
        	backSetRVB(bck[0], bck[1], bck[2]);
        }
}



