#ifndef macros_variables_and_declarations_H_ 
#define macros_variables_and_declarations_H_

enum SetupVariables{
    COLUMNS = 10, ROWS = COLUMNS, NUMBER_OF_MINES = ROWS
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
int columns = COLUMNS;
int rows = ROWS;
int number_of_mines = NUMBER_OF_MINES;
char **field;
char **minefield;
char mf_field;
char mf_minefield;

void screenmaker(char **array);
void fieldmaker(char **array);
void get_coords();
void gather_x_or_y();
void place_mines(int n);
void flagger();
void calculate_amount_of_surrounding_mines();
void calculate_numbers_minefield();
void reveal_zero(int x_coord, int y_coord);
void reveal();
void restart();
void clear_array(char **array);
void gameloop();
void readfileproc(char **array);
void readlength();
void readinformation(char *fname);
void read_in(char *fname);
void write_out();
char** allocate_field(int rows, int columns);
void deallocate_field(char **field, int rows, int columns);
char get_field_tile(char **field, int row, int column);
void set_field_tile(char **field, int row, int column, char input);

#endif