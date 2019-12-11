#include <stdio.h>

char body_sign = "o"
char food_sign = "@"
char board_sign = "X"
int body_length = 10

# nie zmieniac
IFS = ''
int board_height = $(($(tput lines) - 12));
int board_width = $(($(tput cols) - 2));
int head_row_pos = $((board_height / 2));
int head_col_pos = $((board_width / 2));
int tail_row_pos = $((head_row_pos));
int tail_col_pos = $((head_col_pos + $((body_length - 1))));
int move_dir = 3;
int move_av = -1;
int points = body_length;
char[body_length] body = ''
declare move_by_row = ([0] = -1[1] = 0[2] = 1[3] = 0)
declare move_by_col = ([0] = 0[1] = 1[2] = 0[3] = -1)


void main() {

}