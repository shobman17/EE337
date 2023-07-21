// -- DO NOT CHANGE ANYTHING UNTIL THE **** LINE--// 11 2A 01 18
ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL TAKE_INP
CALL QUANT_ENC
HERE: CALL LED_DISP // infinite loop
SJMP HERE
ORG 130H
// *****************

DELAY: //9.98s delay
push 00h
push 01h
mov r0, #160
h6: mov r1, #250
h5: acall delay_250us
djnz r1, h5
djnz r0, h6
pop 01h
pop 00h
ret

TAKE_INP:

//PUSH to stack here
PUSH 00H

MOV P1, #1Fh // Initialize for input 1 HIGH
CALL DELAY
MOV A, P1
SWAP A // Get HIGH bits in MS bits
SUBB A, #01H
MOV R0, A
MOV P1, #2Fh // Initialize for input 1 LOW
CALL DELAY
MOV A, P1
SUBB A, #20H
ADD A, R0
MOV 60H, A // Input 1 is now stored

MOV P1, #3Fh // Initialize for input 1 HIGH
CALL DELAY
MOV A, P1
SWAP A // Get HIGH bits in MS bits
SUBB A, #03H
MOV R0, A
MOV P1, #4Fh // Initialize for input 1 LOW
CALL DELAY
MOV A, P1
SUBB A, #40H
ADD A, R0
MOV 61H, A // Input 1 is now stored

MOV P1, #5Fh // Initialize for input 1 HIGH
CALL DELAY
MOV A, P1
SWAP A // Get HIGH bits in MS bits
SUBB A, #05H
MOV R0, A
MOV P1, #6Fh // Initialize for input 1 LOW
CALL DELAY
MOV A, P1
SUBB A, #60H
ADD A, R0
MOV 62H, A // Input 1 is now stored

MOV P1, #7Fh // Initialize for input 1 HIGH
CALL DELAY
MOV A, P1
SWAP A // Get HIGH bits in MS bits
SUBB A, #07H
MOV R0, A
MOV P1, #8Fh // Initialize for input 1 LOW
CALL DELAY
MOV A, P1
SUBB A, #80H
ADD A, R0
MOV 63H, A // Input 1 is now stored

POP 00H
RET

QUANT_ENC:
// Quantize and encode values present in 60H-63H to 70H-73H

// Store to stack here
PUSH 00H
PUSH 01H
PUSH 03H

MOV R0, #5FH
MOV R1, #6FH
OUTERLOOP: // Iterates from 60H to 63H
CLR C
MOV R3, #03H // how many times subtraction can happen/ has happened
INC R0
INC R1
MOV A, @R0
INNERLOOP: // Determines quantization level by subtracting 10 each loop cycle
SUBB A, #0AH
JC SETVALUE
DJNZ R3, INNERLOOP
SETVALUE: // Set encoded output value
INC R3
MOV A, #80H // this value is choosen to directly map to LED ports without the hassle of rolling left a lot of times
ROLLA: RR A
DJNZ R3, ROLLA
RL A
MOV @R1, A
CJNE R1, #73H, OUTERLOOP

// POP from stack here
POP 03H
POP 01H
POP 00H
RET

LED_DISP:
// ADD YOUR CODE HERE
PUSH 00H
MOV R0, #6FH
OUTLOOP:
INC R0
MOV P1, @R0
CALL DELAY_5S
CJNE R0, #73H, OUTLOOP
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
h3: acall delay_250us
djnz r1, h3
djnz r0, h4
pop 01h
pop 00h
ret

END