.section .text
.global toss_up
.type toss_up, %function

toss_up:
    ldr x1, =toss_winner 

    // Step 1: Generate a random number
    
    // Step 2: Convert result to 1 or 2

    // Step 3: Load address of toss_winner

    // Step 4: Store w0 into toss_winner

    // Step 5: Return
    ret