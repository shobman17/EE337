//-- DO NOT CHANGE ANYTHING UNTIL THE **** LINE--// 
ORG 0H 
LJMP MAIN 
ORG 100H 
MAIN: 
CALL SORT 
	HERE: SJMP HERE 
ORG 130H 
// ***************** 

SORT: // ADD YOUR CODE HERE 
MOV R2, #68H //end of array + 1

OUTERLOOP:
CLR C
MOV R0, #5FH // beginning of array - 1
MOV R1, #60H
DEC R2
MOV A, R2
//check if all iterations have been made
SUBB A, R1
JZ ENDLOOP

INNERLOOP:
//start comparing
CLR C
INC R0
INC R1
MOV A, R0
SUBB A, R2
JZ OUTERLOOP //if end has been reached then we move to the next iteration
// Right now, R0 has i, and R1 has i+1
MOV A, @R1
SUBB A, @R0
JNC INNERLOOP //if carry is not set, go on to next iteration
// perform exchange here
MOV A, @R0 // A has value in address at R0
XCH A, @R1 // exchange value in address at R1 with A, which has value in address at R0
XCH A, @R0 // exchange value in address at R0 with A. Exchange complete
SJMP INNERLOOP

ENDLOOP: //store all sorted values
MOV 70H, 60H
MOV 71H, 61H
MOV 72H, 62H
MOV 73H, 63H
MOV 74H, 64H
MOV 75H, 65H
MOV 76H, 66H
MOV 77H, 67H

RET 

END