assume cs:code,ds:data,ss:stack

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

	call cpy_new_int7CH
	call set_new_int7CH

	mov ah,1
	mov dx,1439
	int 7cH

	mov ax,4C00H
	int 21H
;===================================================================
new_int7CH:					
	push ax 
	push bx
	push cx
	push dx                                
	                                        
	push ax

	mov ax,dx                               
	mov dx,0
	mov bx,1440
	div bx		;32bit除法      		;ch= 磁道 
                                                        ;cl= 扇区 
	push ax		;保存面号                       ;dh= 面号
	                                                ;dl= 0软驱
	mov ax,dx
	mov dx,0
	mov bl,18	;16bit除法  ah=余数   al=商
	div bl			      ;扇区号 ;磁道号
	inc ah

	pop dx		
	mov cl,8	 
	shl dx,cl	 
	
	mov cl,ah
	mov ch,al		
			
	pop ax
	add ah,2
	int 13H

	pop dx
	pop cx
	pop bx
	pop ax

	iret
new_int7CH_end:	
	nop


set_new_int7CH:
	mov bx,0
	mov es,bx

	cli
	mov word ptr es:[7CH*4],7e00H
	mov word ptr es:[7CH*4+2],0
	sti
	ret

cpy_new_int7CH:	
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int7CH

	mov bx,0
	mov es,bx
	mov di,7e00H

	mov cx,OFFSET new_int7CH_end - OFFSET new_int7CH
	cld
	rep movsb

	ret

code ends

end start


