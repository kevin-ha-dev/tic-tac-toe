.text

.global check_winner

check_winner:

    mov w1, #3
    // row = cell / 3
    udiv w2, w0, w1
    // cols = cell % 3
    msub w3, w2, w1, w0

    ldr x4, =rows
    ldr x5, =cols
    ldr x6, =diag
    
    // address of row[i]
    add x7, x4, w2, UXTW #2
    // address of cols[i]
    add x8, x5, w3, UXTW #2

    // current player
    ldr x9, =current_player
    ldr w9, [x9]

    cmp w9, #1
    b.eq player_1
    b player_2

player_1:
    mov w10, #1
    b update_counter

player_2:   
    mov w10, #-1
    b update_counter

update_counter:
    // 1. Update rows[row]
    ldr w11, [x7]
    add w11, w11, w10
    str w11, [x7]
    // 2. Update cols[col]
    ldr w11, [x8]
    add w11, w11, w10
    str w11, [x8]
    // 3. Check whether main diagonal applies
    cmp w2, w3
    b.ne skip_main_diag
    ldr w12, [x6]
    add w12, w12, w10
    str w12, [x6]
    // 4. Check whether anti-diagonal applies
skip_main_diag:
    add w14, w2, w3
    cmp w14, #2
    b.ne winner_count
    ldr w13, [x6, #4]
    add w13, w13, w10
    str w13, [x6, #4]

    // 5. Check for winner
winner_count:
    // row winner
    ldr w14, [x7]
    cmp w14, #3
    b.eq winner_player_1
    cmn w14, #3
    b.eq winner_player_2

    // cols winner
    ldr w14, [x8]
    cmp w14, #3
    b.eq winner_player_1
    cmn w14, #3
    b.eq winner_player_2

    // diag winner 
    ldr w14, [x6]
    cmp w14, #3
    b.eq winner_player_1
    cmn w14, #3
    b.eq winner_player_2

    // anti diag winner
    ldr w14, [x6, #4]
    cmp w14, #3
    b.eq winner_player_1
    cmn w14, #3
    b.eq winner_player_2

    // no winner
    mov w0, #0
    ret 



winner_player_1:
    mov w0, #1
    ret 

winner_player_2:
    mov w0, #2
    ret










