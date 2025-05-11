assume cs:code,ss:stack,ds:data

data segment
db 'Welcome to masm!',0
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
	call show_masm

	mov ax,4c00H
	int 21H



init_reg:
	mov bx,data
	mov ds,bx
	mov bx,0b800H
	mov es,bx
	ret

show_masm:
	mov si,0
	mov di,0
	mov dh,10
	mov dl,10
	mov cl,2

	int 7cH
	ret


new_int7cH:
	call get_row
	call get_col
	call show_string
	iret

show_string:
	push dx
	push ds
	push es
	push si
	push di
	mov dh,cl
showString:
	mov dl,ds:[si]
	cmp dl,0
	je showStringRet
	mov es:[di],dx
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

get_col:
	mov al,2
	mul dl
	add di,ax
	ret
	
get_row:
	mov al,160
	mul dh
	mov di,ax
	ret

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
