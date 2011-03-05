
#include <Wire.h>
#include <RTClib.h>


RTC_DS1307 RTC;
unsigned char hourHH=0,hourMM=0, hourSS=0;

void hourPeriodic()
{
  hourSS++;
  if (hourSS > 59)
  {
    hourSS=0;
    hourMM++;
    if (hourMM > 59)
    {
      hourMM=0;
      hourHH++;
      if (hourHH > 23)
      {
        hourHH= 0;
      }
    }
  }
}


void hourDisplay(void)
{
  buffersSetValues(hourHH,hourMM);
}


void hourDisplaySeconds(void)
{
  buffersSetValues(hourMM,hourSS);
}



void hourSetup()
{
//  unsigned char u8_ret, u8_isRunning;
  Wire.begin();
  RTC.begin();

//  u8_isRunning= ;
//  Serial.print("running ret= ");
//  Serial.println(u8_ret, DEC);
  if (! RTC.isrunning()) {
    Serial.println("RTC is NOT running!");
    // following line sets the RTC to the date & time this sketch was compiled
//    RTC.adjust(DateTime(__DATE__, __TIME__));
    DateTime mod= DateTime(2011,2,5, 11, 23, 0);
    RTC.adjust(mod);
  }
  else
  {
    Serial.println("RTC is running!");
//    DateTime mod= DateTime(2011,2,5, 11, 38, 15);
//    RTC.adjust(mod);
    DateTime now = RTC.now();
    
    hourHH= now.hour();
    hourMM= now.minute();
    hourSS= now.second();
    
/*    Serial.print(now.year(), DEC);
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
    Serial.println();*/
    
    /*Serial.print(" since midnight 1/1/1970 = ");
    Serial.print(now.unixtime());
    Serial.print("s = ");
    Serial.print(now.unixtime() / 86400L);
    Serial.println("d");*/
  }
}


