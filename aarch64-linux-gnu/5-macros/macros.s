// cpu ARM64
.global _start

.section .data
.align 3 // Ensure 8-byte alignment
msg:            .asciz "Hello World!\n"
    len_msg = .- msg

buffer:         .fill 256, 1, 0
    len_buffer = .- buffer

.section .text

// Macro copy, which copies characters from one string to another
// Macro parameters
// X0 - address of the incoming string
// X1 - address of the outgoing string
//
// Result
// X0 - string length
.macro copy_str inputstr, outputstr
    LDR X0, =\inputstr
    LDR X1, =\outputstr
    MOV X4, X1 // Save the start address of the string

// in the loop we get all the bytes until we reach the zero byte
1:
    LDRB W5, [X0], #1   // load one byte from X0, X0++
    CMP W5, #0          // compare with zero byte
    B.EQ 2f             // if zero byte, go to label 2
    STRB W5, [X1], #1   // store one byte W5 -> X1, X1++
    B 1b                // go back to label 1
2:
    SUB X0, X1, X4 // X0 = X1 - X4
.endm

_start:
    copy_str msg, buffer
    MOV X2, X0
    MOV X0, #1
    LDR X1, =buffer
    MOV X8, #64
    SVC 0

    MOV X0, #0      // 0 - exit code
    MOV X8, #93     // syscall for exit
    SVC 0
