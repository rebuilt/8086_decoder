
bits 16

mov al, 8
mov al, 127
mov al, 128
mov cl, 12
mov ch, -13
;
;;; 16-bit immediate-to-register
mov cx, 12
mov cx, -12
mov dx, 3948
mov dx, -3948
;
;; Source address calculation
mov al, [bx + si]
mov bx, [bp + di]
mov dx, [bp]
mov bx, [33]
;
;; Source address calculation plus 8-bit displacement
mov ah, [bx + si + 4]

;; Source address calculation plus 16-bit displacement
mov ax, [bx + si + 4999]
;
;; Dest address calculation
mov [bx + di], cx
mov [bp + si], cl
mov [bp], ch
