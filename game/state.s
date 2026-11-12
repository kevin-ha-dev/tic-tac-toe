.bss
.balign 4

// Board (9 integers)
// 0 = Empty, 1 = X, -1 = O
.global board
board:
    .skip 36

// Winner detection counters
.global rows
rows:
    .skip 12

.global cols
cols:
    .skip 12

.global diag
diag:
    .skip 8

// Turn management
// current_player: 1 = Player 1, 2 = Player 2
.global current_player
current_player:
    .skip 4

.global moves_played
moves_played:
    .skip 4

// Pre-game states
// game_phase: 0 = Main menu, 1 = Coin flip, 2 = Symbol selection, 3 = Playing, 4 = Game over
.global game_phase
game_phase:
    .skip 4

// toss_winner: 1 = Player 1, 2 = Player 2
.global toss_winner
toss_winner:
    .skip 4

// player1_symbol: 0 = Not assigned, 1 = X, -1 = O
.global player1_symbol
player1_symbol:
    .skip 4

// player2_symbol: 0 = Not assigned, 1 = X, -1 = O
.global player2_symbol
player2_symbol:
    .skip 4

// Game result
// game_status: 0 = Ongoing, 1 = Player 1 wins, 2 = Player 2 wins, 3 = Draw
.global game_status
game_status:
    .skip 4


