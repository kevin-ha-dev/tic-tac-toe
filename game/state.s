.section .bss
.balign 4

.global board
board:
    .skip 36

.global rows
rows:
    .skip 12

.global cols
cols:
    .skip 12

.global diag
diag:
    .skip 8

.global current_player
current_player:
    .skip 4

.global moves_played
moves_played:
    .skip 4