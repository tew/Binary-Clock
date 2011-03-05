
//#include <Wire.h>
//#include <RTClib.h>


//RTC_DS1307 RTC;
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



/*void hourSetup()
{
  Wire.begin();
  RTC.begin();

  if (! RTC.isrunning()) {
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
    
    /rSerial.print(" since midnight 1/1/1970 = ");
    Serial.print(now.unixtime());
    Serial.print("s = ");
    Serial.print(now.unixtime() / 86400L);
    Serial.println("d");r/
  }
}*/


