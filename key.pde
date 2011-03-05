
int keyDataPin= 1;

void keySetup()
{
    pinMode(keyDataPin, INPUT); 
}


unsigned char currentKey= 0;
const unsigned char val2key[14]={1, 0, 0, 0, 0, 2, 0, 0, 4, 3, 0, 5, 6, 7};
void keyPeriodic()
{
  int val= analogRead(keyDataPin);
  unsigned char newKey;
//  Serial.print(val, DEC);
//  val= val*7/1024;
  val=map(val, 0, 1023, 0, 31);
  if (val < 15) newKey= 0;
  else newKey= val2key[val-15];
  //Serial.print(" => ");
  //Serial.println(val, DEC);
  //return(val);
/*  if (((currentKey == 1) || (currentKey == 0)) && (val != 0))
  {
    gererKey(val);
  }*/
  if (currentKey != newKey)
  {
    Serial.print(newKey, DEC);
    // si touche relachée, on ajoute 0x80
    if ((currentKey) && (newKey == 0)) newKey= 0x80 | currentKey;
    
    event_addEvent(EVENT_KEY, newKey);
    currentKey= newKey;
  }
}
  

void gererKey(int key)
{
  if (key == 3)
  {
    hourHH ++;
    if (hourHH>23) hourHH=0;
  }
  
  if (key == 5)
  {
    hourMM ++;
    if (hourMM>59) hourMM=0;
  }
  
}


unsigned char getKey(void)
{
  return(currentKey);
}

