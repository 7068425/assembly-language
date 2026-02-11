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

	mov bx,offset Boot_end - offset Boot

	call cpy_introduce_toDiskA
	call cpy_boot_toDiskA

	mov ax,4C00H
	int 21H

;========================================================
introduce:
	mov bx,0
	mov ss,bx
	mov sp,7c00H

	call sav_old_int9
	call cpy_boot_FromDiskA

	mov bx,0
	push bx
	mov bx,7e00H
	push bx
	retf	

cpy_boot_FromDiskA:
	mov bx,0
	mov es,bx
	mov bx,7e00H

	mov al,2
	mov ch,0
	mov cl,2 
	mov dl,0
	mov dh,0
	mov ah,2
	int 13H	

	ret

sav_old_int9:
	mov bx,0
	mov es,bx
	
	push es:[9*4]
	pop es:[200H]
	push es:[9*4+2]
	pop es:[202H]		

	ret

	db 512 dup (0)

introduce_end: nop

cpy_introduce_toDiskA:
	mov bx,cs
	mov es,bx
	mov bx,offset introduce

	mov al,1
	mov ch,0
	mov cl,1  
	mov dl,0
	mov dh,0
	mov ah,3
	int 13H

	ret

cpy_boot_toDiskA:
	mov bx,cs
	mov es,bx
	mov bx,offset boot

	mov al,2
	mov ch,0
	mov cl,2  ;2ºÅÉÈÇø
	mov dl,0
	mov dh,0
	mov ah,3
	int 13H

	ret
;========================================================
Boot:	jmp BOOT_START
;-===========================================================================
OPTION_1 db	'1) reset pc',0
OPTION_2 db	'2) start system',0
OPTION_3 db	'3) show clock',0
OPTION_4 db	'4) set clock',0

OPTION_ADDRESS dw OFFSET OPTION_1 - OFFSET Boot + 7E00H
	       dw OFFSET OPTION_2 - OFFSET Boot + 7E00H
	       dw OFFSET OPTION_3 - OFFSET Boot + 7E00H
	       dw OFFSET OPTION_4 - OFFSET Boot + 7E00H

TIME_STYLE	db 'YY/MM/DD HH/MM/SS',0
CMOS_ADDRESS 	db 9,8,7,4,2,0

STRING_STACK	db 12 dup ('0') ,0,0,0
;================================================================
BOOT_START:
	call init_reg
	call clear_screen
	call show_option		
	jmp choose_option
;=======================================================
choose_option:
	call clear_buff
	mov ah,0
	int 16H
	cmp al,'1'
	je isChooseOne
	cmp al,'2'
	je isChooseTwo
	cmp al,'3'
	je isChooseThree
	cmp al,'4'
	je isChooseFour

	jmp choose_option

isChooseOne:
	mov di,160*4
	mov byte ptr es:[di],'1'
	mov bx,0ffffH
	push bx
	mov bx,0
	push bx
	retf
	jmp choose_option

isChooseTwo:
	mov di,160*4
	mov byte ptr es:[di],'2'
	call start_system
	jmp choose_option

isChooseThree:	
	mov di,160*4
	mov byte ptr es:[di],'3'
	call show_clock
	jmp BOOT_START

isChooseFour:
	mov di,160*4
	mov byte ptr es:[di],'4'
	call set_clock
	jmp choose_option
;=======================================================
start_system:
	mov bx,0
	mov es,bx
	mov bx,7c00H

	mov al,1
	mov ch,0
	mov cl,1 
	mov dl,80H
	mov dh,0
	mov ah,2
	int 13H	
	
	mov bx,0
	push bx
	mov bx,7c00H
	push bx
	retf

	ret

set_clock:
	call clear_string_stack
	call show_string_stack
	call get_string

	call set_cmos_time

	ret
;=======================================================
set_cmos_time:
	mov si,OFFSET STRING_STACK - OFFSET Boot + 7E00H  ;STRING
	mov di,160*10
	mov bx,OFFSET CMOS_ADDRESS - OFFSET Boot + 7E00H ;CMOS
	mov cx,6
setCmosTime:
	mov dx,ds:[si]	; ds:[si]='12'   
	sub dh,30H	;dh = '2'	dl = '1'   DX = '21'
	sub dl,30H
	shl dl,1
	shl dl,1
	shl dl,1
	shl dl,1
	and dh,00001111B
	or dl,dh
	
	mov al,ds:[bx]
	out 70H,al
	mov al,dl
	out 71H,al

	add si,2
	inc bx
	loop setCmosTime

	ret
;=======================================================
get_string:
	mov si,OFFSET STRING_STACK - OFFSET Boot + 7E00H
	mov bx,0

	call clear_buff

getString:
	mov ah,0
	int 16H
	cmp al,'0'
	jb notNumber
	cmp al,'9'
	ja notNumber
	call char_push
	call show_string_stack
	jmp getString
isEnter: ret

notNumber:
	cmp ah,1CH
	je isEnter
	cmp ah,0EH
	je isBackSpace
	jmp getString
;=======================================================
isBackSpace:
	call char_pop
	call show_string_stack
	jmp getString
;=======================================================
char_pop:
	cmp bx,0
	je charPopRet
	dec bx
	mov byte ptr ds:[si+bx],'0'
charPopRet: ret
;=======================================================
char_push:
	cmp bx,11
	ja charPushRet
	mov ds:[si+bx],al
	inc bx
charPushRet:
	ret
;=======================================================
clear_string_stack:
	push cx
	push dx
	push ds
	push si
	mov si,OFFSET STRING_STACK - OFFSET Boot + 7E00H
	mov cx,6
	mov dx,3030H
clearStringStack:
	mov ds:[si],dx
	add si,2
	loop clearStringStack
	pop si
	pop ds
	pop dx
	pop cx
	ret
;=======================================================
show_string_stack:
	push si
	push di
	
	mov si,OFFSET STRING_STACK - OFFSET Boot + 7E00H
	mov di,160*5

	call show_string

	pop di
	pop si
	ret
;=======================================================
show_clock:
	call show_style
	mov bx,OFFSET CMOS_ADDRESS - OFFSET Boot + 7E00H
	call set_new_int9
showDate:
	mov si,bx
	mov di,160*20
	mov cx,6
showTime:
	mov al,ds:[si]
	out 70H,al
	in al,71H
	mov ah,al			;AL = 1111 1111
	shr ah,1
	shr ah,1
	shr ah,1
	shr ah,1
	and al,00001111B
	add ah,30H
	add al,30H
	mov es:[di],ah
	mov es:[di+2],al
	add di,6
	inc si
	loop showTime
	jmp showDate
showDateOver:
	call set_old_int9
	ret
;=======================================================
set_old_int9:
	push bx
	push es
	
	mov bx,0
	mov es,bx

	cli
	push es:[200H]
	pop es:[9*4]
	push es:[202H]
	pop es:[9*4+2]
	sti

	pop es
	pop bx
	ret
;=======================================================
set_new_int9:
	push bx
	push es

	mov bx,0
	mov es,bx
	cli
	mov word ptr es:[9*4],OFFSET new_int9 - OFFSET Boot + 7E00H
	mov word ptr es:[9*4+2],0
	sti
	pop es
	pop bx
	ret
;=======================================================
new_int9:
	push ax
	call clear_buff

	in al,60H
	pushf 
	call dword ptr cs:[200H]

	cmp al,01H
	je isEsc
	cmp al,3BH
	jne int9Ret
	call change_screen_color
int9Ret:
	pop ax
	iret
isEsc:	pop ax
	add sp,4
	popf
	jmp showDateOver
;=======================================================
change_screen_color:
	push bx
	push cx
	push es
	
	mov bx,0B800H
	mov es,bx

	mov cx,17
	mov bx,160*20 + 1
changeScreenColor:
	inc byte ptr es:[bx]
	add bx,2
	loop changeScreenColor

	pop es
	pop cx
	pop bx
	ret
;=======================================================
show_style:
	mov si,OFFSET TIME_STYLE - OFFSET Boot + 7E00H
	mov di,160*20
	call show_string
	ret
;=======================================================
clear_buff:
	mov ah,1
	int 16H
	jz clearBuffRet
	mov ah,0
	int 16H
	jmp clear_buff
clearBuffRet:
	ret
;=======================================================
show_option:
	mov bx,OFFSET OPTION_ADDRESS - OFFSET Boot + 7E00H
	mov di,160*10 + 30*2
	mov cx,4
showOption:
	mov si,ds:[bx]
	call show_string
	add bx,2
	add di,160
	loop showOption
	ret
;=======================================================
show_string:
	push dx
	push si
	push di
	push ds
	push es
showString:
	mov dl,ds:[si]
	cmp dl,0
	je showStringRet
	mov es:[di],dl
	add di,2
	inc si
	jmp showString

showStringRet:
	pop es
	pop ds
	pop di
	pop si
	pop dx
	ret
;=======================================================
clear_screen:
	mov bx,0
	mov dx,0700H
	mov cx,2000
clearScreen:	
	mov es:[bx],dx
	add bx,2
	loop clearScreen
	ret
;=======================================================
init_reg:
	mov bx,0B800H
	mov es,bx
	mov bx,0
	mov ds,bx
	ret
	db 512 dup (0)
Boot_end:
	nop

code ends

end start


