STACKS  SEGMENT  STACK
DW  128 DUP (0)
STACKS   ENDS

CODES   SEGMENT
	ASSUME  CS:CODES
START:  MOV  DX, 66H  ;��ʽ�����֣�A�����B����
	MOV  AL, 83H;PC0-PC3����
	OUT  DX, AL;PC4-PC7���

LOOP0:  MOV   AL, 00H;ָ��ͨ��0
	MOV   DX, 60H
	OUT   DX, AL
	MOV   AL, 80H ;����ת��
	OUT   DX, AL
	MOV   AL, 00H
	OUT   DX,AL
	MOV   DX,64H;PC�˿ڵ�ַ����������
LOP0:     IN    AL, DX
          TEST  AL, 01H        ;��EOC
          JZ    LOP0
          MOV   DX, 64H
          MOV   AL, 80H         ;дOE
          OUT   DX, AL
          MOV   DX, 62H
          IN    AL, DX          ;��ȡת�����
          CMP   AL, 066H        ;��2V�Ƚ�(С��2V������ˮ��)
          JB    L1
          CMP   AL, 099H        ;��3V�Ƚ�(����2VС��3V����Сˮ��)
          JB    L2
          JMP   L3               ;����3V����ˮ��

L1:     MOV   AL, 040H         ;������ˮ��(�����)
	MOV   DX, 060H
	OUT   DX, AL
	LOOP   $               ;��ʱ
	LOOP   $

LOOP1 :  MOV  AL, 0            ;�ɼ���ˮ���¶ȣ�������ת��
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
	MOV  DX, 62H        ;��ȡת�����
	IN   AL,DX
	CMP  AL, 0CCH       ;��4V��ȣ�����4V����Сˮ��
	JA   R1
	JMP  START          ;���أ��ٴβɼ�ˮѹ

L2:   	MOV  AL, 020H        ;����Сˮ��(�̵���)
	MOV  DX, 060H
	OUT  DX, AL
	LOOP  $
	LOOP  $

LOOP2:  MOV  AL, 0         ;�ɼ�Сˮ���¶ȣ�������ת��
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
	MOV   DX, 62H        ;��ȡת����� 
	IN    AL,  DX    
	CMP   AL, 0CCH       ;��4V��ȣ�����4V������ˮ��
	JA    R2    
	JMP    START         ;�����ٴβɼ�ˮѹ

L3:     MOV     AL, 010H     ;����ˮ��
	MOV     DX, 060H   
	OUT     DX,AL    
	LOOP    $
	LOOP    $
	JMP     START          ;�����ٴβɼ�ˮѹ

R1:     MOV     AL,010H         ;ʹLED��ʾ1�������ˮ�÷���
	MOV     DX, 64H     
	OUT     DX, AL     
  	MOV     AL, 020H      ;����Сˮ��
	MOV     DX, 060H     
	OUT     DX, AL     
	LOOP     $     
	LOOP     $    
LOOP3:  MOV     AL, 0             ;�ɼ�Сˮ���¶ȣ�������ת��
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
	IN      AL, DX      ;��ȡת�����
        CMP     AL, 0CCH     ;��4V��ȣ�����4V����ˮ��
	JA      R3     
	JMP     START     

R2:     MOV     AL, 020H        ;LED��ʾ2����Сˮ�÷���
	MOV     DX, 64H     
	OUT     DX, AL     
	MOV     AL, 040H        ;������ˮ��
	MOV     DX, 060H     
	OUT     DX, AL     
	LOOP     $
	LOOP     $

LOOP4:  MOV     AL, 0             ;�ɼ���ˮ���¶ȣ�������ת��
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
	IN      AL, DX     ;��ȡת�����
	CMP     AL, 0CCH     ;��4V��ȣ�����4V����ˮ��
	JA      R3     
	JMP     START     ;�����ٴβɼ�ˮѹ

R3:     MOV     AL, 070H      ;ʹLED��ʾ3���������ù��Ȳ�����
	MOV     DX, 64H     
	OUT     DX, AL     
	MOV     AL, 010H         ;����ˮ��
	MOV     DX, 060H     
	OUT     DX,AL     
	LOOP     $     
	LOOP     $     
	JMP     START     ;�����ٴβɼ�ˮѹ

CODES     ENDS     
	END     START 

