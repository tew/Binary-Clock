const int backPin[3]={6,10,5};

void backSetup(void)
{
  pinMode(backPin[0], OUTPUT);
//  analogWrite(backPin[0], 10);
  pinMode(backPin[1], OUTPUT);
//  analogWrite(backPin[1], 128);
  pinMode(backPin[2], OUTPUT);
//  analogWrite(backPin[2], 250);
  backSetRVB(0,128,255);
}

void backSetRVB(uint8_t rouge, uint8_t vert, uint8_t bleu)
{
  if (rouge==0) digitalWrite(backPin[0], 1);
  else analogWrite(backPin[0], 255-rouge);

  if (vert==0) digitalWrite(backPin[1], 1); // reste à 1 seulement ~72ms, pourquoi? les autre pins sont ok
  else analogWrite(backPin[1], 255-vert);
  
  if (bleu==0) digitalWrite(backPin[2], 1);
  else analogWrite(backPin[2], 255-bleu);
}
