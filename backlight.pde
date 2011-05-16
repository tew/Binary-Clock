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
  analogWrite(backPin[0], 255-rouge);
  pinMode(backPin[1], OUTPUT);
  analogWrite(backPin[1], 255-vert);
  pinMode(backPin[2], OUTPUT);
  analogWrite(backPin[2], 255-bleu);
}
