ORG 0H
LJMP MAIN
ORG 100H
MOV P1, #1FH //take input
CALL delay_50us //input delays
MAIN:
CALL PLAYSONG
SJMP MAIN // infinite loop
ORG 130H

delay_50us:
push 00h
mov r0, #43
h1: djnz r0, h1
pop 00h
ret

delay_custom: //general delay for notes. Period is stored in R7
push 00h
mov A, r2
mov r0, A
h8: acall delay_50us
djnz r0, h8
pop 00h
ret

PLAYSONG:
PUSH 00H

MOV R0, #255
JB P1.3, SETMA
JB P1.2, SETGA
JB P1.1, SETRE
JB P1.0, SETSA
SJMP PLAYSONG
SETSA: MOV R2, #39
SJMP PLAY
SETRE: MOV R2, #34
SJMP PLAY
SETGA: MOV R2, #31
SJMP PLAY
SETMA: MOV R2, #29
PLAY: 
SETB P0.7
CALL delay_custom
CPL P0.7
CALL delay_custom
DJNZ R0, PLAY
POP 00H
RET

END