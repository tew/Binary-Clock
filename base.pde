#define BUFFERS_REFRESH_PERIOD  100
#define HOUR_REFRESH_PERIOD  1000

#define KEY_PERIODIC_MS  50

// these constants won't change:
//const int analogPin = A0;   // the pin that the potentiometer is attached to
//const int ledCount = 10;    // the number of LEDs in the bar graph

#include <MsTimer2.h>
#include <Wire.h>
#include <RTClib.h>
#include "event.h"
#include "hour.h"

RTC_DS1307 RTC;

void hourSetup()
{
  unsigned char u8_ret, u8_isRunning;
  Wire.begin();
  RTC.begin();

  u8_isRunning= RTC.isrunning(&u8_ret);
  Serial.print("running ret= ");
  Serial.println(u8_ret, DEC);
  if (! u8_isRunning) {
    Serial.println("RTC is NOT running!");
    // following line sets the RTC to the date & time this sketch was compiled
    RTC.adjust(DateTime(__DATE__, __TIME__));
//  MsTimer2::set(1000, hourPeriodic);
  }
  else
  {
    Serial.println("RTC is running!");
    DateTime mod= DateTime(2011,2,4, 7, 5, 0);
    RTC.adjust(mod);
        DateTime now = RTC.now();
    
    Serial.print(now.year(), DEC);
    Serial.print('/');
    Serial.print(now.month(), DEC);
    Serial.print('/');
    Serial.print(now.day(), DEC);
    Serial.print(' ');
    Serial.print(now.hour(), DEC);
    Serial.print(':');
    Serial.print(now.minute(), DEC);
    Serial.print(':');
    Serial.print(now.second(), DEC);
    Serial.println();
    
    /*Serial.print(" since midnight 1/1/1970 = ");
    Serial.print(now.unixtime());
    Serial.print("s = ");
    Serial.print(now.unixtime() / 86400L);
    Serial.println("d");*/
  }
}
/***********************************************************************/

void periodic(void)
{
  static unsigned long cpt= 0;
  
  cpt+= BUFFERS_REFRESH_PERIOD;
  buffersPeriodic();
  
  if ((cpt % HOUR_REFRESH_PERIOD) == 0) hourPeriodic();
  if ((cpt % KEY_PERIODIC_MS) == 0) keyPeriodic();
}


void periodicSetup()
{
  MsTimer2::set(BUFFERS_REFRESH_PERIOD, periodic);
  MsTimer2::start();
}





void setup() {
  Serial.begin(9600);
  event_init();
  buffersSetup();
  //setupDebug();
  hourSetup();
  periodicSetup();
  
//  hourSetup();
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
      }
      
      if (param == 5)
      {
        hourMM ++;
        if (hourMM>59) hourMM=0;
        hourSS= 0;
      }

      if (param == 4) state= STATE_SECONDS;
      if (param == 4 | 0x80) state= STATE_NORMAL;
      
      //XXX
      if (param == 2)
      {
        hourSetup();
      }
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
  
if ((mil % 1000) == 0)
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
}
}



