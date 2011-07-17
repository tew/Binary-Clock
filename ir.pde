#include "IRremote.h"

#include "ir_aiwa.h"
#include "ir_onkyo.h"

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
    int decoded,i,found;
    decoded= irrecv.decode(&results);
    if (decoded) {
        irrecv.resume(); // Receive the next value
        if ((decoded!=1) || (results.value != 0))
        {
            /*Serial.print(decoded, DEC);
            Serial.print(": ");
            Serial.print(results.value, HEX);
            Serial.println("");*/
            
            found= 1;
            switch (results.value)
            {
            /*
            case IR_ONKYO_VOL_PLUS:
                event_addEvent(EVENT_IR, IR_PLUS); break;
            case IR_ONKYO_VOL_MOINS:
                event_addEvent(EVENT_IR, IR_MOINS); break;

            case IR_AIWA_DECK2_REWIND:  event_addEvent(EVENT_IR, IR_R_PLUS); break;
            case IR_AIWA_DECK1_REWIND:  event_addEvent(EVENT_IR, IR_R_MOINS); break;
            case IR_AIWA_DECK2_FORWARD: event_addEvent(EVENT_IR, IR_G_PLUS); break;
            case IR_AIWA_DECK1_FORWARD: event_addEvent(EVENT_IR, IR_G_MOINS); break;
            case IR_AIWA_DECK2_STOP:    event_addEvent(EVENT_IR, IR_B_PLUS); break;
            case IR_AIWA_DECK1_STOP:    event_addEvent(EVENT_IR, IR_B_MOINS); break;
            case IR_AIWA_DECK2_PAUSE:   event_addEvent(EVENT_IR, IR_MODIFY_RGB); break;
            case IR_AIWA_DECK2_REC:     event_addEvent(EVENT_IR, IR_MODIFY_HSL); break;
            case IR_AIWA_POWER:         event_addEvent(EVENT_IR, IR_POWER); break;
                //default: event_addEvent(EVENT_IR, 63); break;
                
            case IR_AIWA_VOL_PLUS: event_addEvent(EVENT_IR, IR_LUM_PLUS); break;
            case IR_AIWA_VOL_MOINS: event_addEvent(EVENT_IR, IR_LUM_MOINS); break;
            */
                // next are playing codes
            case IR_ONKYO_PLAY:
            case IR_AIWA_CD_PLAY_PAUSE:
                event_addEvent(EVENT_IR, IR_HUE_SHIFT); break;
                
            case IR_ONKYO_PREV:
                event_addEvent(EVENT_IR, IR_HUE_SHIFT_SLOW); break;

            case IR_ONKYO_NEXT:
                event_addEvent(EVENT_IR, IR_HUE_SHIFT_FAST); break;

            case IR_ONKYO_STOP:
            case IR_AIWA_CD_STOP:
                event_addEvent(EVENT_IR, IR_STOP); break;

            case IR_ONKYO_REC:
                event_addEvent(EVENT_IR, IR_BCK_REC); break;

            case IR_ONKYO_EJECT:
                event_addEvent(EVENT_IR, IR_BCK_RECALL); break;

            case IR_ONKYO_DISPLAY_DVD_SET:
            case IR_AIWA_CD_NEXT:
                event_addEvent(EVENT_IR, IR_CHENILLARD); break;

            // keys to enter new time
            case IR_ONKYO_0:
            case IR_AIWA_0:
                event_addEvent(EVENT_IR, 0); break;
            case IR_ONKYO_1:
            case IR_AIWA_1:
                event_addEvent(EVENT_IR, 1); break;
            case IR_ONKYO_2:
            case IR_AIWA_2:
                event_addEvent(EVENT_IR, 2); break;
            case IR_ONKYO_3:
            case IR_AIWA_3:
                event_addEvent(EVENT_IR, 3); break;
            case IR_ONKYO_4:
            case IR_AIWA_4:
                event_addEvent(EVENT_IR, 4); break;
            case IR_ONKYO_5:
            case IR_AIWA_5:
                event_addEvent(EVENT_IR, 5); break;
            case IR_ONKYO_6:
            case IR_AIWA_6:
                event_addEvent(EVENT_IR, 6); break;
            case IR_ONKYO_7:
            case IR_AIWA_7:
                event_addEvent(EVENT_IR, 7); break;
            case IR_ONKYO_8:
            case IR_AIWA_8:
                event_addEvent(EVENT_IR, 8); break;
            case IR_ONKYO_9:
            case IR_AIWA_9:
                event_addEvent(EVENT_IR, 9); break;

            case IR_ONKYO_ENTER:
            case IR_AIWA_PRGM:
                event_addEvent(EVENT_IR, IR_SET_TIME); break;
                
            default:
                found= 0;
                break;
            }
            if (found)
            {
                // on pourrait faire clignoter une LED rose
                pink_blink();
            }
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
