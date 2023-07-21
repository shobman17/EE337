// -- DO NOT CHANGE ANYTHING UNTIL THE **** LINE--//
ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL DET
HERE: SJMP HERE
ORG 130H
// *****************

DET:
MOV A, 61H
MOV B, 62H
MUL AB
MOV R1, A // least significant
MOV R2, B // most significant
MOV A, 60H
MOV B, 63H
MUL AB
// now we subtract the previosuly stored bits
SUBB A, R1
MOV 71H, A
MOV A, B
SUBB A, R2
MOV 70H, A
RET
END