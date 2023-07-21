ORG 0H
LJMP MAIN
ORG 100H
MAIN: 
CALL QUANT 
HERE: SJMP HERE 
ORG 130H
// ***************** 
QUANT: 
MOV R0, #5FH
MOV R1, #6FH
OUTERLOOP: // Iterates from 60H to 67H
CLR C
MOV R2, #05H // stores quantization value
MOV R3, #03H // how many times subtraction can happen
INC R0
INC R1
INNERLOOP: // Determines quantization level by subtracting 10 each loop cycle
MOV A, @R0
SUBB A, #0AH
MOV @R0, A
JC SETVALUE
MOV A, R2
ADD A, #0AH
MOV R2, A
DJNZ R3, INNERLOOP
SETVALUE: // Set output value
MOV A, R2
MOV @R1, A
CJNE R1, #77H, OUTERLOOP
RET 
END