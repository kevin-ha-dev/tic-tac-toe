CC = cc
CFLAGS = -std=c11 -Wall -Wextra -Wpedantic
RAYLIB_CFLAGS = $(shell pkg-config --cflags raylib)
RAYLIB_LIBS = $(shell pkg-config --libs raylib)

SRCS = main.c
TARGET = tic-tac-toe

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(RAYLIB_CFLAGS) -o $(TARGET) $(SRCS) $(RAYLIB_LIBS)

clean:
	rm -f $(TARGET)
