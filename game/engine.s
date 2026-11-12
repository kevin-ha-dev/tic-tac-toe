.text

.global start_game

.global play_turn

start_game:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x1, =game_status
    mov w2, #0
    str w2, [x1]

    bl clear_board
    bl toss_up

    // stores which player goes first from toss_up
    ldr x2, =current_player
    str w0, [x2]

    // player symbols
    ldr x3, =player1_symbol
    mov w4, #1
    str w4, [x3]
    ldr x3, =player2_symbol
    mov w4, #-1
    str w4, [x3]


    ldp x29, x30, [sp], #16
    ret 

play_turn: 
    // save FP and return address
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // allocate another 16 bytes 
    sub sp, sp, #16
    // saves index passed from frontend onto the stack pointer
    str w0, [sp]

    ldr x1, =game_status
    ldr w2, [x1]
    cmp w2, #0
    b.ne invalid_move

    bl place_mark
    cmp w0, #1
    b.ne invalid_move

    // load back index after check from place mark
    ldr w0, [sp]
    bl check_winner 


    // checks if check_winner returned a winner 
    cmp w0, #0
    b.eq no_winner

    b game_over


invalid_move:
    mov w0, #-1
    b finish_turn

no_winner:
    ldr x5, =moves_played
    ldr w6, [x5]
    cmp w6, #9
    b.eq tie_game

    bl switch_player
    mov w0, #0
    b finish_turn

finish_turn:
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret


tie_game:
    mov w0, #3         
    b game_over

game_over:
    ldr x1, =game_status
    str w0, [x1]
    b finish_turn




