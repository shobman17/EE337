ORG 0H
LJMP MAIN
ORG 100H

MAIN:
CALL CRYPT
HERE: CALL DISPLAY
SJMP HERE
ORG 130H
	
CRYPT:
MOV 70H, #247
MOV P1, #0FFH
CALL delay_1S
MOV P1, #0FH
CALL delay_5S
MOV A, P1
MOV 71H, A
MOV 72H, #5
MOV 73H, #0
MOV 74H, A
MOV R0, 72H
MOV 75H, A
DEC R0

//Now we calculate c^d
EXPLOOP:
CALL MULT
DJNZ R0, EXPLOOP

//Now we have c^d. We will calculate modulus now
CALL MODULUS
// m is stored in 73H now
RET

MULT:
PUSH 00H
PUSH 01H
PUSH 02H
PUSH 03H
PUSH 04H

MOV R0, 73H // most sig
MOV R1, 74H // least sig
MOV R2, #0 // cumulative least sig
MOV R3, #0 // cumulative most sig
MOV R4, 75H
MULTLOOP:
MOV A, R2
ADD A, R4
MOV R2, A
MOV A, R3
ADDC A, #0
MOV R3, A
DEC R1
CJNE R1, #0, MULTLOOP
CJNE R0, #0, DECR0
MOV 73H, R3
MOV 74H, R2

POP 04H
POP 03H
POP 02H
POP 01H
POP 00H
RET

DECR0: DEC R0
LJMP MULTLOOP

MODULUS:
PUSH 00H
PUSH 01H
PUSH 02H
PUSH 03H
CLR 85H
MOV R0, 70H // modulus
MOV R1, #0 // number of times subtraction has been done
MOV R2, 74H // least sig
MOV R3, 73H // most sig
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
MOV 73H, R2 // we need to store modulus baba
CJNE R2, #0, MODULOLOOP
CJNE R3, #0, MODULOLOOP
MOV r7, #0AAH
EXIT:
POP 03H
POP 02H
POP 01H
POP 00H
RET

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

DISPLAY:
MOV A, 73H
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