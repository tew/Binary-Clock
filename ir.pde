#include "IRremote.h"

#define	IR_AIWA_DECK2_REC		0xCE018FFA
#define	IR_AIWA_DECK2_PAUSE		0xCE018FF2
#define	IR_AIWA_DECK2_REWIND	0xCE018FD2
#define	IR_AIWA_DECK2_FORWARD	0xCE018FE2
#define	IR_AIWA_DECK2_STOP		0xCE018FD6
#define	IR_AIWA_DECK2_PLAY		0xCE018FEA
#define	IR_AIWA_DECK1_REWIND	0x2E068FE6
#define	IR_AIWA_DECK1_FORWARD	0x2E068FC6
#define	IR_AIWA_DECK1_STOP		0x2E068FD6
#define	IR_AIWA_DECK1_PLAY		0x2E068FEA
#define	IR_AIWA_POWER			0x1E070FC0

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
      case 0x4BB6A956:
      case 0x2E068FD4:
        event_addEvent(EVENT_IR, 0); break;
      case 0x4B3632CD:
      case 0x2E068FE0:
        event_addEvent(EVENT_IR, 1); break;
      case 0x4BB622DD:
      case 0x2E068FD0:
        event_addEvent(EVENT_IR, 2); break;
      case 0x4B3618E7:
      case 0x2E068FF0:
        event_addEvent(EVENT_IR, 3); break;
      case 0x4B36B24D:
      case 0x2E068FC8:
        event_addEvent(EVENT_IR, 4); break;
      case 0x4B36728D:
      case 0x2E068FE8:
        event_addEvent(EVENT_IR, 5); break;
      case 0x4B369867:
      case 0x2E068FD8:
        event_addEvent(EVENT_IR, 6); break;
      case 0x4BB69A65:
      case 0x2E068FF8:
        event_addEvent(EVENT_IR, 7); break;
      case 0x4B3622DD:
      case 0x2E068FC4:
        event_addEvent(EVENT_IR, 8); break;
      case 0x4B3642BD:
      case 0x2E068FE4:
        event_addEvent(EVENT_IR, 9); break;
      case 0x4BB640BF:
      case 0x1E070FE2:
        event_addEvent(EVENT_IR, IR_PLUS); break;
      case 0x4BB6C03F:
      case 0x1E070FD2:
        event_addEvent(EVENT_IR, IR_MOINS); break;

      case IR_AIWA_DECK2_REWIND:  event_addEvent(EVENT_IR, IR_R_PLUS); break;
      case IR_AIWA_DECK1_REWIND:  event_addEvent(EVENT_IR, IR_R_MOINS); break;
      case IR_AIWA_DECK2_FORWARD: event_addEvent(EVENT_IR, IR_G_PLUS); break;
      case IR_AIWA_DECK1_FORWARD: event_addEvent(EVENT_IR, IR_G_MOINS); break;
      case IR_AIWA_DECK2_STOP:    event_addEvent(EVENT_IR, IR_B_PLUS); break;
      case IR_AIWA_DECK1_STOP:    event_addEvent(EVENT_IR, IR_B_MOINS); break;
      case IR_AIWA_DECK2_PAUSE:   event_addEvent(EVENT_IR, IR_MODIFY_RGB); break;
      case IR_AIWA_DECK2_REC:     event_addEvent(EVENT_IR, IR_MODIFY_YUV); break;
      case IR_AIWA_POWER:         event_addEvent(EVENT_IR, IR_POWER); break;
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
