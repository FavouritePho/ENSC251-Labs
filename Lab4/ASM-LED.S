.global asm_main

asm_main:
  LDR R0, =0x41210000		// LED
  LDR R1, =0x41200000       // Buttons
  LDR R2, =0x41220000       // Switches
  LDR R3, =#128       		// 128 Correlates to Leftmost LED, 1000 0000
  STR R3, [R0,#0]
  B CheckLED

CheckLED:
  LDR R5, [R2, #0]
  CMP R5, #1                // Button to reset program
  BEQ asm_main
  LDR R4, =#0
  CMP R3, #128      		// Check if LED is lit
  BNE TurnON                // Branches to Turn On
  BEQ TurnOFF               // Branches to Turn Off

TurnON:
  LDR R3, =#128				// 1000 0000
  STR R3, [R0, #0]
  B Delay1

TurnOFF:
  LDR R3, =#0				// 0000 0000
  STR R3, [R0, #0]
  B Delay2

Delay1:
  LDR R5, =#300000
  ADD R4, R4, #1
  CMP R4, R5
  BNE Delay1
  BEQ CheckLED

Delay2:
  LDR R5, =#245454
  CMP R4, R5
  ADD R4, R4, #1
  BNE Delay2
  BEQ CheckLED
