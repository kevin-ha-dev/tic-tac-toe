#include "raylib.h"
#include "frontend/menu.h"

int main(void) {
    InitWindow(1040, 680, "Tic Tac Toe");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        MenuChoice choice = handle_menu_input();

        if (choice == MENU_ONE_PLAYER)
            TraceLog(LOG_INFO, "1 PLAYER selected");
        else if (choice == MENU_TWO_PLAYER)
            TraceLog(LOG_INFO, "2 PLAYER selected");

        BeginDrawing();
        ClearBackground((Color){243, 240, 234, 255});
        draw_menu();
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
