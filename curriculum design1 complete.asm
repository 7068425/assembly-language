assume cs:code,ds:data,ss:stack

data segment
	db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db	'1993','1994','1995'
	;以上是表示21年的21个字符串 year
	dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	;以上是表示21年公司总收入的21个dword数据	sum
	dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw	11542,14430,15257,17800
data ends

stack segment stack
	db 128 dup (0)
stack ends

string segment
	db 10 dup ('0'),0,0,0
string ends


code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,128

	call clear_screen
	call init_reg
	call output_table


	mov ax,4C00H
	int 21H
;=========================================================
output_table:
	mov cx,21
	mov si,0	
	mov di,160*3
	mov bx,21*4*2	
		
outputTable:	
	call show_year	
	call show_sum
	call show_employee
	call show_average
	add di,160
	add si,4
	add bx,2
	loop outputTable
	ret

show_average:
	push ax
	push bx
	push cx
	push dx
	push ds
	push si
	push di
	push bp

	mov ax,ds:[si+21*4]
	mov dx,ds:[si+21*4+2]

	push ax
	mov bp,sp
	mov cx,ds:[bx]
	call long_div
	add sp,2

	mov si,9
	add di,40*2

	call show_number

	pop bp
	pop di
	pop si
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax

	ret

show_employee:
	push ax
	push dx
	push ds
	push si
	push di

	mov ax,ds:[bx]
	mov dx,0
	
	mov si,9
	add di,25*2

	call show_number

	pop di
	pop si
	pop ds
	pop dx
	pop ax

	ret

show_sum:
	push ax
	push dx
	push ds
	push si
	push di
	mov ax,ds:[si+21*4]
	mov dx,ds:[si+21*4+2]
	mov si,9
	add di,10*2

	call show_number
	
	pop di
	pop si
	pop ds
	pop dx
	pop ax
	ret

show_number:
	push ax
	push bx
	push cx
	push dx
	push ds
	push es
	push si
	push di
	push bp
	
	call isShortDiv
	call init_reg_show_string
	call show_string
	
	pop bp
	pop di
	pop si
	pop es
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax

	ret

show_string:
	push cx
	push ds
	push es
	push si
	push di
showString:
	mov cx,0
	mov cl,ds:[si]
	jcxz showStringRet
	mov es:[di],cl
	add di,2
	inc si
	jmp showString		
showStringRet:
	pop di
	pop si
	pop es
	pop ds
	pop cx
	ret

init_reg_show_string:
	push bx
	mov bx,0b800H
	mov es,bx

	mov bx,string
	mov ds,bx

	pop bx
	ret

isShortDiv:
	mov cx,dx
	jcxz shortDiv
	push ax
	mov bp,sp
	mov cx,10
	call long_div
	add sp,2
	add cx,30H
	mov es:[si],cl
	dec si
	jmp isShortDiv

shortDivRet:
	ret

long_div:
	mov ax,dx
	mov dx,0
	div cx
	push ax
	mov ax,ss:[bp+0]
	div cx
	mov cx,dx
	pop dx

	ret

shortDiv:
	mov cx,10
	div cx
	add dx,30H
	mov es:[si],dl
	mov cx,ax
	jcxz shortDivRet
	dec si
	mov dx,0
	jmp shortDiv

show_year:
	push bx
	push cx
	push ds
	push es
	push si
	push di

	mov bx,0B800H
	mov es,bx	
	mov cx,4
	add di,3*2	
showYear:
	mov dl,ds:[si]
	mov es:[di],dl
	inc si
	add di,2
	loop showYear

	pop di
	pop si
	pop es
	pop ds
	pop cx
	pop bx

	ret
init_reg:
	mov bx,data
	mov ds,bx
	
	mov bx,string
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



