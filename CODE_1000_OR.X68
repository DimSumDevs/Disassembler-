*-----------------------------------------------------------
* Title      :  CODE_1000_OR_AND_DIVU
* Written by :  TYLER QUAYLE AND FULI LAN
* Date       :  5/22/2016
* Description:  Including opcode OR and DIVU
*-----------------------------------------------------------
    ORG    CODE_1000_OR
    
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    
    MOVE.W      (A4),D3
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L,3=DIVU
    BRA         OR_or_DIVN  
    
OR_or_DIVN        
    CMP.B       #3, _SIZE
    BEQ         DIVU
    
OR    
    MOVE.B      #$4F, (A1)+     * LOAD 'O' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$52, (A1)+     * LOAD 'R' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    
    CMP.B       #0, _SIZE
    BEQ         OR_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         OR_WORD
    
    CMP.B       #2, _SIZE
    BEQ         OR_LONG

DIVU
    MOVE.W      (A4), D3
    BTST.L      #8, D3
    BNE         NOT_DIVU_OR
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$49, (A1)+     * LOAD 'I' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$56, (A1)+     * LOAD 'V' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$55, (A1)+     * LOAD 'U' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT     
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.W      #3, _SPACES
    JSR         ADD_SPACES  
    BRA         OR_EA_SOURCE 
    
OR_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         OR_DECODE
OR_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         OR_DECODE
OR_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         OR_DECODE
    
    
OR_DECODE
    MOVE.W      #5, _SPACES
    JSR         ADD_SPACES  
  
    MOVE.W      (A4),D3
    BTST.L      #8, D3
    BNE         OR_DN_SOURCE
    
    
OR_EA_SOURCE    
    MOVE.B      #0,DEST_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG   * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE
    BRA         LOAD_TO_PRINT_OR
    
OR_DN_SOURCE    
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
    
    
LOAD_TO_PRINT_OR
    JSR         DECODE_MAIN 
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN

NOT_DIVU_OR
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    JSR PRINT_NOP_DATA
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
