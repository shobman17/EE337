ORG 0H
LJMP MAIN
ORG 100H
MAIN:
MOV P1, #0
CALL DELAY_new
MOV P1, #200
HERE: SJMP HERE
ORG 130H

delay_1ms:
push 00h
mov r0, #4
h2: acall delay_250us
djnz r0, h2
pop 00h
ret

delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret

delay_new:
push 00h
mov r0, #95
h10: djnz r0, h10
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

delay_10S: // Actually 9.98s delay
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

END