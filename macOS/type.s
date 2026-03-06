// Monmouth University CS-104 project 1: type command in assembly (macOS)

.text
.p2align 2
.globl _main
_main:
    // Check if we have exactly 2 arguments
    cmp x0, #2
    bne error

    // Get the filename from arguments
    ldr x0, [x1, #8]       // x0 = filename
    mov x1, #0              // read-only mode for open

    // Open the file
    mov x16, #5
    svc #0x80

    // Check if open succeeded
    cmp x0, #0
    blt error

    // Save file descriptor and allocate memory
    add x20, x0, #0         // x20 = file descriptor
    sub sp, sp, #8          // allocate 8 bytes for 1 char

loop:
    // Set up arguments for read
    add x0, x20, #0         // fd
    add x1, sp, #0          // buffer
    mov x2, #1              // read 1 byte
    mov x16, #3
    svc #0x80

    // Check read result
    cmp x0, #0
    beq done                // EOF
    blt error               // error

    // Set up arguments for write
    mov x0, #1              // stdout
    add x1, sp, #0          // buffer
    mov x2, #1              // 1 byte
    mov x16, #4
    svc #0x80

    // Check write result
    cmp x0, #1
    bne error

    b loop                  // repeat

error:
    mov x0, #1
done:
    mov x16, #1
    svc #0x80