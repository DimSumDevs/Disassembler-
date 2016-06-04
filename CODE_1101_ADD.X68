*-----------------------------------------------------------
* Title      :  CODE_1101_ADD
* Written by :  Fuli Lan
* Date       :  5/21/2016
* Description: Including ADD and ADDA
*-----------------------------------------------------------
    ORG    CODE_1101_ADD
    
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE

    MOVE.W      (A4),D3
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L  
    
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT

    BRA         ADD_SIZE
    
ADD_A
    MOVE.B      (A4),D3
    LSR.B       #6, D3
    MOVE.B      D3,ADDA_SIZE

    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT    
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADDA_SIZE
    
ADD_SIZE

    
    CMP.B       #0, _SIZE
    BEQ         ADD_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         ADD_WORD
    
    CMP.B       #2, _SIZE
    BEQ         ADD_LONG
    
    CMP.B       #3, _SIZE
    BEQ         ADD_A
    

    
ADD_BYTE
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE
ADD_WORD
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE
ADD_LONG
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE
    
ADDA_SIZE
    MOVE.W      (A4),D3
    BTST.L      #8, D3
    BNE         ADDA_LONG
    
ADDA_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADDA_EA_SOURCE
ADDA_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADDA_EA_SOURCE
    
ADD_DECODE  
    MOVE.W      (A4),D3
    BTST.L      #8, D3
    BNE         ADD_DN_SOURCE
    
ADD_EA_SOURCE    
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
    BRA         LOAD_TO_PRINT_ADD
    
ADD_DN_SOURCE    
    MOVE.B      #0,SOURCE_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG     * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,DEST_MODE    * FOR SOURCE MODE
    BRA         LOAD_TO_PRINT_ADD
    
ADDA_EA_SOURCE
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
    BRA         LOAD_TO_PRINT_ADD    
    
LOAD_TO_PRINT_ADD
    JSR         DECODE_MAIN 
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
