assume cs:code,ss:stack,ds:data

data segment
	db 128 dup (0)
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment

TIME_STYLE  db 'YY/MM/DD HH:MM:SS',0
TIME_CMOS   db 9,8,7,4,2,0
start:	mov ax,stack
	mov ss,ax
	mov sp,128

	call clear_screen
	call init_reg
	call show_clock
	mov ax,4c00H
	int 21H

show_clock:
	call show_time_style
	
showTime:
	mov si,OFFSET TIME_CMOS
	mov di,160*10+30*2
	mov cx,6

showData:
	mov al,ds:[si]
	out 70H,al
	in al,71H
	mov ah,al
	shr ah,1
	shr ah,1
	shr ah,1
	shr ah,1
	and al,00001111B
	add ah,30H
	add al,30H
	mov es:[di],ah
	mov es:[di+2],al
	inc si
	add di,6
	loop showData

	jmp showTime    ;动态显示实时时间
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

show_time_style:
	mov si,OFFSET TIME_STYLE
	mov di,160*10+30*2

	call show_string
	ret

init_reg:
	mov bx,cs
	mov ds,bx
	mov bx,0b800H
	mov es,bx
	ret

clear_screen:
	mov bx,0B800H
	mov es,bx

	mov bx,0
	mov dx,0700H
	mov cx,2000

clearScreen:
	mov es:[bx],dx
	add bx,2
	loop clearScreen

	ret

code ends

end start
