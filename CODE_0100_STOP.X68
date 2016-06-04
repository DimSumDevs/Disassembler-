*-----------------------------------------------------------
* Title      : CODE_0100_NOP
* Written by : TYLER QUAYLE
* Date       : MAY 4, 2016
* Description: PRINT NOP
*-----------------------------------------------------------
        * PAGE 251 -> NOP
    * N O P
    * 0 1 2
    
    ORG    CODE_0100_STOP
STOP_START
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE

    MOVE.B      #$53, (A1)+     * LOAD 'S' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$54, (A1)+     * LOAD 'T' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4F, (A1)+     * LOAD 'O' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$50, (A1)+     * LOAD 'P' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.W      (A4),D5         * Give D5 value at A4     
    MOVE.B      #1, _SIZE       * MOVE 1 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L
    MOVE.B      #7, SOURCE_MODE * MOVE 7 INTO SOURCE, FOR IMMEDIATE
    MOVE.B      #4, SOURCE_REG  * MOVE
    JSR         DECODE_MAIN

LOAD_TO_PRINT_STOP
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
