*-----------------------------------------------------------
* Title      : CODE_0100
* Written by : TYLER QUAYLE
* Date       : MAY 3, 2016
* Description: FINDS CORRECT MISC OPCODE
*-----------------------------------------------------------

    ORG CODE_0100
CODE_0100_START
    

    MOVE.W      (A4),D5         * Give D5 value at A4
                                * WHERE CCC WILL DISTINGUISH WHICH 0100 OPCODE IT IS
    CMP.L       $4E75, D5
    BEQ         RTS_CODE
    CMP.L       $4E71, D5
    BEQ         NOP_CODE
    
    MOVE.B      #8, D2
    LSR.L       D2, D5
    CMP.B       #$4E, D5
    BEQ         INDICATE_JSR
    CMP.B       #$42, D5
    BEQ         CLR_CODE
    CMP.B       #$4C, D5
    BEQ         MOVEM_CODE
    CMP.B       #$48, D5
    BEQ         INDICATE_JSR

    MOVE.W      (A4), D5
    BTST.L      #8, D5
    BNE         INDICATE_LEA
    
    BTST.L      #9,D5
    BEQ         MOVEM_CODE
    
    LSL.W       #4, D5          * XXXXCCCXXXXXXXX -> CCCXXXXXXXXX0000 
    MOVE.B      #12, D6         * MOVE 12 INTO D6 FOR FOLLOWING LSR
    LSR.W       D6, D5          * CCCXXXXXXXX0000 -> 0000000000000CCC    
    
    BRA         INVALID_0100    * NO VALID CODE FOUND, RETURN TO MAIN
INDICATE_MOVEM
    MOVE.W      (A4), D5
    BTST.L      #6, D5
    BNE         MOVEM_CODE
    BRA         INVALID_0100
MOVEM_CODE
    JSR         MOVEM_START     *JUMP INTO MOVEM
    BRA         RETURN_0100     
CLR_CODE
    JSR         CODE_0100_CLR   * GO TO CLR CODE FOR DECODE
    BRA         RETURN_0100     * RETURN TO MAIN

INDICATE_LEA
    BTST.L      #6, D5
    BNE         LEA_CODE
    BRA         INVALID_0100
    

LEA_CODE
    JSR         CODE_0100_LEA
    BRA         RETURN_0100
    
INDICATE_JSR
    MOVE.W      (A4), D5
    BTST.L      #7, 0
    BNE         INVALID_0100

JSR_CODE
    JSR         CODE_0100_JSR
    BRA         RETURN_0100

NOP_CODE
    JSR         CODE_0100_NOP   * GO TO NOP CODE TO PRINT 'NOP' 
    BRA         RETURN_0100     * RETURN TO MAIN

RTS_CODE
    JSR         CODE_0100_RTS   * GO TO RTS CODE TO PRINT 'RTS'
    BRA         RETURN_0100     * RETURN TO MAIN

STOP_CODE
    JSR         CODE_0100_STOP
    BRA         RETURN_0100

INVALID_0100
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    JSR PRINT_NOP_DATA
    SUB.L       #1,_TOTAL       * SUBTRACT 1 FROM TOTAL OPCODES, AS NO ACTUAL OPCODE_FOUND

RETURN_0100
    RTS                         * RETURN TO MAIN



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
