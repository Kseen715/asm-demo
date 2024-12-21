// cpu ARM64

.global _start

.section .data
msg:	.ascii	"Hello World!\n"
len = . - msg

.section .text
_start:
	mov x0, #1		// 1 - stdout
	ldr x1, =msg	// Adress of the string
	mov x2, len 	// Length of the string
	mov x8, #64		// syscall for write
	svc 0			// Call the kernel
	
	mov x0, #0		// 0 - exit code
	mov x8, #93		// syscall for exit
	svc 0
    