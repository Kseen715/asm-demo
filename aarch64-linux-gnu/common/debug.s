// cpu aarch64
.data
.align 3
.lbyte:     .asciz "%02X"
.lnewline:  .asciz "\n"
.lregbuf1:  .quad 0

.lx0:       .asciz "\t x0=0x"
.lx1:       .asciz "\t x1=0x"
.lx2:       .asciz "\t x2=0x"
.lx3:       .asciz "\t x3=0x"
.lx4:       .asciz "\t x4=0x"
.lx5:       .asciz "\t x5=0x"
.lx6:       .asciz "\t x6=0x"
.lx7:       .asciz "\t x7=0x"
.lx8:       .asciz "\t x8=0x"
.lx9:       .asciz "\t x9=0x"
.lx10:      .asciz "\tx10=0x"
.lx11:      .asciz "\tx11=0x"
.lx12:      .asciz "\tx12=0x"
.lx13:      .asciz "\tx13=0x"
.lx14:      .asciz "\tx14=0x"
.lx15:      .asciz "\tx15=0x"
.lx16:      .asciz "\tx16=0x"
.lx17:      .asciz "\tx17=0x"
.lx18:      .asciz "\tx18=0x"
.lx19:      .asciz "\tx19=0x"
.lx20:      .asciz "\tx20=0x"
.lx21:      .asciz "\tx21=0x"
.lx22:      .asciz "\tx22=0x"
.lx23:      .asciz "\tx23=0x"
.lx24:      .asciz "\tx24=0x"
.lx25:      .asciz "\tx25=0x"
.lx26:      .asciz "\tx26=0x"
.lx27:      .asciz "\tx27=0x"
.lx28:      .asciz "\tx28=0x"
.lx29:      .asciz "\tx29=0x"
.lx30:      .asciz "\tx30=0x"

.llr:       .asciz "\t lr=0x" // Link register, x30
.lsp:       .asciz "\t sp=0x"

.text
.global log_byte
.global log_new_line
.global log_bytearray_le
.global log_registers
.extern printf

// Print a byte in hex
// x0: pointer to the byte
log_byte:
    // Save link register
    STP x29, x30, [sp, #-16]!
    MOV x29, sp

    MOV x1, x0
    ADR x0, .lbyte
    BL printf

    // Restore registers and return
    LDP x29, x30, [sp], #16
    RET

log_new_line:
    // Save link register
    STP x29, x30, [sp, #-16]!
    MOV x29, sp

    ADR x0, .lnewline
    BL printf

    // Restore registers and return
    LDP x29, x30, [sp], #16
    RET

// Print a byte array in hex
// x0: pointer to the byte array
// x1: size of the byte array
log_bytearray_le:
    // Save all registers (16-byte aligned)
    STP x29, x30, [sp, #-48]!   // Create stack frame
    STP x19, x20, [sp, #16]     // Save callee-saved regs
    STP x21, x22, [sp, #32]     // Save more regs
    MOV x29, sp

    // Save parameters to callee-saved regs
    MOV x19, x0                 // Save array pointer
    MOV x20, x1                 // Save size

    // Loop through array
    MOV x21, #0 // Initialize counter
.log_bytearray_le_loop_body:
    LDRB w0, [x19, x21]         // Load byte using saved pointer
    BL log_byte                 // Print byte

    ADD x21, x21, #1            // Increment counter
    CMP x21, x20                // Compare with saved size
    B.LT .log_bytearray_le_loop_body

    // Restore and return
    LDP x21, x22, [sp, #32]     // Restore saved regs
    LDP x19, x20, [sp, #16]     // Restore saved regs
    LDP x29, x30, [sp], #48     // Restore frame and return
    RET

// Print a byte array in hex (big endian)
// x0: pointer to the byte array
// x1: size of the byte array
log_bytearray_be:
    // Save all registers (16-byte aligned)
    STP x29, x30, [sp, #-48]!   // Create stack frame
    STP x19, x20, [sp, #16]     // Save callee-saved regs
    STP x21, x22, [sp, #32]     // Save more regs
    MOV x29, sp

    // Save parameters to callee-saved regs
    MOV x19, x0 // Save array pointer
    MOV x20, x1 // Save size

    // Start from end of array
    SUB x21, x20, #1 // Initialize counter to size-1

.log_bytearray_be_loop_body:
    CMP x21, #0 // Compare with 0 (end condition)
    B.LT .log_bytearray_be_done

    LDRB w0, [x19, x21]       // Load byte using saved pointer
    BL log_byte               // Print byte

    SUB x21, x21, #1 // Decrement counter
    B .log_bytearray_be_loop_body

.log_bytearray_be_done:
    // Restore and return
    LDP x21, x22, [sp, #32]  // Restore saved regs
    LDP x19, x20, [sp, #16]  // Restore saved regs
    LDP x29, x30, [sp], #48  // Restore frame and return
    RET

// Print all registers (2 on each line)
log_registers:
    // Save all registers (16-byte aligned)
    STP x29, x30, [sp, #-48]!   // Create stack frame
    STP x19, x20, [sp, #16]     // Save callee-saved regs
    STP x21, x22, [sp, #32]     // Save more regs
    // Store xzr and sp in 304
    // Save x0-x30
    STP x0, x1, [sp, #48]
    STP x2, x3, [sp, #64]
    STP x4, x5, [sp, #80]
    STP x6, x7, [sp, #96]
    STP x8, x9, [sp, #112]
    STP x10, x11, [sp, #128]
    STP x12, x13, [sp, #144]
    STP x14, x15, [sp, #160]
    STP x16, x17, [sp, #176]
    STP x18, x19, [sp, #192]
    STP x20, x21, [sp, #208]
    STP x22, x23, [sp, #224]
    STP x24, x25, [sp, #240]
    STP x26, x27, [sp, #256]
    STP x28, x29, [sp, #272]
    STP x30, lr, [sp, #288]
    MOV x29, sp

    // REG x0
    STP x0, x1, [sp, #48]
    ADR x0, .lx0
    BL printf
    LDP x0, x1, [sp, #48]
    // Save x0 and x1
    STP x0, x1, [sp, #48]
    // Get .lregbuf1 address
    ADR x1, .lregbuf1
    // Store x0 in .lregbuf1 variable
    STR x0, [x1]
    // Print x0
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be
    // Restore x0 and x1
    LDP x0, x1, [sp, #48]

    // REG x1
    STP x0, x1, [sp, #48]
    ADR x0, .lx1
    BL printf
    LDP x0, x1, [sp, #48]
    // Save x0 and x1
    STP x0, x1, [sp, #48]
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store x0 in .lregbuf1 variable
    STR x1, [x0]
    // Print x0
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be
    // Restore x0 and x1
    LDP x0, x1, [sp, #48]

    // REG x2
    ADR x0, .lx2
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x2, x3, [sp, #64]
    STR x2, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x3
    ADR x0, .lx3
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x2, x3, [sp, #64]
    STR x3, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x4
    ADR x0, .lx4
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x4, x5, [sp, #80]
    STR x4, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x5
    ADR x0, .lx5
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    MOV x5, 0x55
    LDP x4, x5, [sp, #80]
    STR x5, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x6
    ADR x0, .lx6
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x6, x7, [sp, #96]
    STR x6, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x7
    ADR x0, .lx7
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x6, x7, [sp, #96]
    STR x7, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x8
    ADR x0, .lx8
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x8, x9, [sp, #112]
    STR x8, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x9
    ADR x0, .lx9
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x8, x9, [sp, #112]
    STR x9, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x10
    ADR x0, .lx10
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x10, x11, [sp, #128]
    STR x10, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x11
    ADR x0, .lx11
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x10, x11, [sp, #128]
    STR x11, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x12
    ADR x0, .lx12
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x12, x13, [sp, #144]
    STR x12, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x13
    ADR x0, .lx13
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x12, x13, [sp, #144]
    STR x13, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x14
    ADR x0, .lx14
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x14, x15, [sp, #160]
    STR x14, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x15
    ADR x0, .lx15
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x14, x15, [sp, #160]
    STR x15, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x16
    ADR x0, .lx16
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x16, x17, [sp, #176]
    STR x16, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x17
    ADR x0, .lx17
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x16, x17, [sp, #176]
    STR x17, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x18
    ADR x0, .lx18
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x18, x19, [sp, #192]
    STR x18, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x19
    ADR x0, .lx19
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x18, x19, [sp, #192]
    STR x19, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x20
    ADR x0, .lx20
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x20, x21, [sp, #208]
    STR x20, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x21
    ADR x0, .lx21
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x20, x21, [sp, #208]
    STR x21, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x22
    ADR x0, .lx22
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x22, x23, [sp, #224]
    STR x22, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x23
    ADR x0, .lx23
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x22, x23, [sp, #224]
    STR x23, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x24
    ADR x0, .lx24
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x24, x25, [sp, #240]
    STR x24, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x25
    ADR x0, .lx25
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x24, x25, [sp, #240]
    STR x25, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x26
    ADR x0, .lx26
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x26, x27, [sp, #256]
    STR x26, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x27
    ADR x0, .lx27
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x26, x27, [sp, #256]
    STR x27, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x28
    ADR x0, .lx28
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x28, x29, [sp, #272]
    STR x28, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG x29
    ADR x0, .lx29
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x28, x29, [sp, #272]
    STR x29, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // REG x30
    ADR x0, .lx30
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store reg in .lregbuf1 variable
    LDP x30, x2, [sp, #288]
    STR x30, [x0]
    // Print reg
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG lr
    ADR x0, .llr
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store lr in .lregbuf1 variable
    LDP x30, x2, [sp, #288]
    STR lr, [x0]
    // Print lr
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    // REG sp
    ADR x0, .lsp
    BL printf
    // Get .lregbuf1 address
    ADR x0, .lregbuf1
    // Store sp in .lregbuf1 variable
    LDP xzr, x2, [sp, #304]
    MOV x2, sp
    STR x2, [x0]
    // Print sp
    MOV x1, 8
    ADR x0, .lregbuf1
    BL log_bytearray_be

    BL log_new_line

    // Restore and return
    LDP x0, x1, [sp, #48]
    LDP x2, x3, [sp, #64]
    LDP x4, x5, [sp, #80]
    LDP x6, x7, [sp, #96]
    LDP x8, x9, [sp, #112]
    LDP x10, x11, [sp, #128]
    LDP x12, x13, [sp, #144]
    LDP x14, x15, [sp, #160]
    LDP x16, x17, [sp, #176]
    LDP x18, x19, [sp, #192]
    LDP x20, x21, [sp, #208]
    LDP x22, x23, [sp, #224]
    LDP x24, x25, [sp, #240]
    LDP x26, x27, [sp, #256]
    LDP x28, x29, [sp, #272]
    LDP x30, x0, [sp, #288]
    LDP x0, x1, [sp, #48]// Restore x0 and x1

    LDP x21, x22, [sp, #32]    // Restore saved regs
    LDP x19, x20, [sp, #16]    // Restore saved regs
    LDP x29, x30, [sp], #48    // Restore frame and return
    RET
