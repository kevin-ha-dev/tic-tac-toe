#include "raylib.h"
#include "menu.h"

#include <stddef.h>

static const Color Paper = {243, 240, 234, 255};
static const Color Ink = {36, 35, 32, 255};
static const Color Muted = {110, 106, 99, 255};
static const Color Blue = {47, 96, 132, 255};
static const Color BlueWash = {214, 228, 237, 255};
static const Color BlueWashHover = {196, 216, 230, 255};
static const Color Stone = {234, 230, 222, 255};
static const Color StoneHover = {222, 216, 206, 255};
static const Color Accent = {166, 78, 68, 255};

static Font font_title;
static Font font_mode;
static Font font_body;
static Font font_label;
static int fonts_ready;

typedef struct {
    float margin;
    float right;
    float grid_top;
    float grid_bottom;
    float rule_x;
    Rectangle one;
    Rectangle two;
    Rectangle board;
} Grid;

static Font load_first(const char **paths, int count, int size) {
    int i;

    for (i = 0; i < count; i++) {
        Font font;

        if (!FileExists(paths[i]))
            continue;

        font = LoadFontEx(paths[i], size, NULL, 0);
        if (font.baseSize == size) {
            SetTextureFilter(font.texture, TEXTURE_FILTER_BILINEAR);
            return font;
        }
    }

    return GetFontDefault();
}

static void ensure_fonts(void) {
    static const char *bold[] = {
        "/Library/Fonts/SF-Pro-Display-Bold.otf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
    };
    static const char *regular[] = {
        "/Library/Fonts/SF-Pro-Display-Regular.otf",
        "/System/Library/Fonts/Supplemental/Arial.ttf"
    };

    if (fonts_ready)
        return;

    font_title = load_first(bold, 2, 52);
    font_mode = load_first(bold, 2, 30);
    font_body = load_first(regular, 2, 18);
    font_label = load_first(regular, 2, 15);
    fonts_ready = 1;
}

static Grid make_grid(void) {
    float width = (float)GetScreenWidth();
    float height = (float)GetScreenHeight();
    float left_w;
    float cell_h;
    Grid grid;

    grid.margin = 56.0f;
    grid.right = width - grid.margin;
    grid.grid_top = 196.0f;
    grid.grid_bottom = height - 84.0f;
    left_w = (grid.right - grid.margin) * 0.62f;
    cell_h = (grid.grid_bottom - grid.grid_top) / 2.0f;
    grid.one = (Rectangle){grid.margin, grid.grid_top, left_w, cell_h};
    grid.two = (Rectangle){grid.margin, grid.grid_top + cell_h, left_w, cell_h};
    grid.rule_x = grid.margin + left_w + 28.0f;
    grid.board = (Rectangle){
        grid.rule_x + 28.0f,
        grid.grid_top,
        grid.right - (grid.rule_x + 28.0f),
        grid.grid_bottom - grid.grid_top
    };
    return grid;
}

static int hovered(Rectangle rect) {
    return CheckCollisionPointRec(GetMousePosition(), rect);
}

static void draw_tracked(Font font, const char *text, float x, float y, float size, float tracking, Color color) {
    int i;

    for (i = 0; text[i] != '\0'; i++) {
        char glyph[2] = {text[i], '\0'};
        DrawTextEx(font, glyph, (Vector2){x, y}, size, 0, color);
        x += MeasureTextEx(font, glyph, size, 0).x + tracking;
    }
}

static float tracked_width(Font font, const char *text, float size, float tracking) {
    float width = 0;
    int count = 0;
    int i;

    for (i = 0; text[i] != '\0'; i++) {
        char glyph[2] = {text[i], '\0'};
        width += MeasureTextEx(font, glyph, size, 0).x;
        count++;
    }

    if (count > 1)
        width += tracking * (float)(count - 1);
    return width;
}

static void draw_arrow(float x, float y, Color color) {
    DrawLineEx((Vector2){x, y}, (Vector2){x + 26, y}, 1.5f, color);
    DrawLineEx((Vector2){x + 17, y - 6}, (Vector2){x + 26, y}, 1.5f, color);
    DrawLineEx((Vector2){x + 17, y + 6}, (Vector2){x + 26, y}, 1.5f, color);
}

static void draw_hline(float x, float y, float width) {
    DrawRectangle((int)x, (int)y, (int)width, 1, Ink);
}

static void draw_mode(Rectangle button, const char *index, const char *title, const char *detail, Color index_color) {
    float block_h = 15.0f + 16.0f + 30.0f + 12.0f + 15.0f;
    float y = button.y + (button.height - block_h) / 2.0f;
    float x = button.x + 36.0f;

    draw_tracked(font_label, index, x, y, 15, 1.6f, index_color);
    DrawTextEx(font_mode, title, (Vector2){x, y + 28}, 30, 0, Ink);
    draw_tracked(font_label, detail, x, y + 70, 15, 1.5f, Muted);
    draw_arrow(button.x + button.width - 64.0f, button.y + button.height / 2.0f, Ink);
}

static void draw_board(Grid grid) {
    const char *indexes[] = {"01", "02", "03"};
    const char *names[] = {"Player 1", "Player 2", "Player 3"};
    const char *wins[] = {"12", "8", "5"};
    float rows_top;
    float rows_bottom;
    float row_h;
    float wins_width;
    int i;

    draw_tracked(font_label, "LEADERBOARD", grid.board.x, grid.board.y + 16.0f, 15, 1.8f, Muted);
    wins_width = tracked_width(font_label, "WINS", 15, 1.8f);
    draw_tracked(font_label, "WINS", grid.right - wins_width, grid.board.y + 16.0f, 15, 1.8f, Muted);
    draw_hline(grid.board.x, grid.board.y + 46.0f, grid.board.width);

    rows_top = grid.board.y + 46.0f;
    rows_bottom = grid.board.y + grid.board.height - 48.0f;
    row_h = (rows_bottom - rows_top) / 3.0f;

    for (i = 0; i < 3; i++) {
        float row_y = rows_top + row_h * (float)i;
        float text_y = row_y + (row_h - 18.0f) / 2.0f;
        float win_w = MeasureTextEx(font_mode, wins[i], 30, 0).x;

        if (i > 0)
            draw_hline(grid.board.x, row_y, grid.board.width);

        draw_tracked(font_label, indexes[i], grid.board.x, text_y + 2.0f, 15, 1.2f, Accent);
        DrawTextEx(font_body, names[i], (Vector2){grid.board.x + 44.0f, text_y}, 18, 0, Ink);
        DrawTextEx(font_mode, wins[i], (Vector2){grid.right - win_w, text_y - 6.0f}, 30, 0, Ink);
    }

    draw_hline(grid.board.x, rows_bottom, grid.board.width);
    draw_tracked(
        font_label,
        "RANKED BY TOTAL WINS",
        grid.board.x,
        rows_bottom + 16.0f,
        15,
        1.4f,
        Muted
    );
}

void draw_menu(void) {
    Grid grid;
    int one_hot;
    int two_hot;
    float menu_w;

    ensure_fonts();
    grid = make_grid();
    one_hot = hovered(grid.one);
    two_hot = hovered(grid.two);

    if (one_hot || two_hot)
        SetMouseCursor(MOUSE_CURSOR_POINTING_HAND);
    else
        SetMouseCursor(MOUSE_CURSOR_DEFAULT);

    DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Paper);
    DrawTextEx(font_title, "TIC TAC TOE", (Vector2){grid.margin, 44}, 52, -1, Ink);

    menu_w = tracked_width(font_label, "MENU", 15, 2.4f);
    draw_tracked(font_label, "MENU", grid.right - menu_w, 76, 15, 2.4f, Muted);
    DrawRectangle((int)grid.margin, 120, (int)(grid.right - grid.margin), 3, Accent);
    draw_tracked(font_label, "CHOOSE YOUR GAME MODE", grid.margin, 140, 15, 1.8f, Muted);

    DrawRectangleRec(grid.one, one_hot ? BlueWashHover : BlueWash);
    DrawRectangleRec(grid.two, two_hot ? StoneHover : Stone);
    DrawRectangle((int)grid.one.x, (int)grid.one.y, 8, (int)grid.one.height, Blue);
    DrawRectangle((int)grid.two.x, (int)grid.two.y, 8, (int)grid.two.height, Accent);

    draw_hline(grid.margin, grid.grid_top, grid.right - grid.margin);
    draw_hline(grid.margin, grid.one.y + grid.one.height, grid.one.width);
    draw_hline(grid.margin, grid.grid_bottom, grid.right - grid.margin);
    DrawRectangle((int)grid.rule_x, (int)grid.grid_top, 1, (int)(grid.grid_bottom - grid.grid_top) + 1, Ink);

    draw_mode(grid.one, "01", "1 PLAYER", "VS COMPUTER", Blue);
    draw_mode(grid.two, "02", "2 PLAYER", "LOCAL MATCH", Accent);
    draw_board(grid);

    draw_tracked(
        font_label,
        "SAMPLE LEADERBOARD DATA",
        grid.margin,
        grid.grid_bottom + 22.0f,
        15,
        1.6f,
        Muted
    );
}

MenuChoice handle_menu_input(void) {
    Grid grid;
    Vector2 mouse;

    if (!IsMouseButtonPressed(MOUSE_BUTTON_LEFT))
        return MENU_NONE;

    grid = make_grid();
    mouse = GetMousePosition();

    if (CheckCollisionPointRec(mouse, grid.one))
        return MENU_ONE_PLAYER;
    if (CheckCollisionPointRec(mouse, grid.two))
        return MENU_TWO_PLAYER;

    return MENU_NONE;
}
