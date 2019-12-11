#!/bin/bash
# Caterpilar - odpowiedik gry Snake
# mozna zmienic
speed=.3
declare body_sign="o"
declare food_sign="@"
declare board_sign="X"
declare -i body_length=10

# nie zmieniac
IFS=''
declare -i board_height=$(($(tput lines)-12)) 
declare -i board_width=$(($(tput cols)-2))
declare -i head_row_pos=$((board_height/2))
declare -i head_col_pos=$((board_width/2))
declare -i tail_row_pos=$((head_row_pos))
declare -i tail_col_pos=$((head_col_pos+$((body_length-1))))
declare -i move_dir=3 
declare -i move_av=-1
declare -i points=$body_length
declare body=''
declare move_by_row=([0]=-1 [1]=0 [2]=1 [3]=0)
declare move_by_col=([0]=0 [1]=1 [2]=0 [3]=-1)

draw_board() {
    for ((bw=1; bw<=board_width+2; bw++)); do
        printf "\e[1;${bw}H$board_sign"
    done
    for ((bh=0; bh<board_height; bh++)); do
        printf "\e[$((bh+2));1H$board_sign"
        eval printf \"\${board$bh[*]}\"
        printf "$board_sign"
    done
    for ((bw=1; bw<=board_width+2; bw++)); do
        printf "\e[$((board_height+2));${bw}H$board_sign"
    done
    printf "Wynik: $((body_length-$points))\n\n"
}

draw_caterpilar() {
    for ((bh=0; bh<board_height; bh++)); do
        for ((bw=0; bw<board_width; bw++)); do
            eval "board$bh[$bw]=' '"
        done
    done
    for ((bl=1; bl<body_length; bl++)); do
        body+="1"
    done
    for ((bl=0; bl<body_length; bl++)); do
        eval board$head_row_pos[$((head_col_pos+bl))]=$body_sign
    done
}

throw_food() {
    pos='X'
    while [ $pos != ' ' ]; do
        food_row_pos=$((RANDOM % board_height))
        food_col_pos=$((RANDOM % board_width))
        eval "pos=\${board$food_row_pos[$food_col_pos]}"
    done
    eval board$food_row_pos[$food_col_pos]=$food_sign
}

init_game() {
    clear
    printf "\e[?25l"
    stty -echo
    draw_caterpilar
    throw_food
    draw_board
    
}
is_dead() {
    if [ $1 == -1 ] || [ $1 == $board_height ] || 
       [ $2 == -1 ] || [ $2 == $board_width ]; then
        return 0
    fi
    eval "pos=\${board$1[$2]}"
    if [ $pos == $body_sign ]; then
        return 0
    fi
    return 1
}

get_food() {
    body_length+=1
    eval "board$new_row_pos[$new_col_pos]=\"$body_sign\""
    body="$(((move_dir+2)%4))$body"
    head_row_pos=$new_row_pos
    head_col_pos=$new_col_pos
    throw_food;
}

move_body() {
    head_row_pos=$new_row_pos
    head_col_pos=$new_col_pos
    last_dir=$(printf $body | grep -o '[0-3]$')
    body="$(((move_dir+2)%4))${body%[0-3]}"
    eval "board$tail_row_pos[$tail_col_pos]=' '"
    eval board$head_row_pos[$head_col_pos]=$body_sign
    tail_row_pos=$((tail_row_pos+${move_by_row[(last_dir+2)%4]}))
    tail_col_pos=$((tail_col_pos+${move_by_col[(last_dir+2)%4]}))
}

move_caterpillar() {
    new_row_pos=$((head_row_pos + move_by_row[move_dir]))
    new_col_pos=$((head_col_pos + move_by_col[move_dir]))
    if is_dead $new_row_pos $new_col_pos; then
        return 1
    eval "pos=\${board$new_row_pos[$new_col_pos]}"
    elif [ $pos == $food_sign ]; then
        get_food
    else
        move_body
    fi
    return 0
}

get_key() {
    while true; do
      read -sN1 key
      case $key in 
        [qQ])
          kill -SIGQUIT $!; break;;
        [wW])
          kill -SIGHUP $!;;
        [aA])
          kill -SIGILL $!;;
        [sS])
          kill -SIGABRT $!;;
        [dD])
          kill -SIGINT $!;;
      esac
    done
}

game_loop() {
    trap "move_av=0;" SIGHUP
    trap "move_av=1;" SIGINT
    trap "move_av=2;" SIGABRT
    trap "move_av=3;" SIGILL
    trap "exit 1;" SIGQUIT
    while move_caterpillar; do
        if [ $move_av != -1 ]; then
            if [ $(((move_dir+2)%4)) != $move_av ]; then
              move_dir=$move_av
            fi
            move_av=-1
        fi
        move_caterpillar
        draw_board
        sleep $speed
    done
    printf "\e[$((board_height/2));$((board_width/2-9))HK O N I E C   G R Y"
    kill -SIGQUIT $$
}

main() {
    init_game
    game_loop &
    get_key
    printf "\e[?25h"
    stty echo
}

main  
exit 0