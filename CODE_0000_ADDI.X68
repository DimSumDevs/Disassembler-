*-----------------------------------------------------------
* Title      :  CODE_0000_ADDI
* Written by :  Fuli Lan
* Date       :  05/24/2016
* Description:  ADDI OPCODE
*-----------------------------------------------------------
    ORG    CODE_0000_ADDI
    
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    MOVE.W      (A4), D5
    MOVE.B      #8, D2
    LSR.L       D2, D5
    CMP.B       #$06,D5
    BNE         NOT_ADDI
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$49, (A1)+     * LOAD 'I' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT   
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.w      (A4),D3
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE    * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L
    
*-------------FOR DATA After the Scource_Reg-----------------    

    
ADDI_SIZE
    
    CMP.B       #0, _SIZE
    BEQ         ADDI_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         ADDI_WORD
*    
    CMP.B       #2, _SIZE
    BEQ         ADDI_LONG

    
ADDI_BYTE
 
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1         * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #7, SOURCE_MODE
    MOVE.B      #4, SOURCE_REG
    BRA         ADDI_SCOURCE

ADDI_WORD

    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1
    MOVE.B      #7, SOURCE_MODE
    MOVE.B      #4, SOURCE_REG
    BRA         ADDI_SCOURCE 
ADDI_LONG
 
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT

    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #7, SOURCE_MODE
    MOVE.B      #4, SOURCE_REG
    BRA         ADDI_SCOURCE
    

ADDI_SCOURCE
    MOVE.W      #2, _SPACES
    JSR         ADD_SPACES
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,DEST_MODE  * FOR SOURCE MODE
    BRA         LOAD_TO_PRINT_ADDI
    
     
LOAD_TO_PRINT_ADDI

    JSR         DECODE_MAIN 
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN

NOT_ADDI
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    JSR PRINT_NOP_DATA
    RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
