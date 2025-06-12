#ifndef GUI_H_ //stel GUI_H_ is nog niet gedefinieerd, definieer ze dan
#define GUI_H_

#include <stdio.h>
#include <stdlib.h>

/*
 * Importeer de benodigde functies uit SDL2.
 */
#include <SDL2/SDL.h>


/*
 * De hoogte en breedte van het venster (in pixels).
 * Deze dimensies zijn arbitrair gekozen. Deze dimensies hangen mogelijk af van de grootte van het speelveld.
 */
extern int WINDOW_HEIGHT;
extern int WINDOW_WIDTH;
extern int should_continue;
extern int mouse_x;
extern int mouse_y;
extern int clicked;

int is_relevant_event(SDL_Event *event);
void read_input();
void initialize_window(const char *title);
void free_gui();
void initialize_textures();
void initialize_gui();
void rect_tekener(int pos_x, int pos_y,int content);
void test(char **array, int maxi,int maxj);


static SDL_Texture *mine_texture;

static SDL_Renderer *renderer;


void draw_clicked();
/*
 * De hoogte en breedte (in pixels) van de afbeeldingen voor de vakjes in het speelveld die getoond worden.
 * Als je andere afbeelding wil gebruiken in je GUI, zorg er dan voor dat deze
 * dimensies ook aangepast worden.
 */
#define IMAGE_HEIGHT 50
#define IMAGE_WIDTH 50

#endif /* GUI_H_ */
