
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
uint8_t bck= 0;

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
      hourHH= param;
      if (param==0) { bck= 0; backSetRVB(bck, bck, bck); }
      else if (param==1) { bck= 1; backSetRVB(bck, bck, bck); }
      else if (param==2) { bck= 2; backSetRVB(bck, bck, bck); }
      else if (param==3) { bck= 50; backSetRVB(bck, bck, bck); }
      else if (param==4) { bck= 100; backSetRVB(bck, bck, bck); }
      else if (param==5) { bck= 150; backSetRVB(bck, bck, bck); }
      else if (param==6) { bck= 200; backSetRVB(bck, bck, bck); }
      else if (param==7) { bck= 253; backSetRVB(bck, bck, bck); }
      else if (param==8) { bck= 254; backSetRVB(bck, bck, bck); }
      else if (param==9) { bck= 255; backSetRVB(bck, bck, bck); }
      break;

    case EVENT_IR_PLUS:
      hourHH++;
      bck++;
      backSetRVB(bck, bck, bck);
      break;
      
    case EVENT_IR_MOINS:
      hourHH--;
      bck--;
      backSetRVB(bck, bck, bck);
      break;
    
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



