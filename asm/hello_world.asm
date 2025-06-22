; hello.asm - 16-bit DOS program
;org 0x100              ; .COM file offset
;mov ah, 0x09
;mov dx, msg
;int 0x21
;mov ax, 0x4C00
;int 0x21
;
;msg db 'Hello, world!$'

section .data
    hello_msg db 'Hello, World!', 0xA  ; message + newline
    hello_len equ $ - hello_msg        ; length of the message

section .text
    global _start

_start:
    ; write(stdout, hello_msg, hello_len)
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, hello_msg  ; pointer to message
    mov edx, hello_len  ; message length
    int 0x80            ; make syscall

    ; exit(0)
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; make syscall
