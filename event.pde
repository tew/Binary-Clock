
/* génération et traitement d'évènements
 *
 * historique
 * 20060928: ajout d'un parametre a chaque evenement
 * 20080108: desactivation gestion sleep et watchdog pour shebon
 */
#include "event.h"

#define EVENT_BUFLEN	10

unsigned char	event_buf[EVENT_BUFLEN];
unsigned char	event_param[EVENT_BUFLEN];
unsigned char	event_bufRd=0;
unsigned char	event_bufWr=0;


#define	EVENT_NB_DELAYED	3
typedef struct 
{
	unsigned char	event_u8;
	unsigned char	param_u8;
	unsigned short int	delay_ms_u16;
	unsigned char	valid_u8;
} event_delayed_t;

event_delayed_t event_delayed[EVENT_NB_DELAYED];

void event_init(void)
{
	memset(event_delayed, 0, sizeof(event_delayed));
	//printf("Event thread is alive\r");
}


/* Générer un évènement. On place simplement la valeur dans une variable
 * globale que le programme principal est censé poller.
 *****************************************************************************
 */
void event_addEvent(unsigned char event, unsigned char param)
{
  if ((event_bufRd+EVENT_BUFLEN-1) % EVENT_BUFLEN != event_bufWr)
  {
    //di();
    event_buf[event_bufWr]= event;
    event_param[event_bufWr]= param;
    event_bufWr= (event_bufWr+1) % EVENT_BUFLEN;
    //printf("add event %u:%u\r", event, param);
    //ei(); //XXX revoir laprotection par di/ei. si on restaure les it alors qu'elles n'étaient pas activées, on peut avoir de pb
  }
  else
  {
    // evenement perdu!
  }
}


/* attend un évènement et renvoie son numéro.
 *****************************************************************************
 * si delay == EVENT_WAIT_FOREVER, on attend indefiniment qu'un evenement
 *    produise. Si delay == EVENT_NO_WAIT, on retourne immediatement meme si
 *    aucun evenement n'est disponible (NO_EVENT est renvoye dans ce cas).
 */
unsigned char event_getEvent(unsigned char delay, unsigned char *param)
{
  unsigned char  localEvent=NO_EVENT;
   
  /* boucle d'attente de disponibilité d'évènement.
   * valeur 0: le while n'est pas exécuté
   * valeur 255: on boucle indéfiniment tant que pas d'évènement dispo
   * valeur 1-254: attente, en multiple de watchdog
   */
  // si on n'a pas généré d'event timeout, on peut aller voir s'il y en a un de dispo

    if (event_bufWr != event_bufRd)
    {
      localEvent= event_buf[event_bufRd];
      *param= event_param[event_bufRd];
      event_bufRd= (event_bufRd+1) % EVENT_BUFLEN;
    }

  return(localEvent);
}



