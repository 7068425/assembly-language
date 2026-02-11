assume cs:code,ss:stack,ds:data

data segment
	db 128 dup (0)
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment


start:	mov ax,stack
	mov ss,ax
	mov sp,128

	call cpy_new_int9
	call sav_old_int9
	call set_new_int9

;testA:
;	mov ax,1000H
;	jmp testA

	mov ax,4c00H
	int 21H

new_int9:
	push ax
	in al,60H
	pushf
	call dword ptr cs:[200H]
	cmp al,9eH
	jne int9Ret
	call set_screen_letter

int9Ret:
	pop ax
	iret

set_screen_letter:
	push bx
	push cx
	push dx
	push es

	mov bx,0b800H
	mov es,bx
	mov bx,0
	mov dl,'A'
	mov cx,2000
setScreetLetter:
	mov es:[bx],dl
	add bx,2
	loop setScreetLetter

	pop es
	pop dx
	pop cx
	pop bx
	ret

new_int9_end: nop

set_new_int9:
	mov bx,0
	mov es,bx

	cli
	mov word ptr es:[9*4],7e00H
	mov word ptr es:[9*4+2],0
	sti
	ret

sav_old_int9:
	mov bx,0
	mov es,bx

	cli
	push es:[9*4]
	pop es:[200H]
	push es:[9*4+2]
	pop es:[202H]
	sti
	ret

cpy_new_int9:
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int9

	mov bx,0
	mov es,bx
	mov di,7e00H
	mov cx,OFFSET new_int9_end - OFFSET new_int9
	cld
	rep movsb
	ret

code ends

end start
