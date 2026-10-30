#include "raylib.h"

int main(void) {
    InitWindow(1040, 680, "Tic Tac Toe");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground((Color){243, 240, 234, 255});
        DrawText("Placeholder", 40, 40, 32, BLACK);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
