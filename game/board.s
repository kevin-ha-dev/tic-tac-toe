.section .text
.global clear_board
.type clear_board, %function

clear_board:
    ldr x1, =board

    mov w2, #0

loop:
    cmp w2, #9
    b.ge clear_rows
    # address + i*4
    add x3, x1, w2, UXTW #2
    # store 0 into board[i]
    mov x4, #0
    str w4, [x3]

    #  i += 1
    add w2, w2, #1

    b loop

clear_rows:
    ldr x1, =rows
    mov w2, #0
    mov x3, #0

rows_loop:
    cmp w2, #3
    b.ge clear_cols
    
    add x3, x1, w2, UXTW #2
    mov x4, #0
    str w4, [x3]

    add w2, w2, #1

    b rows_loop

clear_cols:
    ldr x1, =cols
    mov w2, #0
    mov x3, #0

cols_loop:
    cmp w2, #3
    b.ge clear_diag
    
    add x3, x1, w2, UXTW #2
    mov x4, #0
    str w4, [x3]

    add w2, w2, #1

    b cols_loop

clear_diag:
    ldr x1, =diag
    mov w2, #0
    mov x3, #0

diag_loop:
    cmp w2, #2
    b.ge loop_done
    
    add x3, x1, w2, UXTW #2
    mov x4, #0
    str w4, [x3]

    add w2, w2, #1

    b diag_loop

loop_done:
    ldr x1, =moves_played
    mov w2, #0
    str w2, [x1]
    ret




.global place_mark
.type place_mark, %function

place_mark:
    // 0 <= i <= 8
    cmp w0, #8
    b.gt invalid_move
    cmp w0, #0
    b.lt invalid_move

    // checks if board[i] == 0
    ldr x1, =board
    add x2, x1, w0, UXTW #2
    ldr w3, [x2]
    cmp w3, #0
    b.ne invalid_move

    // loads current player 
    ldr x4, =current_player
    ldr w5, [x4]

    cmp w5, #1
    b.eq player_one
    b player_two


player_one:
    ldr x8, =player1_symbol
    ldr w9, [x8]
    b store_mark

player_two:
    ldr x8, =player2_symbol
    ldr w9, [x8]
    b store_mark

store_mark:
    str w9, [x2]

    // increament moves played and sets w0 = 1 for successful move
    ldr x6, =moves_played
    ldr w7, [x6]
    add w7, w7, #1
    str w7, [x6]

    mov w0, #1

    ret

invalid_move:
    mov w0, #0
    ret 