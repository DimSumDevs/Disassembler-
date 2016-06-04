*-----------------------------------------------------------
* Title      :  MOVEQ
* Written by :  Fuli Lan
* Date       :  05/10/2016
* Description:
*-----------------------------------------------------------
    ORG    CODE_0111_MOVEQ

    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    
    MOVE.W      (A4),D3         * Give D4 value at A4

    MOVE.B      #$4D, (A1)+     * LOAD 'M' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4F, (A1)+     * LOAD 'O' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$56, (A1)+     * LOAD 'V' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$45, (A1)+     * LOAD 'E' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$51, (A1)+     * LOAD 'Q' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$23, (A1)+     * LOAD '#' INTO A1
    ADD.W       #1, D1
    MOVE.B      #$24, (A1)+     * LOAD '$' INTO A1
    ADD.W       #1, D1
    
    MOVE.W      (A4), D3
    LSR.B       #4, D3
    MOVE.B      D3, _CONVERT
    JSR         CONVERT_HEX_ASCII   * CONVERT HEX VALUE AT A4 AND CONVERT TO ASCII-HEX
    MOVE.W      (A4), D3
    LSL.B       #4, D3
    LSR.B       #4, D3
    MOVE.B      D3, _CONVERT
    JSR         CONVERT_HEX_ASCII   * CONVERT HEX VALUE AT A4 AND CONVERT TO ASCII-HEX
    
    MOVE.B      #$2C, (A1)+     * LOAD ',' INTO A1[8]
    ADD.W       #1, D1          * INC CHAR COUNT    
    
    LSR.W       #4, D3          * XXXXRRRX -> RRRX0000 WHERE MMM IS SOURCE MODE
    LSR.B       #5, D3          * RRRX0000 -> 00000RRR WHERE MMM IS SOURCE MODE
    MOVE.B      #0, SOURCE_MODE
    MOVE.B      D3, SOURCE_REG     * FOR SOURCE MODE
    
    
    
    JSR         DECODE_MAIN
    
LOAD_TO_PRINT_MOVEQ
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN


    * Give D4 value at A4
 







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
