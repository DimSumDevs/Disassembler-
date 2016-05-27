*-----------------------------------------------------------
* Title      :  MEM_GET
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
MEM_FROM    EQU $600
MEM_TO      EQU $610
MEM_BUFFER  EQU $620
    ORG    $400
START:                  ; first instruction of program

* Put program code here
    MOVEA.L #MEM_BUFFER, A5 
    LEA     FROM_Msg, A1   * Insert Msg to prompt user into A1 for display
    MOVE.B  #14, D0     * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15         * Display Prompt
    MOVE.B  #2, D0      * Task 2 for Trap 15, Read in String
    TRAP    #15         * Get User input

  
    MOVE.B  D1, D2      * D2 used for Looping 8 times 

CONVERT * For(D2 = 8, D2 > 0, D2--)  
    MOVE.B  (A1)+,D3    * Give D4 first Byte of user input, then increment
    
    SUB.B   #1, D2              * For Loop decrement
    CMP.B   #0, D2              * Check for end of For-Loop
    BLT     READ_IN_DONE        * Conversion Done, Go To Movebits
    
    BRA     ASCII_TO_HEX


ASCII_TO_HEX
    CMP.B       #$39, D3        * IF VALUE OF HEX IS GREATER OR EQUAL TO 10(A)
    BGE         ATH_LETTER      * VALUE IS < 3A, CONVERT NUMBER
    BRA         ATH_NUM         * VALUE IS #0-9, CONVERT LETTER

ATH_LETTER
    CMP.B       #$46, D3
    BGE         INVALID
    SUB.W       #$37, D3        * ADD #$30 TO D3, TO GET ASCII-HEX LETTER VALUE
    MOVE.B      D3, (A5)+       * ADD ASCII-HEX CHAR(A-F) TO A1, INCREMENT A1
    BRA         CONVERT         * LOOP BACK TO CONVERT
ATH_NUM
    CMP.B       #$30, D3
    BLE         INVALID
    SUB.W       #$30, D3        * ADD #$30 TO D3, TO GET ASCII-HEX NUMBER VALUE
    MOVE.B      D3, (A5)+       * ADD ASCII-HEX CHAR(0-9) TO A1, INCREMENT A1
    BRA         CONVERT         * LOOP BACK TO CONVERT  
READ_IN_DONE
    MOVEA.L     #MEM_BUFFER, A5 * RESET A5 TO START OF 'BUFFER'
    MOVEA.L     #MEM_FROM,  A4
MOVE_TOGETHER    
    ADD.B      (A5)+, D3
    LSL.L       #4, D3
    ADD.B       (A5)+, D3
    LSL.L       #4, D3
    SUB.B       #1, D1              * For Loop decrement
    CMP.B       #1, D1              * Check for end of For-Loop
    BEQ         INVALID        * Conversion Done, Go To Movebits
    BRA         MOVE_TOGETHER


INVALID
    MOVE.L      D3, (A4)
    SIMHALT             ; halt simulator

*---------OutPut Values--------------------------------------------------------
CR      EQU $0D             ;ASCII code for Carriage Return
LF      EQU $0A             ;ASCII code for Line Feed
InMsg   DC.B CR,'Please enter IEEE 32-bit floating point number in hexadecimal: ' ,0
FROM_Msg   DC.B CR,'Enter the Starting Address: ' ,0
OutSig  DC.B CR, LF,'Sign Bit: ',0
OutExp  DC.B CR, LF,'Exponent: ',0
OutMan  DC.B CR, LF,'Mantissa: ',0

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
