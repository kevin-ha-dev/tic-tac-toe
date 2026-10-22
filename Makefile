CC = cc
CFLAGS = -std=c11 -Wall -Wextra -Wpedantic -Ifrontend

SRCS = main.c frontend/frontend.c frontend/menu.c frontend/game_screen.c
TARGET = tic-tac-toe

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRCS) frontend/frontend.h
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS)

clean:
	rm -f $(TARGET)
