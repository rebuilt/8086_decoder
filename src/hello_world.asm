; hello.asm - 16-bit DOS program
org 0x100              ; .COM file offset
mov ah, 0x09
mov dx, msg
int 0x21
mov ax, 0x4C00
int 0x21

msg db 'Hello, world!$'
