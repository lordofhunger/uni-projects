#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include "macros_variables_and_declarations.h"

// main zal de gameloop aanroepen.
void main(){
    gameloop();
}
// de gameloop zal ervoor zorgen dat ons spel continu draait en commando's aanvaard en dat deze de juiste
// acties laten gebeuren.
void gameloop(){
    char cmd, split_space;
    while (1){
        srand(time(NULL)); // seed random
        cmd = getchar();   // neem het gegeven commando op uit de terminal
        while (cmd == ' ' || cmd == '\n'|| cmd == '\t'){   
            cmd = getchar();                // toegevoegd voor stel je maakt een typfout dat je nog steeds
                                            // het gewenste effect kan krijgen.
        }
        if (cmd == ESCAPE){                            
            return; // snel uit spel geraken (niet per se nodig aangezien ctrl + c hetzelfde effect heeft)
        
        }else if (cmd == REVEAL && ((split_space = getchar()) == ' ')){ // cap op cijfers moet rest van procedures stoppen
            get_coords();
            if( x != OUT_OF_BOUNDS && y != OUT_OF_BOUNDS){
                if (started != 1){
                    place_mines(NUMBER_OF_MINES);
                    calculate_numbers_minefield();
                    started = 1;
                }
                reveal();
                if (done){
                    return;
                }
                if (renewed != 1){
                    fieldmaker(field);
                    printf("Flags left: %i \n", flags_left);
                } else {
                    renewed = 0;
                }
            }
        }else if (cmd == PRINT){ 
            fieldmaker(minefield);

        }else if (cmd == FLAG && ((split_space = getchar()) == ' ')){ // nood aan aanpassingen eens andere procedures vernieuwd
            get_coords();
            if( x != OUT_OF_BOUNDS && y != OUT_OF_BOUNDS){
            flagger(); 
            if (done == 1){
            return;
            }else if (renewed != 1){
                fieldmaker(field); 
                printf("Flags left: %i \n", flags_left); 
            } else {
                renewed = 0;
            }
        }                           // extra cmd's kunnen makkelijk toegevoegd worden door een extra
        }else {                     // else if tak te maken met daarin het effect.
            //while (cmd != '\n'){
             //   cmd = getchar();
            //}
            printf("Error 1: unknown command.\n");
        }
    }     
}
// onderstaande procedure zal de x en y coordinaten nemen van het commando indien dit nodig is.
void get_coords(){
    gather_x_or_y(&x,ROWS);
    gather_x_or_y(&y,COLUMNS);
}
// onderstaande procedure zal een bepaald getal assignen aan een bepaalde variabele.
void gather_x_or_y(int *var,int upper_bound){
    *var = 0;
    
    char_try = getchar();
    while(1){
        if (isdigit(char_try)){
            *var = 10 * *var + (char_try - 48);
            char_try = getchar();
        }else {
            if (*var >= upper_bound){
                printf("Error 3: variable out of bounds \n");
                *var = OUT_OF_BOUNDS;
            }
            break;
        }
    }
}
// fieldmaker zal een array in de terminal printen.
void fieldmaker(char array[ROWS][COLUMNS]){
    int i,j;
    for (i = 0; i < COLUMNS; i++) {    // print de indices boven de bovenste lijn
        if (i == 0){
            printf("    ");
        }
        if (i < 10){
            printf(" %i  ",i);
        } else if(i < 50){
            printf(" %i ",i);
        }
    } 
    printf("\n");

    for (i = 0; i < ROWS;i++) {
        if (i < 10){
            printf("%i  |", i); // print linkse indices
        }else if (i < 100){
            printf("%i |", i); // print linkse indices
        }
        for (j = 0; j < COLUMNS;j++) {
            if (array[i][j] == NIL){ // print een spatie indien het character nil is
                printf("   ");
            }else {
                printf(" %c ",array[i][j]); // print de character op coördinaat (i,j)
            }
            printf("|");
            
        }
        printf("\n");
    }     
}
//m ines_generator genereert de mijnen in het begin van het spel na de eerste reveal is ingegeven.
void place_mines(int n){
    int i,j;
    if (started != 1){
        while (n > 0){
            i = rand() % ROWS;
            j = rand() % COLUMNS;
            if(minefield[i][j] != MINE && i != x && j != y){
                minefield[i][j] = MINE;
                n--;
            }
        }
    }
}
// onderstaande procedure zal het aantal aangrenzende mijnen aan vakje (n,m) op diens locatie in minefield
// plaatsen.
void calculate_amount_of_surrounding_mines(int n, int m, char array[ROWS][COLUMNS]){
    int i,j,k,l,nr_m = 0;
    if ((m >= COLUMNS) || (m <= -1) || (n >= ROWS) || (n <= -1)){
        return;
    }
    if (minefield[n][m] == MINE){
        array[n][m] = MINE;
        return;
    }
    for(i = n - 1;i <= n + 1; i++){
        for (j = m - 1; j <= m + 1; j++){
            if (minefield[i][j] == MINE && (i != n || j != m) && (j < COLUMNS) && (j > -1) && (i < ROWS) && (i > -1)){
                nr_m++;
            }
        }
    }
    array[n][m] = nr_m + NUL;
}
// onderstaande procedure zal elk vakje het bijhorend getal geven duidend op het aangrenzend aantal mijnen
// ik heb gekozen om deze te bewaren in het mijnenveld zodat ik niet telkens ik reveal oproep eerst nog
// een hoop berekeningen moet gaan doen.
void calculate_numbers_minefield(){
    int cnm_i, cnm_j;
    for(cnm_i = 0;cnm_i < ROWS;cnm_i++){
        for(cnm_j = 0;cnm_j < COLUMNS ;cnm_j++){
            calculate_amount_of_surrounding_mines(cnm_i, cnm_j, minefield);
        }
    }
    
}
// onderstaande procedure staat in voor het revealen van vakjes met locatie rij = x, kolom = y.
void reveal(){
    if (field[x][y] == NIL){
        if ((minefield[x][y] != MINE) && (field[x][y] == NIL)){
            field[x][y] = minefield[x][y];
            if (field[x][y] == NUL){
                reveal_zero(x,y);
            }
            number_of_revealed_elements++;
            if (number_of_revealed_elements == (ROWS * COLUMNS) - NUMBER_OF_MINES){
                printf("You have revealed all squares! Play again? (Y/N)\n");
                restart();
            }
        }else if (minefield[x][y] = MINE){
            field[x][y] = minefield[x][y];
            printf("BOOM! You have hit a mine! Try again? (Y/N)\n");
            restart();
        }
    }
}
// onderstaande procedure staat in voor het onthullen van vakjes rondom een nul, en indien een dezer vakjes nul is, ook daarrond.
void reveal_zero(int x_coord, int y_coord){
    int i, j, k = x_coord, l = y_coord;
    if ((x_coord >= 0) && (x_coord < ROWS) && (y_coord >= 0) && (y_coord < COLUMNS)){
        for(i = x_coord - 1; i <= x_coord + 1; i++){
            for(j = y_coord - 1; j <= y_coord + 1; j++){
                if ((field[i][j] == NIL) &&(i != x_coord || j != y_coord) && (field[i][j] != FLAG) && ((i >= 0) && (i < ROWS) && (j >= 0) && (j < COLUMNS))){
                    field[i][j] = minefield[i][j];
                    number_of_revealed_elements++;
                    if(field[i][j] == NUL){
                        reveal_zero(i,j);
                    }
                }
            }
        }
    }
}
// onderstaande procedure zal instaan voor het flaggen en deflaggen van het vakje met locatie rij = x en kolom = y.
void flagger(){
    if ((flags_left == 0) && (field[x][y] != FLAG)){
        printf("Error 3: No flags left. \n");
        return;
    }
     if (field[x][y] == FLAG){
        if (minefield[x][y] == MINE){
            mines_left++;
        }
        flags_left++;
        field[x][y] = NIL;
    } else if (minefield[x][y] == MINE){
        mines_left--;
        flags_left--;
        field[x][y] = FLAG;
        if (mines_left == 0){
            printf("You have succesfully defused all the mines! Play again? (Y/N)\n");
            restart();
        }
    } else {
        flags_left--;
        field[x][y] = FLAG;
    }
}
// onderstaande procedure neemt een array als invoer en zet al diens waarden op nil, nodig voor het herstarten van het spel.
void clear_array(char array[ROWS][COLUMNS]){
    char i, j;
    for (i = 0; i < ROWS; i++){
        for (j = 0; j < ROWS; j++){
            array[i][j] = NIL;
        }
    }
}
// onderstaande procedure staat in voor het herstarten van het spel na een overwinning/nederlaag.
void restart(){
    int answer = getchar();
    if (answer == 'Y'){
        started = 0;
        mines_left = NUMBER_OF_MINES;
        flags_left = NUMBER_OF_MINES;
        clear_array(field);
        clear_array(minefield);
        renewed = 1;
        printf("Game restarted.\n"); // ik vond dit een goede toevoeging aangezien het anders kan lijken dat er niets gebeurt is.
    }else {  // als er iets anders dan Y ingetypt wordt eindigt het spel.
        done = 1;
    }
}