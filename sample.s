// ENSC 254 Lab 3
// Lab Group
// Steven Luu
// 301150253

.global _start

_start:

LDR R0, =#0001 // 64 bit number, 32 bit most significant half, N2 
LDR R1, =#0000
//MOV R0, #0 // 64 bit number, 32 bit most significant half, N2 
//MOV R1, #16  // 64 bit number, 32 bit least significant half, N1 
//UMOV 

MOV R2, #0 // Square Output, Y
MOV R3, #1 // Starting number, N 
LDR R4, =#4294967296 // Largest Square root of a 32 bit number (2^16), N(MAX)

MOV R5, #0 // Lower bound, a
CMP R0, R1   // Set Upper bound, b
BLT SetUBound1
BGT SetUBound2 

Loop1:
ADD R7, R5, R6 // C = a + b 
LSR R7, #1  //Divide by 2

UMULL R8, R9, R7, R7 // Calculate C^2
CMP R8, R1 // Compare least significant
BEQ Compare // Check for Square Root
ChangeBound:
BGE Upper// Change Upper Bound
BLT Lower// Change Lower Bound

Resume:
ADD R3, #1 // Increment N
CMP R3, R4 // Loops until N reaches N(MAX), prevents infinite loop
BEQ Done
BNE Loop1


Upper:
MOV R6, R7 
B Resume

Lower:
MOV R5, R7
B Resume

SetUBound1:
MOV R6, R1
B Loop1
SetUBound2:
MOV R6, R0
B Loop1

Compare:
CMP R9, R0 // Compare most significant
BEQ Done
BNE ChangeBound
Done:
MOV R2, R7 //Output Square Root to Y
