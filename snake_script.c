#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>

struct winsize w;
char body_sign = "o"
char food_sign = "@"
char board_sign = "X"
int body_length = 10

ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
int board_height = w.ws_row - 12;
int board_width = w.ws_col - 2;
int head_row_pos = board_height/2;
int head_col_pos = board_width/2;
int tail_row_pos = head_row_pos;
int tail_col_pos = head_col_pos + body_length - 1;
int move_dir = 3;
int move_av = -1;
int points = body_length;
char[body_length] body = '';
int[] move_by_row = [-1, 0, 1, 0];
int[] move_by_col = [0, 1, 0, -1]


void draw_board() {

}

void draw_caterpilar() {

}

void throw_food() {

}

void init_game() {

}

int is_dead(int pos_row, int pos_col) {

}

void get_food() {

}

void move_body() {

}

int move_caterpillar() {

}

void get_key() {

}

void game_loop() {

}

void main() {

}