assume cs:code,ss:stack

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:	mov ax,stack
	mov ss,ax
	mov sp,128

	call cyp_new_int0
	call set_new_int0
	
	mov ax,0
	mov dx,1
	mov bx,1
	div bx
	
	mov ax,4c00H
	int 21H


set_new_int0:
	mov bx,0
	mov es,bx
	
	mov word ptr es:[0*4],7e00H
	mov word ptr es:[0*4+2],0
	ret


new_int0: jmp newInt0

string:	db  'divide error',0

newInt0:mov bx,0b800H
	mov es,bx
	mov di,160*10+30*2
	mov bx,0
	mov ds,bx
	mov si,OFFSET string - OFFSET new_int0 + 7e00H    ;7e03H
	call show_string
	mov ax,4c00H
	int 21H

show_string:
	push dx
	push ds
	push es
	push si
	push di

showString:
	mov dl,ds:[si]
	cmp dl,0
	je showStringRet
	mov es:[di],dl
	add di,2
	inc si
	jmp showString

showStringRet:
	pop di
	pop si
	pop es
	pop ds
	pop dx
	ret

new_int0_end: nop

cyp_new_int0:
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int0
	mov bx,0
	mov es,bx
	mov di,7e00H
	mov cx,OFFSET new_int0_end - OFFSET new_int0
	cld
	rep movsb

	ret	

code ends

end start
