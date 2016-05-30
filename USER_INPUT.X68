*-----------------------------------------------------------
* Title      : USER_INPUT
* Written by : Michael Ritchie
* Date       : 5/20
* Description: Accepts user input for start and end of memory dissasembly
*-----------------------------------------------------------
    ORG    USER_INPUT
START_USER_INPUT                  ; first instruction of program

*print instruction to user
PROMT_ONE
    LEA PromptOne,A1
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15             * Display Prompt
    MOVE.L  #STORE_INPUT,A1  *set A1 to address for storing data
    MOVE.L  #MEM_FROM,A3    *set A3 to address of MEM_TO
    JSR READ_IN_DATA        *read in the first address
    JSR CHECK_DATA          *check if data is good, will continue prompting user until good data is obtained
    JSR MOVE_BITS           *compress data
        
PROMPT_TWO
    LEA PromptTwo,A1
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15             * Display Prompt
    MOVE.L  #STORE_INPUT,A1  *set A1 to address for storing data
    MOVE.L  #MEM_TO,A3      *set A3 to address of MEM_TO
    JSR READ_IN_DATA        *read in the first address
    JSR CHECK_DATA          *check if data is good, will continue prompting user until good data is obtained
    JSR MOVE_BITS           *compress data
*---------------ThIS IS ALL BROKEN--------------------------------------------
    *CMP.L MEM_FROM,D4       *compare mem_to with mem_from, if mem_to is greator then thats bad
    *BLT RETURN              *should be done now, return
    
    *LEA DifferenceError,A1  *load difference error message
    *MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    *TRAP    #15             * Display Prompt
    *BRA START_USER_INPUT    *from address was larger then too address so repeat
    
*read data from user
READ_IN_DATA
    MOVE.B  #2, D0          * Task 2 for Trap 15, Read in String
    TRAP    #15             * Get User input
    RTS
*check data byte by byte
CHECK_DATA

    MOVEA.L A1, A2          * Give A2 Starting Address to save the address   
    MOVE.B  #0, D2          * D2 used for Looping 8 times 
    
CONVERSION_LOOP             *loop 8 times for the 8 bytes of data
    MOVE.B  (A1),D4        * Give D4 first Byte of user input, then increment
    
    ADD.B   #1, D2          * For Loop increment
    CMP.B   #9, D2          * Check for end of For-Loop
    BEQ     CONVERSION_DONE *all done
 
    CMP.B   #$40, D4        * Compare if D4 contains greater than $40 (A = $41, B = $42)
    BGT     CONV_LETTER     * Letter Possibly Found, go to Conv_Letter to Confirm
    
    CMP.B   #$3A, D4        * Compare D4 if less than $3A (Hex for :) (9 = $39, 8 = $38) 
    BLT     CONV_NUMBER     * Number possibly Found, go to Conv_Number to Confirm
    
    BRA     MISSING         *charachter was in between 3A and 40 and is invlaid
    
CONV_LETTER
    CMP.B   #$46, D4        * Check to see if D4 falls within $41-$46 (A-F)
    BGT     MISSING         * Not $41-$46 (HEX A-F), Bad/No Data, Jump to Missing
    SUB.B   #$37, D4        * Subtract $30, to convert (ASCII->HEX)
    MOVE.B  D4, (A1)+       * Give current A3 the D4 hex value and Increment
    BRA CONVERSION_LOOP     * Successfully Convert (ASCII->HEX), Branch back to Convert Loop

CONV_NUMBER
    CMP.B   #$30, D4        * Check to see if D4 falls within $30-$39 (0-9)    
    BLT     MISSING         * Not $30-$39 (HEX 0-9), Bad/No Data, Jump to Missing
    SUB.B   #$30, D4        * Subtract $30, to convert (ASCII->HEX)
    MOVE.B  D4, (A1)+       * Give current A3 the D4 hex value and Increment
    BRA CONVERSION_LOOP     * Successfully Convert (ASCII->HEX), Branch back to Convert Loop

MISSING * missing or incorrect data, so print error message and get new data
    LEA     InputError,A1   *load error message into A1
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15             * Display Error
    
    MOVEA.L A2,A1           *reset A1 to proper destination for data
    JSR READ_IN_DATA        *get new data
    BRA CHECK_DATA          *branch back to top and try again

CONVERSION_DONE
    MOVEA.L A2,A1           * Reset A1 to starting address
    RTS                     *return
MOVE_BITS
    MOVE.B  #5,D2           *Set up loop counter
MOVE_LOOP * For(D2 = 5, D2 > 0, D2--)
    SUB.B   #1, D2          * For Loop decrement
    CMP.B   #0, D2          * Check if conditions have been met
    BEQ     MOVE_DONE       * Bit moving done
    MOVE.B (A1)+, D3        * Move Current Byte into D3
    LSL.L   #4, D3          * Logical Shift Bits 1 Nibble Left (0X->X0)
    ADD.B  (A1)+,D3         * Add next Byte into Bit Shifted D3(XX)
    LSL.L   #8, D4          * Logical Shift D4 1 Byte (00XX->XX00)
    ADD.B   D3, D4          * Add D3 Byte to D4 (XXXX)
    BRA MOVE_LOOP            * Repeat Loop
MOVE_DONE
    MOVE.L  D4,(A3)
    RTS                     *DONE MOVING BITS SO RETURN
*assign data to variables used by main
RETURN
    RTS                 *all done, return to main

*---------OutPut Values--------------------------------------------------------
CR      EQU $0D             ;ASCII code for Carriage Return
LF      EQU $0A             ;ASCII code for Line Feed
PromptOne DC.B CR,'Please enter long word hexadecimal start address: ' ,0
PromptTwo DC.B CR,'Please enter long word hexadecimal end address: ' ,0
InputError   Dc.B CR,'Error - Please enter 8 digits of valid input ', 0
DifferenceError Dc.B CR,'Error - start must be greater then End address'













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
