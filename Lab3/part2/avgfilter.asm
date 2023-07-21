ORG 0H 
LJMP MAIN 
ORG 100H 
MAIN: CALL FILT 
HERE: SJMP HERE 
ORG 130H 
// ***************** 
FILT: 
MOV R0, #5FH // input start index -1
MOV R1, #6FH // output start index - 1
OUTERLOOP:
INC R0
INC R1
MOV A, #00H
MOV B, #04H
MOV R2, #04H // number of elements to go backwards
INNERLOOP:
ADD A, @R0
DEC R0
DJNZ R2, INNERLOOP
SETVALUE: // R0 is now index - 3, A has sum of four elements
DIV AB
MOV @R1, A
MOV A, R0 // restore R0 to its former glory
ADD A, #04H
MOV R0, A
CJNE R1, #77H, OUTERLOOP
RET 
END