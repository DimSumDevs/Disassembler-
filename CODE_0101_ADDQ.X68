*-----------------------------------------------------------
* Title      :ADDQ
* Written by :Fuli Lan
* Date       :05/10/2016
* Description:
*-----------------------------------------------------------
    ORG    CODE_0101_ADDQ

    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    
    
    
    MOVE.W      (A4),D3         * SIZE
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L  
    
    MOVE.W      (A4),D3         * DEST MODE
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM
    MOVE.B      D3,SOURCE_MODE   * FOR DEST MODE
    
    MOVE.W      (A4),D3         * DEST REG
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000
    LSR.B       #5, D3          * RRR00000 -> 00000RRR
    MOVE.B      D3,SOURCE_REG     * FOR DEST REG
       
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$51, (A1)+     * LOAD 'Q' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
   
    CMP.B       #0, _SIZE
    BEQ         ADDQ_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         ADDQ_WORD
    
    CMP.B       #2, _SIZE
    BEQ         ADDQ_LONG
    
ADDQ_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_Q_DECODE
ADDQ_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_Q_DECODE
ADDQ_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_Q_DECODE

ADD_Q_DECODE
    MOVE.W      #3, _SPACES
    JSR         ADD_SPACES  

    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT    
    MOVE.B      #$23, (A1)+     * LOAD '#' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT  
    
    MOVE.W      (A4),D3         * Give D4 value at A4
    LSR.W       #4, D3          * XXXXDDDXXXXXXXXX ->DDDXXXXX WHERE DDD IS DATA
    LSR.B       #5, D3          * DDDXXXXX -> 00000DDD WHERE DDD IS DATA
    MOVE.B      D3, _CONVERT
    JSR         CONVERT_HEX_ASCII * CONVERT HEX VALUE AT A4 AND CONVERT TO ASCII-HEX
    
    MOVE.B      #$2C, (A1)+     * LOAD ',' INTO A1[8]
    ADD.W       #1, D1          * INC CHAR COUNT 
    JSR         DECODE_MAIN
    
LOAD_TO_PRINT_ADDQ
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN


    * Give D4 value at A4


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
