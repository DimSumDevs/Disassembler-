*-----------------------------------------------------------
* Title      :  CODE_0001_MOVE_W
* Written by :  TYLER QUAYLE
* Date       :  MAY 6, 2016
* Description:
*-----------------------------------------------------------
    * PAGE 220 -> MOVE
    ORG    CODE_0011_MOVE_W
    
MOVE_W_START
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE

    MOVE.W      (A4),D3
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS SOURCE MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS SOURCE MODE
    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE

    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS SOURCE REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS SOURCE REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3
    LSR.W       #1, D3          * XXXXXXXMMMXXXXXX -> MMMXXXXX WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXXXX -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,DEST_MODE    * FOR DEST MODE
    
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG     * FOR DEST REG
    
    MOVE.B      #1, _SIZE       * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L
    
    MOVE.B      #$4D, (A1)+     * LOAD 'M' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4F, (A1)+     * LOAD 'O' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$56, (A1)+     * LOAD 'V' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$45, (A1)+     * LOAD 'E' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    CMP.B       #1,DEST_MODE
    BNE         MOVE_W_FINISH
MOVEA_W
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT 

MOVE_W_FINISH:
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[4/5]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[5/6]
    ADD.W       #1, D1          * INC CHAR COUNT
    JSR         DECODE_MAIN       


LOAD_TO_PRINT_MOVE_W
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
