*-----------------------------------------------------------
* Title      : CODE_1011_CMP
* Written by : TYLER QUAYLE
* Date       : MAY 6, 2016
* Description: 
*-----------------------------------------------------------
    * PG 179 -> CMP
    ORG    CODE_1011_CMP
CODE_1011_CMP_START
    CLR.W       D1              * RESET CHAR COUNT
    
    MOVE.W      (A4),D3         * MOVE BYTE AT A4 TO D3 FOR BIT SHIFT TO FIND REG/MODE
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS SOURCE MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS SOURCE MODE
    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE

    MOVE.W      (A4),D3         * MOVE BYTE AT A4 TO D3 FOR BIT SHIFT TO FIND REG/MODE
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS SOURCE REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS SOURCE REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3         * MOVE BYTE AT A4 TO D3 FOR BIT SHIFT TO FIND REG/MODE
    LSR.W       #1, D3          * XXXXXXXMMMXXXXXX -> MMMXXXXX WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXXXX -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3, DEST_MODE   * FOR DEST MODE
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L  
    
    MOVE.W      (A4),D3         * MOVE BYTE AT A4 TO D3 FOR BIT SHIFT TO FIND REG/MODE
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG     * FOR DEST REG
   
    MOVE.B      #$43, (A1)+     * LOAD 'C' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4D, (A1)+     * LOAD 'M' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$50, (A1)+     * LOAD 'P' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    CMP.B       #0, _SIZE
    BEQ         CMP_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         CMP_WORD
    
    CMP.B       #2, _SIZE
    BEQ         CMP_LONG

CMP_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CMP_DECODE
CMP_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CMP_DECODE
CMP_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CMP_DECODE

CMP_DECODE
    JSR         DECODE_MAIN       

    
LOAD_TO_PRINT_OP_CODE
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
