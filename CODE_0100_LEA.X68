*-----------------------------------------------------------
* Title      : CODE_0100_LEA
* Written by : TYLER QUAYLE
* Date       : MAY 4, 2016
* Description: PRINT JSR
*-----------------------------------------------------------

    ORG    CODE_0100_LEA
    
LEA_START
    CLR.W       D1              * RESET CHAR COUNT
    MOVE.W      (A4),D5         * Give D5 value at A4    
    
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$45, (A1)+     * LOAD 'E' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.W      (A4),D3
    LSR.W       #4, D3
    LSR.B       #5, D3
    MOVE.B      D3, DEST_REG
    MOVE.B      #$1, DEST_MODE
    
    MOVE.W      (A4),D3
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS SOURCE MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS SOURCE MODE
    MOVE.B      D3, SOURCE_MODE    * FOR DEST MODE

    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS SOURCE REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS SOURCE REG
    MOVE.B      D3,SOURCE_REG     * FOR DEST REG 

    JSR         DECODE_MAIN  
LOAD_TO_PRINT_LEA
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
