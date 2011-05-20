const int backPin[3]={6,10,5};

void backSetup(void)
{
  pinMode(backPin[0], OUTPUT);
  digitalWrite(backPin[0], 1);
  pinMode(backPin[1], OUTPUT);
  digitalWrite(backPin[1], 1);
  pinMode(backPin[2], OUTPUT);
  digitalWrite(backPin[2], 1);
  //backSetRVB(0,0,0);
}

void backSetRVB(uint8_t rouge, uint8_t vert, uint8_t bleu)
{
  if (rouge==0) digitalWrite(backPin[0], 1);
  else analogWrite(backPin[0], 255-rouge);

  if (vert==0) digitalWrite(backPin[1], 1); // reste a 1 seulement ~72ms, pourquoi? les autre pins sont ok
  else analogWrite(backPin[1], 255-vert);
  
  if (bleu==0) digitalWrite(backPin[2], 1);
  else analogWrite(backPin[2], 255-bleu);
}
