#include "IRremote.h"

int RECV_PIN = 7;
IRrecv irrecv(RECV_PIN);
decode_results results;

void irSetup(void)
{
  irrecv.enableIRIn(); // Start the receiver
}

void irPeriodic(void)
{
  irrecv.irPeriodic();
}

void irLoop(void)
{
  int decoded,i;
  decoded= irrecv.decode(&results);
  if (decoded) {
    Serial.print(decoded, DEC);
    Serial.print(": ");
    Serial.print(results.value, HEX);
    Serial.println("");
    irrecv.resume(); // Receive the next value
    
    switch (results.value)
    {
      case 0x4BB6A956: event_addEvent(EVENT_IR, 0); break;
      case 0x4B3632CD: event_addEvent(EVENT_IR, 1); break;
      case 0x4BB622DD: event_addEvent(EVENT_IR, 2); break;
      case 0x4B3618E7: event_addEvent(EVENT_IR, 3); break;
      case 0x4B36B24D: event_addEvent(EVENT_IR, 4); break;
      case 0x4B36728D: event_addEvent(EVENT_IR, 5); break;
      case 0x4B369867: event_addEvent(EVENT_IR, 6); break;
      case 0x4BB69A65: event_addEvent(EVENT_IR, 7); break;
      case 0x4B3622DD: event_addEvent(EVENT_IR, 8); break;
      case 0x4B3642BD: event_addEvent(EVENT_IR, 9); break;//
      case 0x4BB640BF: event_addEvent(EVENT_IR_PLUS, 0); break;
      case 0x4BB6C03F: event_addEvent(EVENT_IR_MOINS, 0); break;
      //default: event_addEvent(EVENT_IR, 63); break;
    }
  }
  else
  {
/*    Serial.print(decoded, DEC);
    Serial.print(": ");
    Serial.print(results.rawlen, DEC);
    Serial.print(" bits: ");
    for(i=0;i<results.rawlen;i++)
    {
      Serial.print(results.rawbuf[i], DEC);
      Serial.print(" ");
    }
    Serial.println("");*/
  }
}
