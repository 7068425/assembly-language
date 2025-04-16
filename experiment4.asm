assume cs:code

code segment
	
	mov ax,20H
	mov es,ax
	mov bx,0
	mov cx,64
	mov dl,0
s:	mov es:[bx],dl
	inc bx
	inc dl
	loop s

	
	mov ax,4c00H
	int 21H

code ends

end



assume cs:code

code segment
	
	mov ax,0
	mov ds,ax
	mov bx,200H  ;不能在物理地址为00000H开始的空间写入数据
	mov cx,64
	mov dl,0
s:	mov [bx],dl
	inc bx
	inc dl
	loop s

	
	mov ax,4c00H
	int 21H

code ends

end


assume cs:code

code segment
	
	mov ax,cs
	mov ds,ax
	mov ax,0020H
	mov es,ax
	mov bx,0
	mov cx,23
s:	mov al,[bx]
	mov es:[bx],al
	inc bx
	loop s

	
	mov ax,4c00H
	int 21H

code ends

end


