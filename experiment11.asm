assume cs:code,ds:data,ss:stack

data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:	mov ax,stack
	mov ss,ax
	mov sp,128

	call clear_screen
	call init_reg
	call init_data
	call show_string
	call up_letter
	mov di,160*11+20*2
	call show_string

	mov ax,4c00H
	int 21H

up_letter:
	push dx
	push ds
	push es
	push si
	mov si,0
upLetter:
	mov dl,ds:[si]
	cmp dl,0
	je upLetterRet
	cmp dl,'a'
	jb nextLetter
	cmp dl,'z'
	ja nextLetter
	and byte ptr ds:[si],11011111B
nextLetter:
	inc si
	jmp upLetter
upLetterRet:
	pop si
	pop es
	pop ds
	pop dx
	ret




init_data:mov si,0
	mov di,160*10+20*2
	ret

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



init_reg:
	mov bx,data
	mov ds,bx
	mov bx,0b800H
	mov es,bx
	ret

clear_screen:mov bx,0b800H
		mov es,bx
		mov bx,0
		mov dx,0700H
		mov cx,2000
clearScreen:mov es:[bx],dx
		add bx,2
		loop clearScreen
		ret


code ends

end start
