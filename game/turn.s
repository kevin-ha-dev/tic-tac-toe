.text

.global switch_player


switch_player:
    ldr x1, =current_player
    ldr w2, [x1]
    cmp w2, #1
    b.eq player_one
    b player_two

player_one:
    mov w2, #2
    str w2, [x1]
    ret


player_two:
    mov w2, #1
    str w2, [x1]
    ret

