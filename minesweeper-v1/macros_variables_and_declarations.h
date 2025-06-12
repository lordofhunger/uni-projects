enum SetupVariables{
    COLUMNS = 5, ROWS = (2 * COLUMNS), NUMBER_OF_MINES = ROWS
};
enum CharAbstractions{
    MINE = 'M', NUL = '0', ESCAPE = 'E', REVEAL = 'R', PRINT = 'P', FLAG = 'F', NIL = '\0', OUT_OF_BOUNDS = 'd'
};
// aangezien de max x-waarde 99 is, is 'd' een werkende abstractie omdat de ASCII  
// waarde ervan 100 is, verder gebruik ik 'd' niet elders in het programma.
int x, y; // x is de zoveelste rij, y is de zoveelste kolom
int started = 0;
int mines_left = NUMBER_OF_MINES;
int flags_left = NUMBER_OF_MINES;
int done = 0;
int renewed = 0;
int number_of_revealed_elements = 0;

char field[ROWS][COLUMNS];
char minefield[ROWS][COLUMNS];
char char_try;

void fieldmaker(char array[ROWS][COLUMNS]);
void get_coords();
void gather_x_or_y(int *var, int upper_bound);
void place_mines(int n);
void flagger();
void calculate_amount_of_surrounding_mines();
void calculate_numbers_minefield();
void reveal_zero(int x_coord, int y_coord);
void reveal();
void restart();
void clear_array(char array[ROWS][COLUMNS]);
void gameloop();
