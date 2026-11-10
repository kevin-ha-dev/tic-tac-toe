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
    
    ret