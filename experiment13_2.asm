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

	call cpy_new_int7cH
	call set_new_int7cH
	call init_reg
	call show_char
	mov ax,4c00H
	int 21H

show_char:
	mov di,160*12
	mov cx,80
	mov bx,OFFSET showChar - OFFSET showCharRet
showChar:
	mov byte ptr es:[di],'!'
	add di,2
	int 7cH
showCharRet:
	ret

init_reg:
	mov bx,0b800H
	mov es,bx
	ret


new_int7cH:
	push bp
	mov bp,sp
	dec cx
	jcxz int7cHRet
	add ss:[bp+2],bx
int7cHRet:
	pop bp
	iret

new_int7cH_end:nop


set_new_int7cH:
	mov bx,0
	mov es,bx
	cli
	mov word ptr es:[7cH*4],7e00H
	mov word ptr es:[7cH*4+2],0
	sti
	ret

cpy_new_int7cH:
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int7cH

	mov bx,0
	mov es,bx
	mov di,7e00H
	mov cx,OFFSET new_int7cH_end - OFFSET new_int7cH
	cld
	rep movsb
	ret

code ends

end start
