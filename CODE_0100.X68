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
    BTST.L      #8, D5
    BNE         LEA_CODE
    
    BTST.L      #9,D5
    BEQ         MOVEM_CODE
    
    LSL.W       #4, D5          * XXXXCCCXXXXXXXX -> CCCXXXXXXXXX0000 
    MOVE.B      #12, D6         * MOVE 12 INTO D6 FOR FOLLOWING LSR
    LSR.W       D6, D5          * CCCXXXXXXXX0000 -> 0000000000000CCC
    
    CMP.B       #%0010, D5      * TEST: CLR
    BEQ         CLR_CODE        * CLR CODE FOUND
    
    CMP.B       #%1110, D5      * TEST: NOP/RTS
    BEQ         NOP_STOP_RTS      * EITHER RTS/NOP FOUND
    

    
    BRA         INVALID_0100    * NO VALID CODE FOUND, RETURN TO MAIN
MOVEM_CODE
    JSR         MOVEM_START     *JUMP INTO MOVEM
    BRA         RETURN_0100     
CLR_CODE
    JSR         CODE_0100_CLR   * GO TO CLR CODE FOR DECODE
    BRA         RETURN_0100     * RETURN TO MAIN

LEA_CODE
    JSR         CODE_0100_LEA
    BRA         RETURN_0100

NOP_STOP_RTS
    MOVE.W      (A4),D5         * RESET VALUE IN D5 TO OPCODE AT A4
    BTST.L      #7, D5
    BNE         JSR_CODE
    BTST.L      #1, D5
    BNE         STOP_CODE

NOP_OR_RTS
    BTST.L      #2, D5          * BIT TEST BIT 2, IF 1 IT'S RTS, ELSE NOP
    BNE         RTS_CODE        * BIT #2 WAS 1, RTS CODE
    BTST.L      #0, D5
    BNE         NOP_CODE        * BIT #0 WAS 1, NOP CODE
    BRA         INVALID_0100

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
    SUB.B       #1,SCREEN_COUNT * SUBTRACT 1 FROM SCREEN_COUNT TO GIVE ACTUAL COUNT TO FOUND OPCODES
    SUB.L       #1,_TOTAL       * SUBTRACT 1 FROM TOTAL OPCODES, AS NO ACTUAL OPCODE_FOUND

RETURN_0100
    RTS                         * RETURN TO MAIN






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
