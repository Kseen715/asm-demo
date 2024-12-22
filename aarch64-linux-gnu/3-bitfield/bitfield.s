// cpu ARM64
.include "../common/debug.s"

.global _start

.section .data
.align 3 // Ensure 8-byte alignment
bt:     .byte 0x32, 0x23, 0x47, 0x56, 0x78, 0x12, 0x34, 0x56
str:    .asciz "Byte: %02X\n"
.section .text

_start:
    MOV x1, 47              // 0b001<0111>1
    SBFM x0, x1, #1, #4     // X0 = 0b0000<0111> = 0x07
    // We moved 4 bits, from 1 to 4

    MOV x1, #47             // 0b00101<11>1
    SBFM x2, x1, #1, #2     // X2 = 0b111111<11> = 0xFF
    // We moved 2 bits, from 1 to 2
    // If the sign bit is set, the bits are filled with 1s, otherwise with 0s

    MOV x1, #47             // 0b11110<11>1
    UBFM x3, x1, #1, #2     // X3 = 0b000000<11> = 0x03
    // The same as SBFM, but the bits are filled with 0s

    MOV w1, #7              // 0b00000000_00000000_00000000_00000111
    MOV w2, #255            // 0b00000000_00000000_00000000_11111111
    EXTR w4, w1, w2, #2     // Shift w1 by 2 bits and add the rest from w2
    // w4 = <11><000000_00000000_00000000_00111111> = 0x3F

    MOV x1, #-2             // 0b11111110
    MOV x0, #0b00011111     // 31
    SBFIZ x5, x1, #1, #2    // X5 = 0b11111100 = 0xFFFFFFFFFFFFFFFC

    BL log_registers

    MOV x0, #0      // 0 - exit code
    MOV x8, #93     // syscall for exit
    SVC 0
