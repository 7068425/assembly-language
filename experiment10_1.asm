assume cs:code,ds:data,ss:stack

data segment
	db 'Welcome to masm!',0
data ends

stack segment 
	db 128 dup (0)
stack ends

code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,128
	
        call init_reg

	mov di,0

	mov dh,8
	call get_row
	add di,ax

	mov dl,3
	call get_col
	add di,ax

	mov cl,2
	mov dl,cl

	mov si,0
	call show_string

	mov ax,4c00H
	int 21H

;==============================================
show_string:	push cx
		push dx
		push ds
		push es
		push si
		push di

		mov cx,0
	

showString:	mov cl,ds:[si]
		jcxz showStringRet
		mov es:[di],cl
		mov es:[di+1],dl
		add di,2
		inc si
		jmp showString


showStringRet:	pop di
		pop si
		pop es
		pop ds
		pop dx
		pop cx
		ret

;==============================================
get_col:mov al,2
	mul dl
	ret
;==============================================
get_row:mov al,160
	mul dh
	ret
;==============================================
init_reg:	mov bx,0b800H
		mov es,bx

		mov bx,data
		mov ds,bx
		ret
code ends

end start


