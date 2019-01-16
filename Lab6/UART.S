// ENSC Lab 6
// Steven Luu
// Zhe Chen
// Takes roughly 2 mins 13 secs to transfer "Hello, World" 100,000 times

.global asm_main

asm_main:
  LDR R0, =0x41210000   @* LED
  LDR R1, =0x41200000   @* Buttons
  LDR R2, =0x41220000   @* Switches

  LDR R3, =0xE0001004	@* Transmitter
  LDR R4, =0xE0001018	@* baud rate generator
  LDR R5, =0xE0001034	@* baud rate divider
  LDR R6, =0xE0001000	@* control register

  LDR R7, =0x20
  STR R7, [R3, #0]		@* Setting up transmitter
  LDR R7, =#62
  STR R7, [R4, #0]		@* Setting up baud rate to 62
  LDR R7, =#6
  STR R7, [R5, #0]		@* Setting up BDIV value to 6
  LDR R7, =0x117
  STR R7, [R6, #0]		@* Setting up control register

Begin:
  BL Button_Debounce
  LDR R8, [R1, #0] 		@* Load R8 with Button Press
  BL Button_Debounce
  CMP R8, #0
  BLNE Many_Print
  B Begin

Many_Print:
  Push {R6, R14}
  LDR R6, =#100000
 LoopMP:
  BL Delay
  BL Print
  CMP R6, #0
  SUB R6, R6, #1
  BNE LoopMP
  Pop {R6, R14}
  MOV R15, R14

Print:					@* Prints "Hello, World"
  Push {R14}
  LDR R9, =0xE0001030
  LDR R10, =#72 		@* ASCII Value of H = 72 in decimal
  STR R10, [R9]         @* Load 72 to =0xE0001030
  LDR R10, =#101        @*e
  STR R10, [R9]
  LDR R10, =#108      	@*l
  STR R10, [R9]
  LDR R10, =#108      	@*l
  STR R10, [R9]
  LDR R10, =#111        @*o
  STR R10, [R9]
  LDR R10, =#44   	    @*,
  STR R10, [R9]
  LDR R10, =#32         @*_
  STR R10, [R9]
  LDR R10, =#87         @*W
  STR R10, [R9]
  LDR R10, =#111        @*o
  STR R10, [R9]
  LDR R10, =#114        @*r
  STR R10, [R9]
  LDR R10, =#108        @*l
  STR R10, [R9]
  LDR R10, =#100        @*d
  STR R10, [R9]
  LDR R10, =#32         @_
  STR R10, [R9]
  LDR R10, =#10         @*Newline
  STR R10, [R9]
  LDR R10, =#13         @*Carriage Return
  STR R10, [R9]
  Pop {R14}
  MOV R15, R14

Button_Debounce:		@* SOFTWARE DELAY TO IMPROVE BUTTON BOUNCE
  Push {R6}
  LDR R6, =#2000000
 LoopBD:
  CMP R6, #0
  SUB R6, R6, #1
  BNE LoopBD
  Pop {R6}
  MOV R15, R14

Delay:					@* Software Delay for the UART Buffer
  Push {R7, R14}
  LDR R7, =#33000
 LoopDL:
  CMP R7, #0
  SUB R7, R7, #1
  BNE LoopDL
  Pop {R7, R14}
  MOV R15, R14
