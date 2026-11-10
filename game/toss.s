.section .text
.global toss_up
.type toss_up, %function

toss_up:
    // Store return address in stack
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Generate a random number
    bl rand
    
    // Convert result to 1 or 2
    and w0, w0, #1
    add w0, w0, #1

    // Store random number
    ldr x1, =toss_winner 
    str w0, [x1]

    ldp x29, x30, [sp], #16

    ret