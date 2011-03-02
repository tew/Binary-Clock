

#define  BUFFERS_NB_BUFFERS  2
#define  BUFFERS_NB_LEDS  6


// partie buffers
int bufferDataPins[BUFFERS_NB_LEDS]={0,1,2,3,4,5};
int bufferLatchEnablePins[BUFFERS_NB_BUFFERS]= {8, A3};
int bufferOutputEnable= 9;

unsigned char buffersValues[BUFFERS_NB_BUFFERS]={0,0};

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
#define HOUR_REFRESH_PERIOD  1000

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
  //debugUp();
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
  //debugDown();
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

}

void buffersSetValues(unsigned char a, unsigned char b)
{
  buffersValues[0]= a;
  buffersValues[1]= b;
}


