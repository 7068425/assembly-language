STACKS  SEGMENT  STACK
DW  128 DUP (0)
STACKS   ENDS

CODES   SEGMENT
	ASSUME  CS:CODES
START:  MOV  DX, 66H  ;方式控制字，A输出，B输入
	MOV  AL, 83H;PC0-PC3输入
	OUT  DX, AL;PC4-PC7输出

LOOP0:  MOV   AL, 00H;指向通道0
	MOV   DX, 60H
	OUT   DX, AL
	MOV   AL, 80H ;启动转换
	OUT   DX, AL
	MOV   AL, 00H
	OUT   DX,AL
	MOV   DX,64H;PC端口地址，用于输入
LOP0:     IN    AL, DX
          TEST  AL, 01H        ;读EOC
          JZ    LOP0
          MOV   DX, 64H
          MOV   AL, 80H         ;写OE
          OUT   DX, AL
          MOV   DX, 62H
          IN    AL, DX          ;读取转换结果
          CMP   AL, 066H        ;与2V比较(小于2V启动大水泵)
          JB    L1
          CMP   AL, 099H        ;与3V比较(大于2V小于3V启动小水泵)
          JB    L2
          JMP   L3               ;大于3V启动水网

L1:     MOV   AL, 040H         ;启动大水泵(红灯亮)
	MOV   DX, 060H
	OUT   DX, AL
	LOOP   $               ;延时
	LOOP   $

LOOP1 :  MOV  AL, 0            ;采集大水泵温度，并启动转换
	MOV  AL, 01H
	MOV  DX, 60H
	OUT  DX, AL
	MOV  AL, 81H
	OUT  DX, AL
	MOV  AL, 01H
	OUT  DX,AL
	MOV  DX,64H

LOP1 :  IN  AL, DX
	TEST AL, 01H
	JZ   LOP1
	MOV  DX, 64H
	MOV  AL, 80H
	OUT  DX, AL
	MOV  DX, 62H        ;读取转换结果
	IN   AL,DX
	CMP  AL, 0CCH       ;与4V相比，大于4V启动小水泵
	JA   R1
	JMP  START          ;返回，再次采集水压

L2:   	MOV  AL, 020H        ;启动小水泵(绿灯亮)
	MOV  DX, 060H
	OUT  DX, AL
	LOOP  $
	LOOP  $

LOOP2:  MOV  AL, 0         ;采集小水泵温度，并启动转换
	MOV  AL, 02H
	MOV  DX, 60H
	OUT  DX, AL
	MOV  AL, 82H
	OUT  DX, AL
	MOV  AL, 02H
	OUT  DX, AL
	MOV  DX,64H
LOP2:   IN    AL, DX  
	TEST  AL, 01H    
	JZ    LOP2    
	MOV   DX, 64H    
	MOV   AL, 80H    
	OUT   DX, AL    
	MOV   DX, 62H        ;读取转换结果 
	IN    AL,  DX    
	CMP   AL, 0CCH       ;与4V相比，大于4V启动大水泵
	JA    R2    
	JMP    START         ;返回再次采集水压

L3:     MOV     AL, 010H     ;启动水网
	MOV     DX, 060H   
	OUT     DX,AL    
	LOOP    $
	LOOP    $
	JMP     START          ;返回再次采集水压

R1:     MOV     AL,010H         ;使LED显示1，代表大水泵发热
	MOV     DX, 64H     
	OUT     DX, AL     
  	MOV     AL, 020H      ;启动小水泵
	MOV     DX, 060H     
	OUT     DX, AL     
	LOOP     $     
	LOOP     $    
LOOP3:  MOV     AL, 0             ;采集小水泵温度，并启动转换
	MOV     AL, 02H     
	MOV     DX, 60H     
	OUT     DX,AL     
	MOV     AL, 82H    
	OUT     DX, AL     
	MOV     AL, 02H    
	OUT     DX, AL 
      	MOV     DX, 64H    

LOP3:   IN      AL,DX     
	TEST    AL, 01H          
	JZ      LOP3     
	MOV     DX, 64H     
	MOV     AL, 80H     
	OUT     DX, AL     
	MOV     DX, 62H     
	IN      AL, DX      ;读取转换结果
        CMP     AL, 0CCH     ;与4V相比，大于4V启动水网
	JA      R3     
	JMP     START     

R2:     MOV     AL, 020H        ;LED显示2代表小水泵发热
	MOV     DX, 64H     
	OUT     DX, AL     
	MOV     AL, 040H        ;启动大水泵
	MOV     DX, 060H     
	OUT     DX, AL     
	LOOP     $
	LOOP     $

LOOP4:  MOV     AL, 0             ;采集大水泵温度，并启动转换
	MOV     AL, 01H 
	MOV     DX, 60H     
	OUT     DX, AL     
	MOV     AL, 81H     
	OUT     DX, AL     
	MOV     AL, 01H     
	OUT     DX, AL     
	MOV     DX, 64H     
 
LOP4:   IN      AL, DX     
	TEST    AL, 01H     
	JZ      LOP4     
	MOV     DX, 64H     
	MOV     AL, 80H     
	OUT     DX, AL     
	MOV     DX, 62H     
	IN      AL, DX     ;读取转换结果
	CMP     AL, 0CCH     ;与4V相比，大于4V启动水网
	JA      R3     
	JMP     START     ;返回再次采集水压

R3:     MOV     AL, 070H      ;使LED显示3，代表两泵过热并报警
	MOV     DX, 64H     
	OUT     DX, AL     
	MOV     AL, 010H         ;启动水网
	MOV     DX, 060H     
	OUT     DX,AL     
	LOOP     $     
	LOOP     $     
	JMP     START     ;返回再次采集水压

CODES     ENDS     
	END     START 

