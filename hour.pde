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


/*
void hourSetup()
{
  //MsTimer2::set(1000, hourPeriodic);
}
*/

