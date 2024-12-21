// cpu ARM64
.global _start

.section .data
.align 3 // Ensure 8-byte alignment

.section .text

_start:
    // Load 0x0004000300020001 into X0
    // MOV X0, #0x0004000300020001 -- This will not work
    MOVK X0, #0x0001, LSL#0  // Load first 16 bits
    MOVK X0, #0x0002, LSL#16 // Load next 16 bits
    MOVK X0, #0x0003, LSL#32 // Load next 16 bits
    MOVK X0, #0x0004, LSL#48 // Load last 16 bits
    // MOVK will not clear the rest of the bits, so we need to clear them

    // We can also use MOVZ to load the value,
    // and it will clear the rest of the bits
    MOVZ X0, #0x0001, LSL#0  // Load first 16 bits
    MOVZ X0, #0x0002, LSL#16 // Load next 16 bits
    MOVZ X0, #0x0003, LSL#32 // Load next 16 bits
    MOVZ X0, #0x0004, LSL#48 // Load last 16 bits

    // MOVN can be used to store negative copies of the value
    MOVN X1, #0xFFFE // This will store 0xFFFFFFFFFFFF0001 in X1

    // Another way to load a negative value is to use MOV with a negative value
    MOV W1, #0xFFFFFFFE // (-2)

    MOV X0, #0      // 0 - exit code
    MOV X8, #93     // syscall for exit
    SVC 0
