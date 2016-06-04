*-----------------------------------------------------------
* Title      :  CODE_1001_SUB
* Written by :  Fuli Lan
* Date       :  5/15/2016
* Description:
*-----------------------------------------------------------
    ORG    CODE_1001_SUB
    
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE

    MOVE.B      #$53, (A1)+     * LOAD 'S' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$55, (A1)+     * LOAD 'U' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT

    MOVE.W      (A4),D3
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L 
    
    CMP.B       #0, _SIZE
    BEQ         SUB_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         SUB_WORD
    
    CMP.B       #2, _SIZE
    BEQ         SUB_LONG
    
SUB_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         SUB_DECODE
SUB_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         SUB_DECODE
SUB_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         SUB_DECODE

SUB_DECODE
    MOVE.W      #4, _SPACES
    JSR         ADD_SPACES  
  
    MOVE.W      (A4),D3
    BTST.L      #8, D3
    BNE         SUB_DN_SOURCE
    
SUB_EA_SOURCE    
    MOVE.B      #0,DEST_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG     * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE
    BRA         LOAD_TO_PRINT_SUB
    
SUB_DN_SOURCE    
    MOVE.B      #0,SOURCE_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,DEST_MODE  * FOR SOURCE MODE
    
    
LOAD_TO_PRINT_SUB
    JSR         DECODE_MAIN 
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN


<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
