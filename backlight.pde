const int backPin[3]={6,10,5};

void backSetup(void)
{
  pinMode(backPin[0], OUTPUT);
//  digitalWrite(backPin[0], 0);
  pinMode(backPin[1], OUTPUT);
//  digitalWrite(backPin[1], 0);
  pinMode(backPin[2], OUTPUT);
//  digitalWrite(backPin[2], 0);
  //backSetRVB(0,0,0);
}

void backSetRVB(uint8_t rouge, uint8_t vert, uint8_t bleu)
{
  analogWrite(backPin[0], rouge);
  analogWrite(backPin[1], vert);
  analogWrite(backPin[2], bleu);
  
  if (rouge || vert ||bleu) luminoSetState(0);
  else luminoSetState(1);
}
