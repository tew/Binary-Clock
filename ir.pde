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
  if (irrecv.decode(&results)) {
    Serial.println(results.value, HEX);
    irrecv.resume(); // Receive the next value
  }
}
