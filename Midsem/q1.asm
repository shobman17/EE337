ORG 0H
LJMP MAIN
ORG 100H

MAIN:
CALL FINDKEY
HERE: CALL DISPLAY
SJMP HERE // infinite loop
ORG 130H
	
delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret

delay_5S: //Actually 4.993s delay
push 00h
push 01h
mov r0, #80
h4: mov r1, #250
h3: lcall delay_250us
djnz r1, h3
djnz r0, h4
pop 01h
pop 00h
ret

delay_1S: //Actually 4.993s delay
push 00h
push 01h
mov r0, #80
h6: mov r1, #50
h5: lcall delay_250us
djnz r1, h5
djnz r0, h6
pop 01h
pop 00h
ret
	
FINDKEY:
PUSH 00H
MOV 70H, #216
MOV 71H, #173
MOV R0, #0 // counter for i
LOOPFIND:
INC R0
MOV A, 70H
MOV B, R0 // i
MUL AB // least sig in A, most sig in B
ADD A, #1 // (x*i)+1
MOV R2, A
MOV A, B
ADDC A, #0
MOV R3, A
// At this point we have (x*i) + 1 with most sig in 81H and least sig in 80H
// Now we calculate this result modulus e
MOV 82H, #0
CALL MODULUSE
CJNE R7, #0AAH, LOOPFIND
POP 00H
RET

MODULUSE:
PUSH 00H
PUSH 01H
CLR 85H
MOV R0, 71H
MOV R1, #0 // number of times subtraction has been done
//MOV R2, r5
//MOV R3, r6
MODULOLOOP:
MOV A, R2
SUBB A, R0
MOV R2, A
JNC CHECK
MOV A, R3
SUBB A, #00H
JC EXIT // if overflow, number is not divisible
MOV R3, A
CHECK: INC R1
CJNE R2, #0, MODULOLOOP
CJNE R3, #0, MODULOLOOP
MOV 72H, R1
MOV r7, #0AAH
EXIT:
POP 01H
POP 00H
RET


DISPLAY:
MOV A, 72H
MOV P1, A
CALL delay_5S
MOV P1, #00H
CALL delay_1S
SWAP A
MOV P1, A
CALL delay_5S
MOV P1, #00H
CALL delay_1S
RET

END
