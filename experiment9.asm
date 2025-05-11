assume cs:code,ds:data,ss:stack

data segment
	db 'welcome to masm!'
	;   0123456789abcdef
	db 00000010b
	db 00100100b
	db 01110001b
       ;    rgb rgb
data ends

stack segment
	db 128 dup (0)
stack ends

code segment
start:	mov ax,stack
	mov ss,ax
	mov sp,128

	mov ax,data
	mov ds,ax
	
	mov ax,0b800H
	mov es,ax
	
	mov si,0
	mov di,160*10+30*2
	mov bx,16
	mov dx,0

	mov cx,3
	
showMasm:push cx
	push si
	push di

	mov cx,16
	mov dh,ds:[bx]

showRow:mov dl,ds:[si]
	mov es:[di],dx
	add di,2
	inc si
	loop showRow

	pop di
	pop si
	pop cx
	add di,160
	inc bx
	loop showMasm

	mov ax,4C00H
	int 21H

code ends

end start

