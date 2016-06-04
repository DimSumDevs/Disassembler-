*-----------------------------------------------------------
* Title      : CODE_0100_CLR
* Written by : TYLER QUAYLE
* Date       : MAY 3, 2016
* Description: DISASSEMBLES CLR
*-----------------------------------------------------------
        * PAGE 177 -> CLR
    * F E D C B A 9 8 7 6  5 4 3  2 1 0
    * 0 1 0 0 0 0 1 0 SIZ   MODE  REGIS

    * C L R . B _ $ 3 3 3 3 3 3 3 3
    * 0 1 2 3 4 5 6 7 8 9 A B C D E

    * C L R . B _ ( A 6 ) +
    * 0 1 2 3 4 5 6 7 8 9 A 

    * C L R . B _ D 1
    * 0 1 2 3 4 5 6 7       
    ORG    CODE_0100_CLR
CLR_START
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    MOVE.W      (A4),D4         * Give D4 value at A4
    
    MOVE.B      #$43, (A1)+     * LOAD 'C' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$52, (A1)+     * LOAD 'R' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT

CLR_GET_SIZE
    LSR.B       #6, D4          * SSXXXXXX -> 000000SS WHERE SS IS SIZE
    CMP.B       #0, D4          * TEST TO SEE IF SIZE IS 0 (BYTE)
    BEQ         CLR_BYTE        * SIZE IS O (BYTE) GO TO CLR_BYTE
    CMP.B       #1, D4          * TEST TO SEE IF SIZE IS 1 (WORD)
    BEQ         CLR_WORD        * SIZE IS 1 (WORD) GO TO CLR_WORD
    BRA         CLR_LONG        * SIZE IS 2 (LONG) GO TO CLR_LONG

CLR_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CLR_MODE        * GO TO CLR_MODE   
CLR_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CLR_MODE        * GO TO CLR_MODE    
CLR_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CLR_MODE
CLR_MODE    
    MOVE.W      (A4),D3         * Give D4 value at A4
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00  
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM
    MOVE.B      D3, SOURCE_MODE *
    
    MOVE.W      (A4),D3         * Give D5 value at A4
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000  WHERE RRR IS REGISTER
    LSR.B       #5, D3          * RRR00000 -> 00000RRR  WHERE RRR IS REGISTER
    MOVE.B      D3,SOURCE_REG

    JSR         DECODE_MAIN        * GO TO SOURCE_DEC
       
LOAD_TO_PRINT_CLR
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
