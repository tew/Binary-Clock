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
	NB_EVENTS   // à laisser en dernier
};

#endif
