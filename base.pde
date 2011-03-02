#define BUFFERS_REFRESH_PERIOD  100
#define HOUR_REFRESH_PERIOD  1000

#define KEY_PERIODIC_MS  50

// these constants won't change:
//const int analogPin = A0;   // the pin that the potentiometer is attached to
//const int ledCount = 10;    // the number of LEDs in the bar graph

#include <MsTimer2.h>
//#include <Wire.h>
//#include <RTClib.h>

 
/*
void hourSetup()
{
  //MsTimer2::set(1000, hourPeriodic);
}
*/

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



//RTC_DS1307 RTC;

void setup() {
  //Serial.begin(9600);
  event_init();
  buffersSetup();
  //setupDebug();
  periodicSetup();
//  hourSetup();
//  Wire.begin();
//  RTC.begin();

  /*if (! RTC.isrunning())*/ {
    //Serial.println("RTC is NOT running!");
    // following line sets the RTC to the date & time this sketch was compiled
    //RTC.adjust(DateTime(__DATE__, __TIME__));
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
  hourDisplay();
}



