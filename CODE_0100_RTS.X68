*-----------------------------------------------------------
* Title      : CODE_0100_RTS
* Written by : TYLER QUAYLE
* Date       : MAY 4, 2016
* Description: PRINT RTS
*-----------------------------------------------------------
        * PAGE 273 -> RTS
    * R T S
    * 0 1 2
    
    ORG    CODE_0100_RTS
RTS_START
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    MOVE.W      (A4),D5         * Give D5 value at A4      ; last line of source

    MOVE.B      #$52, (A1)+     * LOAD 'R' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$54, (A1)+     * LOAD 'T' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$53, (A1)+     * LOAD 'S' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT

LOAD_TO_PRINT_RTS
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
