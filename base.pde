/*
  LED bar graph
 
  Turns on a series of LEDs based on the value of an analog sensor.
  This is a simple way to make a bar graph display. Though this graph
  uses 10 LEDs, you can use any number by changing the LED count
  and the pins in the array.
  
  This method can be used to control any series of digital outputs that
  depends on an analog input.
 
  The circuit:
   * LEDs from pins 2 through 11 to ground
 
 created 4 Sep 2010
 by Tom Igoe 

 This example code is in the public domain.
 
 http://www.arduino.cc/en/Tutorial/BarGraph
 */


// these constants won't change:
//const int analogPin = A0;   // the pin that the potentiometer is attached to
//const int ledCount = 10;    // the number of LEDs in the bar graph

#include <MsTimer2.h>
//#include <Wire.h>
//#include <RTClib.h>

#define  BUFFERS_NB_BUFFERS  2
#define  BUFFERS_NB_LEDS  6

/*#define  BUFFERS_WITH_DIMMING
#ifdef BUFFERS_WITH_DIMMING
#define  BUFFERS_NB_LEVELS  4
unsigned char buffersLuminosity[BUFFERS_NB_BUFFERS][BUFFERS_NB_LEDS]= {
  {5,4,3,2,1,0}, {10,10,10,10,10,10}
};
#define BUFFERS_REFRESH_PERIOD  5
#else*/
#define BUFFERS_REFRESH_PERIOD  100
//#endif  // BUFFERS_WITH_DIMMING

// partie buffers
int bufferDataPins[BUFFERS_NB_LEDS]={0,1,2,3,4,5};
int bufferLatchEnablePins[BUFFERS_NB_BUFFERS]= {8, A3};
int bufferOutputEnable= 9;

unsigned char buffersValues[BUFFERS_NB_BUFFERS]={0,0};
 
void debugDown()
{
  digitalWrite(A5, LOW);
}

void debugUp()
{
  digitalWrite(A5, HIGH);
}

void setupDebug()
{
  pinMode(A5, OUTPUT);
}

void buffersSetRaw(int noBuffer, int value)
{
//  unsigned char mask=1;
//  unsigned char cur;
  
//  for(int pin=0; pin < sizeof(bufferDataPins); pin++) {
  value &= 0x3F;  // 6 bits conservés
  PORTD= value;
  digitalWrite(bufferLatchEnablePins[noBuffer], HIGH);
  digitalWrite(bufferLatchEnablePins[noBuffer], LOW);
}

void buffersPeriodic()
{
  unsigned char mask,noBuffer;
  debugUp();
/*#ifdef BUFFERS_WITH_DIMMING
  static int cpt= 0;
  int noLed;
  
  cpt++;
  cpt %= BUFFERS_NB_LEVELS;
#endif*/

  for(noBuffer=0; noBuffer<BUFFERS_NB_BUFFERS; noBuffer++)
  {
    mask= buffersValues[noBuffer];
/*#ifdef BUFFERS_WITH_DIMMING
    for(noLed=0; noLed<BUFFERS_NB_LEDS; noLed++)
    {
      if (buffersLuminosity[noBuffer][noLed]<cpt) mask &= ~(1<<noLed);
    }
#endif*/
    buffersSetRaw(noBuffer, mask);
  }
  debugDown();
}

void buffersSetup()
{
  // loop over the pin array and set them all to output:
  for (int pin = 0; pin < sizeof(bufferDataPins); pin++) {
    pinMode(bufferDataPins[pin], OUTPUT); 
  }
  for (int pin = 0; pin < sizeof(bufferLatchEnablePins); pin++) {
    pinMode(bufferLatchEnablePins[pin], OUTPUT); 
  }
  pinMode(bufferOutputEnable, OUTPUT);
  analogWrite(bufferOutputEnable, 240);  // 50% par défaut

  MsTimer2::set(BUFFERS_REFRESH_PERIOD, buffersPeriodic);
  MsTimer2::start();
}

void buffersSetValues(unsigned char a, unsigned char b)
{
  buffersValues[0]= a;
  buffersValues[1]= b;
}


unsigned char hourHH=0,hourMM=0, hourSS=0;
/*void hourPeriodic()
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

void hourSetup()
{
  //MsTimer2::set(1000, hourPeriodic);
}
*/
//RTC_DS1307 RTC;

/***********************************************************************/

int keyDataPin= 1;

void keySetup()
{
    pinMode(keyDataPin, INPUT); 
}

const int val2key[14]={1, 0, 0, 0, 0, 2, 0, 0, 4, 3, 0, 5, 6, 7};
int keyLoop()
{
  int val= analogRead(keyDataPin);
  Serial.print(val, DEC);
//  val= val*7/1024;
  val=map(val, 0, 1023, 0, 31);
  if (val < 15) val= 0;
  else val= val2key[val-15];
  Serial.print(" => ");
  Serial.println(val, DEC);
  return(val);
}
  
void setup() {
  Serial.begin(9600);
  buffersSetup();
  setupDebug();
//  hourSetup();
//  Wire.begin();
//  RTC.begin();

  /*if (! RTC.isrunning())*/ {
    Serial.println("RTC is NOT running!");
    // following line sets the RTC to the date & time this sketch was compiled
    //RTC.adjust(DateTime(__DATE__, __TIME__));
  }
  
  
}

void loop() {
#ifdef BUFFERS_WITH_DIMMING
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
  else hh=0xff;*/
#endif
  unsigned long mil= millis();
  
  mil /= 1000;
  hourSS= mil % 60;
  mil /= 60;
  hourMM= mil % 60;
  mil /= 60;
  hourHH= mil % 24;
  
  //DateTime now = RTC.now();
  //hourMM= now.minute();
  //hourSS= now.second();
  hourMM=0;
  hourSS= keyLoop();
  buffersSetValues(hourMM,hourSS);
}



