const int backPin[3]={6,10,5};

void backSetup(void)
{
    pinMode(backPin[0], OUTPUT);
    pinMode(backPin[1], OUTPUT);
    pinMode(backPin[2], OUTPUT);
}

void backSetRVB(uint8_t rouge, uint8_t vert, uint8_t bleu)
{
    analogWrite(backPin[0], rouge);
    analogWrite(backPin[1], vert);
    analogWrite(backPin[2], bleu);
}
