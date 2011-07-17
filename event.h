#ifndef EVENT_H_INCLUDE
#define EVENT_H_INCLUDE

/* CONSTANTES ***************************************************************/
enum {
    NO_EVENT,   // à ne pas modifier

    // KEY
    EVENT_KEY,	// parametre donne touche appuyée
    EVENT_IR,	// parametre donne touche appuyée
    EVENT_IR_PLUS,	// parametre donne touche appuyée
    EVENT_IR_MOINS,	// parametre donne touche appuyée
    
    // LUMINO
    EVENT_LUMINO_MESURE,
    EVENT_LUMINO_LEDS_OK,
    
    // Hour
    EVENT_HOUR,

    // backlight
    EVENT_100MS,
    
    // luminosite
    EVENT_LUMINOSITE,

    NB_EVENTS   // à laisser en dernier
};

enum {
    IR_0,
    IR_PLUS=10,
    IR_MOINS,
    IR_R_PLUS,
    IR_R_MOINS,
    IR_G_PLUS,
    IR_G_MOINS,
    IR_B_PLUS,
    IR_B_MOINS,
    IR_MODIFY_RGB,
    IR_MODIFY_HSL,
    IR_POWER,
    IR_HUE_SHIFT_SLOW,
    IR_HUE_SHIFT,
    IR_HUE_SHIFT_FAST,
    IR_STOP,
    IR_LUM_PLUS,
    IR_LUM_MOINS,
    IR_BCK_REC,
    IR_BCK_RECALL,
    IR_SET_TIME
};

#endif
