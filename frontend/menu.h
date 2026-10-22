
#ifndef MENU_H
#define MENU_H

typedef enum {
    MENU_NONE,
    MENU_ONE_PLAYER,
    MENU_TWO_PLAYER
} MenuChoice;

void draw_menu(void);
MenuChoice handle_menu_input(void);

#endif
