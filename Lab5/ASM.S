// LAB5 PART 6
// GROUP 81
// STEVEN LUU
// ZHE CHEN

.global asm_main
.align 4
memory: .space 2000000
.align 4

asm_main:
  LDR R0, =0x41210000  // LED
  LDR R1, =0x41200000  // Buttons
  LDR R2, =0x41220000  // Switches
  LDR R3, =memory
  MVN R4, #0
  STR R4, [R3]
  //PUSH {R0}
  // Memory Allocation
  LDR R5, [R3, #0]
  LDR R6, [R3, #4]
  LDR R7, [R3, #8]
  LDR R8, [R3, #12]
  LDR R8, =#128				// USED FOR INITIAL LED LD7
  LDR R9, [R3, #16]			// USED FOR KEEP VALUE OF CURRENT LED STATE
  LDR R9, =#0
  LDR R10, [R3, #20]		// USED TO TRACK WHICH BUTTON IS PRESSED
  LDR R10, =#0
  LDR R11, [R3, #24]
  LDR R11, =#0				// USED TO SAVE LED STATE WHEN BUTTON IS ALREADY PRESSED
  LDR R12, [R3, #28]
  LDR R12, =#0              // USED TO COMPARE BUTTONS

CheckInput:
  LDR R5, [R1,#0] 			// LOAD R5 WITH BUTTON PRESS
  BL Button_Debounce        // SOFTWARE DELAY FOR BUTTON DEBOUNCE
  CMP R5, #0
  BLLE TurnOff				// LED IS OFF WHEN BUTTON IS NOT PRESSED
  BL Compare_Input          // COMPARE BUTTON INPUTS
  CMP R12, #1
  BLGE WhichButton          // DETERMINE WHICH BUTTON IS PRESSED
  CMP R12, #2
  BLEQ UpdateNextLED	    // HOLD CURRENT LED AND UPDATE THE NEXT LED
  CMP R12, #1
  BLEQ ResetNextLED 	    // HOLD CURRENT LED AND RESET THE NEXT LED
  CMP R12, #0
  BLGT Check_LED            // CHECK LED
  LDR R11, [R0, #0]			// SAVE CURRENT LED STATE
  B CheckInput

Button_Debounce:			// SOFTWARE DELAY TO IMPROVE BUTTON BOUNCE
  Push {R6}
  LDR R6, =#100000
 LoopBD:
  CMP R6, #0
  SUB R6, R6, #1
  BNE LoopBD
  Pop {R6}
  MOV R15, R14

WhichButton:				// DETERMINES WHICH BUTTON IS PUSHED
  Push {R6, R14}
  LDR R6, =#32
 LoopAB:					// GO THROUGH POSSIBLE VALUES FOR BUTTON PRESSES 2^(5-0)
  CMP R5, R6
  ADDEQ R10, R6, #0 		// IF A MATCH IS FOUND SAVE THE BUTTON VALUE
  SUBS R6, R6, #1
  CMP R6, #0
  BNE LoopAB
  Pop {R6, R14}
  MOV R15, R14

Check_LED:
  Push {R6, R7, R14}
  LDR R6, [R2, #0]			// LOAD R6 WITH SWITCH STATE
  LDR R7, [R0, #0]          // LOAD R7 WITH LED STATE
  CMP R6, #255		        // CHECK IF ALL SWITCHES ARE IN UP POSITION
  BLNE Check_Switch         // IF NOT THE CHECK WHICH SWITCHES NEED TO BE SKIPPED, not currently working
  CMP R7, #0
  BLGE KeepOn
//  BLEQ TurnOn
  Pop {R6, R7, R14}
  MOV R15, R14

Check_Switch:				// Check if Switch is in Up position
  Push {R5, R7, R14}
  LDR R5, =#8
  LoopSW:					// Loop for Checking Bits
  BIC R7, R8, R6            // Bitswise AND of LED State with complement of Switch State
  LSRS R7, R7, R5           // Shift Bits for comparison
  BLCS SkipLED              // Check Carry Flag to Skip LED
  SUBS R5, R5, #1
  CMP R5, #0
  BNE LoopSW
  ADDS R9, R8, #0
  Pop {R5, R7, R14}
  MOV R15, R14

UpdateNextLED:
  Push {R5, R6, R7, R14}
  LDR R5, =#8
  LoopUNL:					// Loop for Checking LED
  ANDS R6, R11, R8			// Check if LED is lit
  LSRS R6, R6, R5           // ShiftBits for comparison
  BLCS SkipLED              // Skip LED when Insertion point match lit LED
  SUBS R5, R5, #1
  CMP R5, #1
  BNE LoopUNL
  ADDS R9, R8, #0
  Pop {R5, R6, R7, R14}
  MOV R15, R14

ResetNextLED:
  SUBS R11, R11, R9
  LDR R9, =#0
  MOV R15, R14

Compare_Input:
  CMP R5, R10
  LDREQ R12, =#0
  LDRLT R12, =#1
  LDRGT R12, =#2
  MOV R15, R14

SkipLED:					// SKIP LED
  LSR R8, R8, #1
  CMP R8, #0
  LDREQ R8, =#128
  MOV R15, R14

KeepOn:
  Push {R5}
  LDR R5, =#0
  ORR R5, R11, R9			// Bitwise And Current LED lit and Next LED to be lit
  STR R5, [R0, #0]			// LOAD LED
  CMP R9, #0
  LSRNE R8, R8, #1			// ROTATE BITS for the NEXT LED to be Lit
  CMP R8, #0
  LDREQ R8, =#128
  Pop {R5}
  MOV R15, R14

/*
TurnOn:						// CODE TO ENABLE LED, REPLACED WITH KeepOn
  STR R8, [R0, #0]			// LOAD LED
  LSR R8, R8, #1			// ROTATE BITS for the NEXT LED to be Lit
  CMP R8, #0
  LDREQ R8, =#128
  MOV R15, R14
*/

TurnOff:
  Push {R9}
  LDR R9, =#0				// TURN OFF LED
  STR R9, [R0, #0]          // SETS ALL LED TO 0
  LDR R10, =#0
  LDR R11, =#0				// LED OFF NO BUTTONS ARE PUSHED, RESET BUTTON TRACK VALUE
  Pop {R9}
  MOV R15, R14
