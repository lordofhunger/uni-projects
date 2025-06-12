#include <stdlib.h>
#include "GUI.h"

int WINDOW_HEIGHT = 500;
int WINDOW_WIDTH = 600;
int should_continue = 1;
int mouse_x = 0;
int mouse_y = 0;
int clicked = 0;

static SDL_Texture *digit_0_texture = NULL;
static SDL_Texture *digit_1_texture = NULL;
static SDL_Texture *digit_2_texture = NULL;
static SDL_Texture *digit_3_texture = NULL;
static SDL_Texture *digit_4_texture = NULL;
static SDL_Texture *digit_5_texture = NULL;
static SDL_Texture *digit_6_texture = NULL;
static SDL_Texture *digit_7_texture = NULL;
static SDL_Texture *digit_8_texture = NULL;

static SDL_Texture *covered_texture = NULL;
static SDL_Texture *mine_texture = NULL;
static SDL_Texture *flag_texture = NULL;

/*
 * Deze renderer wordt gebruikt om figuren in het venster te tekenen. De renderer
 * wordt geïnitialiseerd in de initialize_window-functie.
 */


/* De afbeelding die een vakje met een "1" in voorstelt. */




/*
 * Onderstaande twee lijnen maken deel uit van de minimalistische voorbeeldapplicatie:
 * ze houden de laatste positie bij waar de gebruiker geklikt heeft.
 */


/*
 * Geeft aan of de applicatie moet verdergaan.
 * Dit is waar zolang de gebruiker de applicatie niet wilt afsluiten door op het kruisje te klikken.
 */


/*
 * Dit is het venster dat getoond zal worden en waarin het speelveld weergegeven wordt.
 * Dit venster wordt aangemaakt bij het initialiseren van de GUI en wordt weer afgebroken
 * wanneer het spel ten einde komt.
 */
static SDL_Window *window;

/*
 * Vangt de input uit de GUI op. Deze functie is al deels geïmplementeerd, maar je moet die zelf
 * nog afwerken. Je mag natuurlijk alles aanpassen aan deze functie, inclusies return-type en argumenten.
 */
int is_relevant_event(SDL_Event *event) {
    if (event == NULL) {
        return 0;
    }
    return (event->type == SDL_MOUSEBUTTONDOWN) ||
           (event->type == SDL_KEYDOWN) ||
           (event->type == SDL_QUIT);
}

void read_input() {
	SDL_Event event;

	/*
	 * Handelt alle input uit de GUI af.
	 * Telkens de speler een input in de GUI geeft (bv. een muisklik, muis bewegen, toets indrukken enz.)
	 * wordt er een 'event' (van het type SDL_Event) gegenereerd dat hier wordt afgehandeld.
	 *
	 * Zie ook https://wiki.libsdl.org/SDL_PollEvent en http://www.parallelrealities.co.uk/2011_09_01_archive.html
	 */
	while (!SDL_PollEvent(&event) || !is_relevant_event(&event)) {}

	switch (event.type) {
	case SDL_KEYDOWN:
		if (event.key.keysym.sym == SDLK_p) {
			printf("P pressed\n");
		}
		break;
	case SDL_QUIT:
		/* De gebruiker heeft op het kruisje van het venster geklikt om de applicatie te stoppen. */
		should_continue = 0;
		break;

	case SDL_MOUSEBUTTONDOWN:
		/*
		 * De speler heeft met de muis geklikt: met de onderstaande lijn worden de coördinaten in het
		 * het speelveld waar de speler geklikt heeft bewaard in de variabelen mouse_x en mouse_y.
		 */
		mouse_x = event.button.x / 50;
		mouse_y = event.button.y / 50;
		//draw_clicked();
		//printf("Clicked at (%i,%i)\n", mouse_x, mouse_y);
		clicked = 1;
		break;
	}
}

//void draw_clicked(){
//	field[mouse_y][mouse_x] = '1';
//}


/*
 * Initialiseert het venster en alle extra structuren die nodig zijn om het venster te manipuleren.
 */
void initialize_window(const char *title) {
	/*
	 * Code o.a. gebaseerd op:
	 * http://lazyfoo.net/tutorials/SDL/02_getting_an_image_on_the_screen/index.php
	 */
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		printf("Could not initialize SDL: %s\n", SDL_GetError());
		exit(1);
	}

	/* Maak het venster aan met de gegeven dimensies en de gegeven titel. */
	window = SDL_CreateWindow(title, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_SHOWN);

	if (window == NULL) {
		/* Er ging iets verkeerd bij het initialiseren. */
		printf("Couldn't set screen mode to required dimensions: %s\n", SDL_GetError());
		exit(1);
	}

	/* Initialiseert de renderer. */
	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
	/* Laat de default-kleur die de renderer in het venster tekent wit zijn. */
	SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
}

/*
 * Dealloceert alle SDL structuren die geïnitialiseerd werden.
 */
void free_gui() {
	/* Dealloceert de SDL_Textures die werden aangemaakt. */
	SDL_DestroyTexture(covered_texture);
	SDL_DestroyTexture(mine_texture);
	SDL_DestroyTexture(flag_texture);
	SDL_DestroyTexture(digit_0_texture);
	SDL_DestroyTexture(digit_1_texture);
	SDL_DestroyTexture(digit_2_texture);
	SDL_DestroyTexture(digit_3_texture);
	SDL_DestroyTexture(digit_4_texture);
	SDL_DestroyTexture(digit_5_texture);
	SDL_DestroyTexture(digit_6_texture);
	SDL_DestroyTexture(digit_7_texture);
	SDL_DestroyTexture(digit_8_texture);

	/* Dealloceert het venster. */
	SDL_DestroyWindow(window);
	/* Dealloceert de renderer. */
	SDL_DestroyRenderer(renderer);

	/* Sluit SDL af. */
	SDL_Quit();
}

/*
 * Laadt alle afbeeldingen die getoond moeten worden in.
 */
void initialize_textures() {
	/*
	 * Laadt de afbeeldingen in. In deze minimalistische applicatie laden we slechts 1 afbeelding in.
	 * Indien de afbeelding niet kon geladen worden (bv. omdat het pad naar de afbeelding verkeerd is),
	 * geeft SDL_LoadBMP een NULL-pointer terug.
	 */
	SDL_Surface *covered_surface = SDL_LoadBMP("Images/covered.bmp");
	SDL_Surface *mine_surface = SDL_LoadBMP("Images/mine.bmp");
	SDL_Surface *flag_surface = SDL_LoadBMP("Images/flag.bmp");
	SDL_Surface *digit_0_surface = SDL_LoadBMP("Images/0.bmp");
	SDL_Surface *digit_1_surface = SDL_LoadBMP("Images/1.bmp");
	SDL_Surface *digit_2_surface = SDL_LoadBMP("Images/2.bmp");
	SDL_Surface *digit_3_surface = SDL_LoadBMP("Images/3.bmp");
	SDL_Surface *digit_4_surface = SDL_LoadBMP("Images/4.bmp");
	SDL_Surface *digit_5_surface = SDL_LoadBMP("Images/5.bmp");
	SDL_Surface *digit_6_surface = SDL_LoadBMP("Images/6.bmp");
	SDL_Surface *digit_7_surface = SDL_LoadBMP("Images/7.bmp");
	SDL_Surface *digit_8_surface = SDL_LoadBMP("Images/8.bmp");
	/*
	 * Zet deze afbeelding om naar een texture die getoond kan worden in het venster.
	 * Indien de texture niet kon omgezet worden, geeft de functie een NULL-pointer terug.
	 */
	covered_texture = SDL_CreateTextureFromSurface(renderer, covered_surface);
	mine_texture = SDL_CreateTextureFromSurface(renderer, mine_surface);
	flag_texture = SDL_CreateTextureFromSurface(renderer, flag_surface);
	digit_0_texture = SDL_CreateTextureFromSurface(renderer, digit_0_surface);
	digit_1_texture = SDL_CreateTextureFromSurface(renderer, digit_1_surface);
	digit_2_texture = SDL_CreateTextureFromSurface(renderer, digit_2_surface);
	digit_3_texture = SDL_CreateTextureFromSurface(renderer, digit_3_surface);
	digit_4_texture = SDL_CreateTextureFromSurface(renderer, digit_4_surface);
	digit_5_texture = SDL_CreateTextureFromSurface(renderer, digit_5_surface);
	digit_6_texture = SDL_CreateTextureFromSurface(renderer, digit_6_surface);
	digit_7_texture = SDL_CreateTextureFromSurface(renderer, digit_7_surface);
	digit_8_texture = SDL_CreateTextureFromSurface(renderer, digit_8_surface);
	/* Dealloceer het SDL_Surface dat werd aangemaakt. */
	SDL_FreeSurface(covered_surface);
	SDL_FreeSurface(mine_surface);
	SDL_FreeSurface(flag_surface);
	SDL_FreeSurface(digit_0_surface);
	SDL_FreeSurface(digit_1_surface);
	SDL_FreeSurface(digit_2_surface);
	SDL_FreeSurface(digit_3_surface);
	SDL_FreeSurface(digit_4_surface);
	SDL_FreeSurface(digit_5_surface);
	SDL_FreeSurface(digit_6_surface);
	SDL_FreeSurface(digit_7_surface);
	SDL_FreeSurface(digit_8_surface);
}

/*
 * Initialiseert onder het venster waarin het speelveld getoond zal worden, en de texture van de afbeelding die getoond zal worden.
 * Deze functie moet aangeroepen worden aan het begin van het spel, vooraleer je de spelwereld begint te tekenen.
 */
void initialize_gui() {
	initialize_window("Minesweeper");
	initialize_textures();
}

void rect_tekener(int pos_x, int pos_y, int content){
	static SDL_Texture *current_texture;
	    switch(content)
    {
        case '0':
            current_texture = digit_0_texture;
            break;

        case '1':
            current_texture = digit_1_texture;
            break;

        case '2':
            current_texture = digit_2_texture;
            break;

        case '3':
            current_texture = digit_3_texture;
            break;

        case '4':
            current_texture = digit_4_texture;
            break;

        case '5':
            current_texture = digit_5_texture;
            break;

        case '6':
            current_texture = digit_6_texture;
            break;

        case '7':
            current_texture = digit_7_texture;
            break;
        case '8':
            current_texture = digit_8_texture;
            break;
        case 'M':
            current_texture = mine_texture;
            break;
        case 0:
            current_texture = covered_texture;
            break;

        case 'F':
            current_texture = flag_texture;
            break;

		default:
            printf("Error! content is not correct");
			current_texture = covered_texture;
			break;
    }
    SDL_Rect rectangle = { pos_x * 50, pos_y * 50, IMAGE_WIDTH, IMAGE_HEIGHT };
   	SDL_RenderCopy(renderer, current_texture, NULL, &rectangle);
    
}

void test(char **array, int rows,int columns){
  
    for (int i = 0; i < rows;i++) {
        for (int j = 0; j < columns;j++) {
            char ctnt = array[i][j];
            rect_tekener(j, i, ctnt);         
        }
    }	
	SDL_RenderPresent(renderer);
}

