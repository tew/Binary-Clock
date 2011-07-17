
/* This project uses 3 libraries

http://www.arduino.cc/playground/uploads/Main/MsTimer2.zip
git://github.com/adafruit/RTClib.git

IR library available at
http://www.arcfn.com/2009/08/multi-protocol-infrared-remote-library.html
http://arcfn.com/files/IRremote.zip
However IRlibrary and MSTimers2 both use the timer2 interrupt.
We need to modify them to make them compatible. So their are included in the code, not as library.

*/

#include "MsTimer2.h"
#include "event.h"
#include "hour.h"


/*****************************************************************************
 * SETUP related functions
 ****************************************************************************/

#define PERIODIC_BASE_US  50
#define BUFFERS_REFRESH_PERIOD_MS  100UL
#define HOUR_REFRESH_PERIOD_MS  1000UL
#define KEY_PERIODIC_MS  50UL


unsigned long cpt_us= 0;
unsigned long cpt_ms= 0;
unsigned long cpt_buffers=0;
unsigned long cpt_hour=0;
unsigned long cpt_key=0;

/***********************************************************************/
void periodic(void)
{
    //digitalWrite(11, HIGH); //debugUp();
    irPeriodic();  // 12,4µs
    cpt_us+= PERIODIC_BASE_US;  // 6,8µs

    if (cpt_us>=1000)
    {
        cpt_us -= 1000;
        cpt_buffers++;  // 6.4µs
        if (cpt_buffers == BUFFERS_REFRESH_PERIOD_MS)  // 20µs
        {
            cpt_buffers= 0;
            buffersPeriodic();
        }

        cpt_hour++;  // 6.4µs
        if (cpt_hour == HOUR_REFRESH_PERIOD_MS) {  // 1.4µs
            cpt_hour= 0;
            event_addEvent(EVENT_HOUR, 0);
        }

        cpt_key++;  // 6.6µs
        if (cpt_key == KEY_PERIODIC_MS) {
            cpt_key= 0;
            keyPeriodic();
        }
        
        cpt_ms++;
        if (cpt_ms == 100)
        {
            cpt_ms= 0;
            event_addEvent(EVENT_BCK, 0);
            //event_addEvent(EVENT_LUMINO_MESURE, 0);
        }

    }
    //digitalWrite(11, LOW); //debugDown();
}


 /***********************************************************************/
void periodicSetup()
{
    MsTimer2::set(periodic);  // it period is 50µs, we need a call each it
    MsTimer2::start();
}


/*****************************************************************************
 * SETUP
 ****************************************************************************/
void setup() {
    //Serial.begin(9600);
    backSetup();
    event_init();
    buffersSetup();
    //setupDebug();
    hourSetup();
    periodicSetup();
    irSetup();
    setupDebug();
}


/*****************************************************************************
 * PINK LEDs related functions
 ****************************************************************************/

 /* state of pink LEDs. Those LEDs normally display the time (hours and minutes) */
enum {
    PINK_NORMAL,	// hour+minutes
    PINK_SECONDS,	// minutes+seconds
    PINK_BLINK,
    PINK_OFF,
    PINK_NB
};

//uint8_t pink_pwm= 5;

unsigned char state_pink= PINK_NORMAL;


/****************************************************************************/
void manage_pink(void)
{
    switch(state_pink)
    {
    case PINK_NORMAL:
        hourDisplay();
        break;
        
    case PINK_SECONDS:
        hourDisplaySeconds();
        break;
        
        /*case PINK_BLINK:
    buffersBlink();
    break;*/
    }
}


/*****************************************************************************
 * BACK LEDs related functions
 ****************************************************************************/

// backlight related variables and consts
const uint16_t HLSMAX = 1530;
const uint16_t RGBMAX = 255;

// management of back LEDs
uint16_t	bck[3];	// this hold RGB (mode_rgb=1) or HSL (mode_rgb=0) values
uint16_t        bck_saved[3];
uint8_t mode_rgb= 1;
uint8_t	bck_tempo=0;	// divisor for soem states
uint16_t bck_timer=0;	// to switch off back LEDs after delay
#define	BCK_TIMEOUT_S	3600

enum {
    BCK_OFF,
    BCK_STATIC,
    BCK_HUE_SHIFT_SLOW,
    BCK_HUE_SHIFT,
    BCK_HUE_SHIFT_FAST,
    BCK_MANUAL,
    BCK_NB
};
uint8_t state_bck= BCK_MANUAL;

void bck_plus(uint16_t *value)
{
    (*value)++;
    
    if (mode_rgb)
    {
        if ((*value) > RGBMAX) (*value)= 0;
    }
    else
    {
        if ((*value) > HLSMAX) (*value)= 0;
    }
}

void bck_moins(uint16_t *value)
{
    (*value)--;
    
    if (mode_rgb)
    {
        if ((*value) > RGBMAX) (*value)= RGBMAX;
    }
    else
    {
        if ((*value) > HLSMAX) (*value)= HLSMAX;
    }
}

/****************************************************************************/
void manage_bck(void)
{
    static uint8_t divisor= 0;
    
    switch(state_bck)
    {
    case BCK_STATIC:
        refreshBacklight();
        break;

    case BCK_HUE_SHIFT_FAST:
        bck[0]= (bck[0]+4)%HLSMAX;
        refreshBacklight();
        break;

    case BCK_HUE_SHIFT:
        bck[0]=(bck[0]+1)%HLSMAX;
        refreshBacklight();
        break;

    case BCK_HUE_SHIFT_SLOW:
        divisor= (divisor+1)%4;
        if (!divisor)
        {
            bck[0]=(bck[0]+1)%HLSMAX;
            refreshBacklight();
        }
        break;

    case BCK_MANUAL:
        break;

    default:
        state_bck= BCK_OFF;
        state_pink= PINK_NORMAL;
        // and apply OFF... (do not put any break here!)
    case BCK_OFF:
        backSetRVB(0,0,0);
        break;
    }
}


/*****************************************************************************
 * MAIN LOOP
 ****************************************************************************/
void loop() {
    irLoop();
    unsigned char event, param;

    event= event_getEvent(0, &param);
    switch (event)
    {
    case EVENT_KEY:
        if (param == 3)
        {
            hourHH ++;
            if (hourHH>23) hourHH=0;
            hourRTCsave();
        }
        
        if (param == 5)
        {
            hourMM ++;
            if (hourMM>59) hourMM=0;
            hourSS= 0;
            hourRTCsave();
        }

        if (param == 4) state_pink= PINK_SECONDS;        // appui sur touche minutes
        if (param == 4 | 0x80) state_pink= PINK_NORMAL;  // touche minutes relachée
        
        //XXX
        if (param == 2)
        {
            hourSetup();
        }
        break;
        
    case EVENT_IR:
        //hourHH= param;
        switch(param)
        {
        case 0: bck[0]= bck[1]= bck[2]=   0; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 1: bck[0]= bck[1]= bck[2]=   1; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 2: bck[0]= bck[1]= bck[2]=  10; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 3: bck[0]= bck[1]= bck[2]=  50; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 4: bck[0]= bck[1]= bck[2]= 100; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 5: bck[0]= bck[1]= bck[2]= 150; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 6: bck[0]= bck[1]= bck[2]= 200; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 7: bck[0]= bck[1]= bck[2]= 253; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 8: bck[0]= bck[1]= bck[2]= 254; backSetRVB(bck[0], bck[1], bck[2]); break;
        case 9: bck[0]= bck[1]= bck[2]= 255; backSetRVB(bck[0], bck[1], bck[2]); break;
        case IR_PLUS: bck_plus(&bck[0]); bck_plus(&bck[1]); bck_plus(&bck[2]); refreshBacklight(); break;
        case IR_MOINS: bck_moins(&bck[0]); bck_moins(&bck[1]); bck_moins(&bck[2]); refreshBacklight(); break;
        case IR_R_PLUS: bck_plus(&bck[0]); refreshBacklight(); break;
        case IR_R_MOINS: bck_moins(&bck[0]); refreshBacklight(); break;
        case IR_G_PLUS: bck_plus(&bck[1]); refreshBacklight(); break;
        case IR_G_MOINS: bck_moins(&bck[1]); refreshBacklight(); break;
        case IR_B_PLUS: bck_plus(&bck[2]); refreshBacklight(); break;
        case IR_B_MOINS: bck_moins(&bck[2]); refreshBacklight(); break;
        case IR_MODIFY_HSL:
            if (mode_rgb)
            {
                // convertir RGB en HSL;
                Serial.print("Convert RGB2HSL: ");
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.print(bck[2], DEC);
                Serial.print("->");
                pix_calRGBtoHSL(bck[0], bck[1], bck[2], &bck[0], &bck[1], &bck[2]);
                Serial.print(bck[0], DEC);
                Serial.print('.');
                Serial.print(bck[1], DEC);
                Serial.print('.');
                Serial.println(bck[2], DEC);
                Serial.println("Mode HSL");
                mode_rgb= 0;
            }
            break;
        case IR_MODIFY_RGB:
            if (!mode_rgb)
            {
                // convertir RGB en HSL;
                pix_calHSLtoRGB(bck[0], bck[1], bck[2], &bck[0], &bck[1], &bck[2]);
                Serial.println("Mode RGB");
                mode_rgb= 1;
            }
            break;
            
            //case IR_LUM_PLUS: pink_pwm++; Serial.println(pink_pwm, DEC); break;
            //case IR_LUM_MOINS:	pink_pwm--; Serial.println(pink_pwm, DEC); break;
            
            // playing cases
        case IR_HUE_SHIFT:
            switch (state_bck)
            {
            case BCK_HUE_SHIFT_SLOW: state_bck= BCK_HUE_SHIFT; bck_timer= BCK_TIMEOUT_S; break;
            case BCK_HUE_SHIFT:		 state_bck= BCK_HUE_SHIFT_FAST; bck_timer= BCK_TIMEOUT_S; break;
                
            case BCK_STATIC:
            case BCK_HUE_SHIFT_FAST:
                state_bck= BCK_HUE_SHIFT_SLOW;
                bck_timer= BCK_TIMEOUT_S; 
                break;

            default: 
                state_bck= BCK_HUE_SHIFT_SLOW;
                bck_timer= BCK_TIMEOUT_S; 
                mode_rgb= 0;
                // setting max saturation and luminosity if not defined
                if ((bck[1]==0) || (bck[2]==0))
                {
                    bck[1]=HLSMAX;
                    bck[2]=HLSMAX/2;
                }
                break;
            }
            break;
            
        case IR_STOP:
            switch(state_bck)
            {
            case BCK_HUE_SHIFT_SLOW:
            case BCK_HUE_SHIFT:
            case BCK_HUE_SHIFT_FAST:
                state_bck= BCK_STATIC;
                break;
            case BCK_STATIC:
                state_bck= BCK_OFF;
                break;
            }
            break;
            
        case IR_BCK_REC:
            memcpy(bck_saved, bck, sizeof(bck_saved));
            Serial.println("Saved");
            break;
            
        case IR_BCK_RECALL:
            memcpy(bck, bck_saved, sizeof(bck_saved));
            state_bck= BCK_STATIC;
            mode_rgb= 0;
            Serial.println("Recall");
            break;
        }
        break;

    case EVENT_BCK:
        manage_bck();
        break;

    case EVENT_HOUR:
        hourPeriodic();
        if (bck_timer)
        {
            bck_timer--;
            if (!bck_timer)
            {
                state_bck= BCK_OFF;
            }
        }
        break;
        
    default:
        luminoPeriodic();
        break;
    }

    if  (getKey() == 4) state_pink= PINK_SECONDS;
    else state_pink= PINK_NORMAL;

    manage_pink();
}

void refreshBacklight(void)
{
    uint16_t	v1,v2,v3;

    if (!mode_rgb)
    {
        // convertir en RGB
        Serial.print("Convert HSL2RGB: ");
        pix_calHSLtoRGB(bck[0], bck[1], bck[2], &v1, &v2, &v3);
        Serial.print(bck[0], DEC);
        Serial.print('.');
        Serial.print(bck[1], DEC);
        Serial.print('.');
        Serial.print(bck[2], DEC);
        Serial.print("->");
        Serial.print(v1, DEC);
        Serial.print('.');
        Serial.print(v2, DEC);
        Serial.print('.');
        Serial.println(v3, DEC);
        backSetRVB(v1, v2, v3);
    }
    else
    {
        Serial.print("Set RGB: ");
        Serial.print(bck[0], DEC);
        Serial.print('.');
        Serial.print(bck[1], DEC);
        Serial.print('.');
        Serial.println(bck[2], DEC);
        backSetRVB(bck[0], bck[1], bck[2]);
    }
}



