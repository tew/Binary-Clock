#include <iostream>

using namespace std;

#include "IRremote.h"
#include "IRremoteInt.h"
#include <string.h>


const irparams_t signal1={
    0,0,0,0,
    { 746,180,88,13,10,12,33,12,10,13,10,12,33,12,10,12,33,12,33,12,32,12,11,12,32,13,32,12,11,10,32,12,33,12,10,13,10,12,33,12,10,12,10,12,11,12,10,12,10,13,10,12,33,12,10,12,33,12,33,12,32,12,33,12,33,12,32,13},
    68
    };
const irparams_t signal2={
    0,0,0,0,
    { 16633,181,88,13,10,12,32,13,10,12,10,12,33,12,10,13,32,12,33,12,30,12,10,12,33,12,33,12,10,12,33,12,32,13, 9,13,10,12,33,12,10,13,10,12,10,12,10,13,10,12,10,12,33,12,10,13,32,13,32,12,33,12,33,12,32,12,33,12},
    68
    };
const irparams_t signal3={
    0,0,0,0,
    { 13061,181,88,12,11,12,33,12,10,12,10,12,33,12,10,13,32,12,33,12,33,12,10,12,33,12,33,12,10,12,33,12,33,12, 7,12,32,13,32,12,11,12,10,12,10,12,11,12,10,12,11,12,10,12,10,12,33,12,33,12,33,12,32,12,33,12,33,12},
    68
    };
const irparams_t signal4={
    0,0,0,0,
    { 5925,180,88,13,10,12,33,12,10,12,11,12,32,13,10,12,33,12,32,12,33,12,11,12,32,12,33,12,10,13,32,12,33,12,10,13,32,12,31,13,10,12,10,12,11,12,10,12,10,12,11,12,10,12,11,12,32,12,33,12,33,12,33,12,32,12,33,12},
    68
    };
/*
onkyo +
1:,68,bits:,  746,180,88,13,10,12,33,12,10,13,10,12,33,12,10,12,33,12,33,12,32,12,11,12,32,13,32,12,11,10,32,12,33,12,10,13,10,12,33,12,10,12,10,12,11,12,10,12,10,13,10,12,33,12,10,12,33,12,33,12,32,12,33,12,33,12,32,13
1:,68,bits:,16633,181,88,13,10,12,32,13,10,12,10,12,33,12,10,13,32,12,33,12,30,12,10,12,33,12,33,12,10,12,33,12,32,13, 9,13,10,12,33,12,10,13,10,12,10,12,10,13,10,12,10,12,33,12,10,13,32,13,32,12,33,12,33,12,32,12,33,12
onkyo -
1:,68,bits:,13061,181,88,12,11,12,33,12,10,12,10,12,33,12,10,13,32,12,33,12,33,12,10,12,33,12,33,12,10,12,33,12,33,12, 7,12,32,13,32,12,11,12,10,12,10,12,11,12,10,12,11,12,10,12,10,12,33,12,33,12,33,12,32,12,33,12,33,12
1:,68,bits:, 5925,180,88,13,10,12,33,12,10,12,11,12,32,13,10,12,33,12,32,12,33,12,11,12,32,12,33,12,10,13,32,12,33,12,10,13,32,12,31,13,10,12,10,12,11,12,10,12,10,12,11,12,10,12,11,12,32,12,33,12,33,12,33,12,32,12,33,12
*/
const irparams_t signal_aiwap1={
    0,0,0,0,
    { 11981,183,89,12,11,12,11,12,10,12,34,12,33,12,33,12,33,12,10,13,10,12,11,12,10,12,11,12,11,12,33,12,33,12,34,8,11,12,11,12,10,12,11,12,33,12,33,12,33,13,33,12,33,12,33,12,34,11,11,13,10,11,11,12,33,12,11,12,10,13,10,12,11,12,33,12},
    76
    };
const irparams_t signal_aiwap2={
    0,0,0,0,
    { 12904,182,88,12,11,12,10,13,10,12,33,13,32,12,34,11,34,12,10,12,11,12,10,13,10,12,11,12,10,13,32,13,33,11,34,12,11,11,11,12,11,12,11,11,34,12,33,12,33,12,33,12,34,12,33,11,30,13,10,12,11,12,10,12,34,12,10,12,11,11,12,11,11,12,34,12},
    76
    };
const irparams_t signal_aiwap3={
    0,0,0,0,
    { 29887,181,91,11,11,12,11,12,10,12,33,13,33,12,33,12,33,12,11,12,11,11,11,12,11,11,11,13,10,12,33,12,33,12,33,10,10,11,12,11,11,12,11,11,34,12,33,13,32,12,33,13,33,12,33,12,33,12,11,11,12,11,11,12,33,12,11,12,10,12,11,12,10,13,33,12},
    76
    };
/*aiwa +
1:,76,bits:,11981,183,89,12,11,12,11,12,10,12,34,12,33,12,33,12,33,12,10,13,10,12,11,12,10,12,11,12,11,12,33,12,33,12,34,8,11,12,11,12,10,12,11,12,33,12,33,12,33,13,33,12,33,12,33,12,34,11,11,13,10,11,11,12,33,12,11,12,10,13,10,12,11,12,33,12
1:,76,bits:,29887,181,91,11,11,12,11,12,10,12,33,13,33,12,33,12,33,12,11,12,11,11,11,12,11,11,11,13,10,12,33,12,33,12,33,10,10,11,12,11,11,12,11,11,34,12,33,13,32,12,33,13,33,12,33,12,33,12,11,11,12,11,11,12,33,12,11,12,10,12,11,12,10,13,33,12
1:,76,bits:,12904,182,88,12,11,12,10,13,10,12,33,13,32,12,34,11,34,12,10,12,11,12,10,13,10,12,11,12,10,13,32,13,33,11,34,12,11,11,11,12,11,12,11,11,34,12,33,12,33,12,33,12,34,12,33,11,30,13,10,12,11,12,10,12,34,12,10,12,11,11,12,11,11,12,34,12
aiwa -
1:,76,bits:,28699,178,89,13,10,13,10,12,11,12,33,11,34,12,33,12,34,11,11,12,10,13,10,12,11,12,10,12,11,12,33,12,33,13,33,11,12,12,10,12,10,12,11,12,33,13,32,13,33,12,30,12,33,13,33,11,11,12,34,11,11,12,10,12,34,12,10,12,11,12,10,13,33,13,9,12
1:,76,bits:,19105,183,88,13,10,12,11,12,10,13,33,12,33,12,33,13,29,13,10,12,10,12,11,12,10,13,10,12,11,12,33,12,33,12,34,11,11,13,10,11,11,12,11,12,33,12,33,12,33,13,33,12,33,12,33,12,11,12,33,12,11,11,11,12,33,12,11,12,10,13,10,12,33,12,11,12
*/
const irparams_t signal_aiwam1={
    0,0,0,0,
    { 28699,178,89,13,10,13,10,12,11,12,33,11,34,12,33,12,34,11,11,12,10,13,10,12,11,12,10,12,11,12,33,12,33,13,33,11,12,12,10,12,10,12,11,12,33,13,32,13,33,12,30,12,33,13,33,11,11,12,34,11,11,12,10,12,34,12,10,12,11,12,10,13,33,13,9,12},
    76
    };
const irparams_t signal_aiwam2={
    0,0,0,0,
    { 19105,183,88,13,10,12,11,12,10,13,33,12,33,12,33,13,29,13,10,12,10,12,11,12,10,13,10,12,11,12,33,12,33,12,34,11,11,13,10,11,11,12,11,12,33,12,33,12,33,13,33,12,33,12,33,12,11,12,33,12,11,11,11,12,33,12,11,12,10,13,10,12,33,12,11,12},
    76
    };
const irparams_t signal_onkiorep={
    0,0,0,0,
    { 1908,180,44,13},
    4
    };
    
    

 extern "C" {
decode_results results;
}
IRrecv irrecv(0);

void test_decodage(const irparams_t *signal)
{
    int decoded;

    memcpy(&irparams.rawbuf, signal->rawbuf, sizeof(signal->rawbuf));
    irparams.rawlen= signal->rawlen;
    irparams.rcvstate= STATE_STOP;
    decoded= irrecv.decode(&results);
  if (decoded) {
    cout << "decoded " << results.rawlen << "bits => " << std::hex << results.valueH << "." << results.value << std::dec <<" (" << results.bits << " bits)" << endl;
    irrecv.resume(); // Receive the next value
  }
  else
  {
      cout << "pas de decodage";
  }
}


int main()
{
    cout << "Test decodage IR!" << endl;
    
    test_decodage(&signal1);
    test_decodage(&signal2);
    test_decodage(&signal3);
    test_decodage(&signal4);
    test_decodage(&signal_aiwap1);
    test_decodage(&signal_aiwap3);
    test_decodage(&signal_aiwap2);
    test_decodage(&signal_aiwam1);
    test_decodage(&signal_aiwam2);
    test_decodage(&signal_onkiorep);
    /*memcpy(&irparams.rawbuf, signal1.rawbuf, sizeof(signal1.rawbuf));
    irparams.rawlen= signal1.rawlen;
    irparams.rcvstate= STATE_STOP;
    decoded= irrecv.decode(&results);
  if (decoded) {
    cout << "decoded " << results.rawlen << "bits => " << results.value << "(" << results.bits << " bits)";
    irrecv.resume(); // Receive the next value
  }
  else
  {
      cout << "pas de decodage";
  }*/
    
    return 0;
}
