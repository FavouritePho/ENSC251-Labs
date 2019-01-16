.global _start

_start:
MOV R4, #110   // Candidate Number N, TEST NUMBER
MOV R5, #65536 // Setting largest possible candidate
SUB R5, #1     // FFFF
MOV R8, R4     // SETTING N-1
SUB R8, #1
MOV R0, #0     // Initialize registers

MOV R1, #2
MOV R2, #2
MOV R9, R4

_loop1:
MOV R7, R1    	// USED FOR R1 MULITPLICATION

_loop2:   
MOV R6, R2    	// USED FOR R2 MULITPLICATION
MOV R3, #0


_loopM:       	// Multiplication Loop
ADD R3, R3, R7
SUB R6, #1
CMP R6, R0    	// CHECK IF DONE
BNE _loopM

CMP R9, R3    	// COMPARE RESULT WITH N
BEQ _NOT_PRIME  // Branches if result is EQUAL

Add R2, R2, #1 	// UPDATE R2
CMP R2, R8    	// CONTINUE UNTIL R2 = N-1
BNE _loop2 

ADD R1, R1, #1 	// UPDATE R1
MOV R2, R1    	// UPDATE R2

CMP R1, R8    	// CONTINUE UNTIL R1 = N-1
BNE _loop1

CMP R9, R3      // CHECK IF PRIME
BNE _PRIME

B _DONE

_NOT_PRIME:
SUB R9, #1      // UPDATE R9 
SUB R8, #1   	// UPDATE R8 SINCE N IS NOT A PRIME
MOV R1, #2
MOV R2, #2
B _loop1

_PRIME:
MOV R11, R9     // SAVE PRIME NUMBER TO R11

_DONE:
MOV R12, #1
