#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include "macros_variables_and_declarations.h"
#include "GUI.h"
// main zal de gameloop aanroepen.

void main()
{
    read_in("testfile.txt");
    gameloop();
    deallocate_field(field, rows,columns);
    deallocate_field(field, rows,columns);
}

char** allocate_field(int rows, int columns)
{
    char **field = (char **)calloc(rows, sizeof(char *));
    for (int k = 0; k < rows; k++)
    {
        field[k] = (char *)calloc(columns, sizeof(char));
    }
    return field;
}

void deallocate_field(char **field, int rows, int columns)
{
    for (int k = 0; k < rows; k++)
    {
        free(field[k]);
    }
    free(field);
}
char get_field_tile(char **field, int row, int column)
{
    return field[row][column];
}

void set_field_tile(char **field, int row, int column, char input)
{
    field[row][column] = input;
}

void write_out() // added new
{
    FILE *file1;
    int c;
    char *fname = "testfile.txt";

    /*open file and put some chars on it */
    file1 = fopen(fname, "w");
    fprintf(file1, "%d\n", columns);
    fprintf(file1, "%d\n", rows);
    fprintf(file1, "%d\n", mines_left);
    fprintf(file1, "%d\n", flags_left);
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < columns; c++)
        {
            if (get_field_tile(field, r, c) != NIL)
            {
                fprintf(file1, "%c", get_field_tile(field, r, c));
            }
            else
            {
                fprintf(file1, "%c", 'N');
            }
        }
        //fprintf(file1, "\n");
    }
    fprintf(file1, "\n");
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < columns; c++)
        {
            fprintf(file1, "%c", get_field_tile(minefield, r, c));
        }
        //fprintf(file1, "\n");
    }

    fclose(file1);
    return;
}

void read_in(char *fname) // added new
{
    FILE *file1;
    char throwaway;
    started = 1;
    /*open file and put some chars on it */
    file1 = fopen(fname, "r");
    fscanf(file1, "%d", &columns);
    fscanf(file1, "%c", &throwaway);
    fscanf(file1, "%d", &rows);
    fscanf(file1, "%c", &throwaway);
    fscanf(file1, "%d", &mines_left);
    fscanf(file1, "%c", &throwaway);
    fscanf(file1, "%d", &flags_left);
    fscanf(file1, "%c", &throwaway);

    char **field = allocate_field(rows, columns);
    char **minefield = allocate_field(rows, columns);

    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < columns; c++)
        {
            fscanf(file1, "%c", &field[r][c]);
            if (get_field_tile(field, r, c) == 'N')
            {
                set_field_tile(field, r, c, NIL);
            }
        }
        //fprintf(file1, "\n");
    }
    fscanf(file1, "%c", &throwaway);
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < columns; c++)
        {
            fscanf(file1, "%c", &minefield[r][c]);
        }
        //fprintf(file1, "\n");
    }

    fclose(file1);
    printf("columns: %d, rows:%d mines:%d, flags:%d\n", columns, rows, mines_left, flags_left);
    fieldmaker(field);
    fieldmaker(minefield);
    return;
}


// de gameloop zal ervoor zorgen dat ons spel continu draait en commando's aanvaard en dat deze de juiste
// acties laten gebeuren.
void gameloop()
{
    char cmd, split_space;
    WINDOW_HEIGHT = rows * IMAGE_HEIGHT;
    WINDOW_WIDTH = columns * IMAGE_WIDTH;
    initialize_gui();
    srand(time(NULL)); // seed random

    while (should_continue)
    {
        SDL_RenderClear(renderer);
        screenmaker(minefield);
        read_input();
        y = mouse_x;
        x = mouse_y;

        if (clicked != 0)
        {

            if (started != 1)
            {
                place_mines(3);
                calculate_numbers_minefield();
               //fieldmaker(minefield);
                started = 1;
            }

            reveal();
            if (done)
            {
                return;
            }
            if (renewed != 1)
            {
                printf("Flags left: %i \n", flags_left);
            }
            else
            {
                renewed = 0;
            }
        }
        else
        {

            clicked = 0;

            cmd = getchar(); // neem het gegeven commando op uit de terminal
            if (cmd == ESCAPE)
            {
                return; // snel uit spel geraken (niet per se nodig aangezien ctrl + c hetzelfde effect heeft)
            }
            else if (cmd == PRINT)
            {
                //fieldmaker(minefield);
            } /*
        else if (cmd == FLAG && ((split_space = getchar()) == ' ')){ // nood aan aanpassingen eens andere procedures vernieuwd
            get_coords();
            if( x != OUT_OF_BOUNDS && y != OUT_OF_BOUNDS){
            flagger(); 
            if (done == 1){
            return;
            }else if (renewed != 1){
                screenmaker(field); 
                printf("Flags left: %i \n", flags_left); 
            } else {
                renewed = 0;
            }
        }  */
              // extra cmd's kunnen makkelijk toegevoegd worden door een extra
        }
    }
}

void fieldmaker(char **array)
{
    int i, j;
    for (i = 0; i < columns; i++)
    { // print de indices boven de bovenste lijn
        if (i == 0)
        {
            printf("    ");
        }
        if (i < 10)
        {
            printf(" %i  ", i);
        }
        else if (i < 50)
        {
            printf(" %i ", i);
        }
    }
    printf("\n");

    for (i = 0; i < rows; i++)
    {
        if (i < 10)
        {
            printf("%i  |", i); // print linkse indices
        }
        else if (i < 100)
        {
            printf("%i |", i); // print linkse indices
        }
        for (j = 0; j < columns; j++)
        {
            if (array[i][j] == NIL)
            { // print een spatie indien het character nil is
                printf("   ");
            }
            else
            {
                printf(" %c ", array[i][j]); // print de character op coördinaat (i,j)
            }
            printf("|");
        }
        printf("\n");
    }
}

// fieldmaker zal een array in de terminal printen.
void screenmaker(char **array)
{
    test(array, rows, columns);
}

//m ines_generator genereert de mijnen in het begin van het spel na de eerste reveal is ingegeven.
void place_mines(int n)
{
    int r, c;
    if (started != 1)
    {
        while (n > 0)
        {
            r = rand() % rows;
            c = rand() % columns;
            if (c < columns && r < rows && c > 0 && r > 0 && get_field_tile(minefield, r, c) != MINE && r != x && c != y)
            {
                minefield[r][c] = MINE;
                n--;
            }
        }
    }
}

// onderstaande procedure zal het aantal aangrenzende mijnen aan vakje (n,m) op diens locatie in minefield
// plaatsen.
void calculate_amount_of_surrounding_mines(int n, int m, char **array)
{
    int k, l, nr_m = 0;
    if ((m >= rows) || (m <= -1) || (n >= columns) || (n <= -1))
    {
        return;
    }
    if (get_field_tile(minefield, n, m) == MINE)
    {
        set_field_tile(array, n, m, MINE);
        return;
    }

    for (int r = n - 1; r <= n + 1; r++)
    {
        for (int c = m - 1; c <= m + 1; c++)
        {
            if (get_field_tile(minefield, r, c) == MINE && (r != n || c != m) && (c < columns - 1) && (r > -1) && (r < rows - 1) && (r > -1))
            {
                nr_m++;
            }
        }
    }
    set_field_tile(array, n, m, nr_m + NUL);
}

// onderstaande procedure zal elk vakje het bijhorend getal geven duidend op het aangrenzend aantal mijnen
// ik heb gekozen om deze te bewaren in het mijnenveld zodat ik niet telkens ik reveal oproep eerst nog
// een hoop berekeningen moet gaan doen.
void calculate_numbers_minefield()
{
    
    for (int cnm_r = 0; cnm_r < rows - 1; cnm_r++)
    {
        for (int cnm_c = 0; cnm_c < columns; cnm_c++)
        {
            calculate_amount_of_surrounding_mines(cnm_r, cnm_c, minefield);
        }
    }
}

// onderstaande procedure staat in voor het revealen van vakjes met locatie rij = x, kolom = y.
void reveal()
{
    if (get_field_tile(field, x, y) == NIL)
    {
        if ((get_field_tile(minefield, x, y) != MINE) && (field[x][y] == NIL))
        {
            set_field_tile(field, x, y, get_field_tile(minefield, x, y));
            if (get_field_tile(field, x, y) == NUL)
            {
                reveal_zero(x, y);
            }
            number_of_revealed_elements++;
            if (number_of_revealed_elements == (rows * columns) - number_of_mines)
            {
                printf("You have revealed all squares! Play again? (Y/N)\n");
                restart();
            }
        }
        else if (get_field_tile(minefield, x, y) == MINE)
        {
            int ctnt = get_field_tile(minefield, x, y);
            test(minefield, columns, rows);
            screenmaker(minefield);
            set_field_tile(field, x, y, get_field_tile(minefield, x, y));
            printf("BOOM! You have hit a mine! Try again? (Y/N)\n");
            restart();
        }
    }
}

// onderstaande procedure staat in voor het onthullen van vakjes rondom een nul, en indien een dezer vakjes nul is, ook daarrond.
void reveal_zero(int x_coord, int y_coord)
{
    int  k = x_coord, l = y_coord;
    if ((x_coord >= 0) && (x_coord < rows - 1) && (y_coord >= 0) && (y_coord < columns - 1))
    {
        for (int r = x_coord - 1; r <= x_coord + 1; r++)
        {
            for (int c = y_coord - 1; c <= y_coord + 1; c++)
            {
                if ((get_field_tile(field, r, c) == NIL) && (r != x_coord || c != y_coord) && (get_field_tile(field, r, c) != FLAG) && ((r >= 0) && (r < rows) && (c >= 0) && (c < columns)))
                {
                    set_field_tile(field, r, c, get_field_tile(minefield, r, c));
                    number_of_revealed_elements++;
                    if (get_field_tile(field, r, c) == NUL)
                    {
                        reveal_zero(r, c);
                    }
                }
            }
        }
    }
}

// onderstaande procedure zal instaan voor het flaggen en deflaggen van het vakje met locatie rij = x en kolom = y.
void flagger()
{
    if ((flags_left == 0) && (get_field_tile(field, x, y) != FLAG))
    {
        printf("Error 3: No flags left. \n");
        return;
    }
    if (get_field_tile(field, x, y) == FLAG)
    {
        if (get_field_tile(minefield, x, y) == MINE)
        {
            mines_left++;
        }
        flags_left++;
        set_field_tile(field, x, y, NIL);
    }
    else if (get_field_tile(minefield, x, y) == MINE)
    {
        mines_left--;
        flags_left--;
        set_field_tile(field, x, y, FLAG);
        if (mines_left == 0)
        {
            printf("You have succesfully defused all the mines! Play again? (Y/N)\n");
            restart();
        }
    }
    else
    {
        flags_left--;
        set_field_tile(field, x, y, FLAG);
    }
}

// onderstaande procedure neemt een array als invoer en zet al diens waarden op nil, nodig voor het herstarten van het spel.
void clear_array(char **array)
{
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < columns; c++)
        {
            set_field_tile(array, r, c, NIL);
        }
    }
}

// onderstaande procedure staat in voor het herstarten van het spel na een overwinning/nederlaag.
void restart()
{
    int answer = getchar();

    if (answer == 'Y')
    {
        started = 0;
        mines_left = number_of_mines;
        flags_left = number_of_mines;
        clear_array(field);
        clear_array(minefield);
        renewed = 1;
        printf("Game restarted.\n"); // ik vond dit een goede toevoeging aangezien het anders kan lijken dat er niets gebeurt is.
    }
    else if (answer == 'N')
    { // als er iets anders dan Y ingetypt wordt eindigt het spel.
        done = 1;
    }
    else
    {
        restart();
    }
}