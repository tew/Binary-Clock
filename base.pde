
/* This project uses 2 libraries

http://www.arduino.cc/playground/uploads/Main/MsTimer2.zip
git://github.com/adafruit/RTClib.git

*/


#define BUFFERS_REFRESH_PERIOD  100
#define HOUR_REFRESH_PERIOD  1000

#define KEY_PERIODIC_MS  50

#include <MsTimer2.h>
#include "event.h"
#include "hour.h"


/***********************************************************************/
void periodic(void)
{
  static unsigned long cpt= 0;
  
  cpt+= BUFFERS_REFRESH_PERIOD;
  buffersPeriodic();
  
  if ((cpt % HOUR_REFRESH_PERIOD) == 0) hourPeriodic();
  if ((cpt % KEY_PERIODIC_MS) == 0) keyPeriodic();
}


/***********************************************************************/
void periodicSetup()
{
  MsTimer2::set(BUFFERS_REFRESH_PERIOD, periodic);
  MsTimer2::start();
}


/***********************************************************************/
void setup() {
  //Serial.begin(9600);
  event_init();
  buffersSetup();
  //setupDebug();
  hourSetup();
  periodicSetup();
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



