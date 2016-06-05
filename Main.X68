*-----------------------------------------------------------
* Title      : Main
* Written by : Tyler Quayle
* Date       : May 3, 2016
* Description: Test Main Loop for 422 Project
*-----------------------------------------------------------
    INCLUDE 'embed_test.x68' ********** ONLY USED FOR QUICK TESTS! GET RID OF THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    INCLUDE '_VARIABLES.X68'
    INCLUDE 'ADD_SPACES.x68'
    INCLUDE 'USER_INPUT.X68'
    INCLUDE 'CONVERT_HTA.X68'
    INCLUDE 'PRINT_NOP_DATA.X68'
        INCLUDE '_INIT.X68'
    INCLUDE 'DECODE_MAIN.x68'
    INCLUDE 'DECODE_SORT.x68'
        INCLUDE 'ABS_DECODE.x68'
        INCLUDE 'IMM_DECODE.x68'
        INCLUDE 'CONVERT_HEX_ASCII.x68'
    INCLUDE 'CODE_0001_MOVE_B.x68'
    INCLUDE 'CODE_0010_MOVE_L.x68'
    INCLUDE 'CODE_0101_ADDQ.x68'
    INCLUDE 'CODE_0011_MOVE_W.x68'

    INCLUDE 'CODE_0100.x68'
        INCLUDE 'CODE_0100_MOVEM.X68'
        INCLUDE 'CODE_0100_CLR.x68'
        INCLUDE 'CODE_0100_NOP.x68'
        INCLUDE 'CODE_0100_RTS.x68'
        INCLUDE 'CODE_0100_JSR.x68'
        INCLUDE 'CODE_0100_STOP.x68'
        INCLUDE 'CODE_0100_LEA.x68'
    INCLUDE 'CODE_0110_BCC.X68'
    INCLUDE 'CODE_0111_MOVEQ.x68'
    INCLUDE 'CODE_1000_OR.x68'
    INCLUDE 'CODE_1011_CMP.X68'
    INCLUDE 'CODE_1100_AND.X68'
    INCLUDE 'CODE_1110.x68'
    INCLUDE 'CODE_1101_ADD.X68'
    INCLUDE 'CODE_1001_SUB.X68'
    *INCLUDE 'CODE_1100_MULU.X68' ******included inside CODE_1100_AND
    INCLUDE 'CODE_0000_ADDI.X68'
    
    ORG    MAIN
START:
    JSR         _INIT           * GO TO _INIT, DEALS WITH MEM MANAGEMENT    
    MOVEA.L     A1LOC, A1       * RESET A1
    CLR.W       D1              * RESET CHAR COUNT
    MOVEA.L     MEM_FROM, A4    * ADDR OF TEST FILE 
    MOVE.W      (A4),D4
    
    BRA         SEARCH_LOOP

SEARCH_LOOP
    CMP.B   #31, SCREEN_COUNT   * IF 30 VALUES HAVE BEEN SUCCESSFULLY READ. STOP READING UNTIL NULL
    BEQ     SCREEN_PAUSE        * 30 VALUES 'SHOULD' BE ON SCREEN -NOTE: NOT WORKING DUE TO CERTAIN UNUSED OPCODES
    MOVE.W  #12, D2             * PUT 12 INTO D2, FOR FOLLOWING SHIFT
    LSR.W   D2,D4               * SHIFT 15-12 -> 3-0. 
                                * FFFFXXXXXXXXXXXX -> 000000000000FFFF WHERE FFFF IS FIRST 4 BITS 
    
    CMP.B   #%0000, D4          *TEST: BIT MANIP/MOVEP/immediate
    BEQ     CODE0000            *SUCCESS
 
    CMP.B   #%0001, D4          *TEST: MOVE BYTE
    BEQ     CODE0001            *SUCCESS
    
    CMP.B   #%0010, D4          *TEST: MOVE LONG
    BEQ     CODE0010            *SUCCESS
        
    CMP.B   #%0011, D4          *TEST: MOVE WORD
    BEQ     CODE0011            *SUCCESS
    
    CMP.B   #%0100, D4          *TEST: MISC - RTS | CLR | NOP
    BEQ     CODE0100            *SUCCESS
        
    CMP.B   #%0101, D4          *TEST: ADDQ/SUBQ/Scc/DBcc
    BEQ     CODE0101            *SUCCESS
        
    CMP.B   #%0110, D4          *TEST: BSR/BRA/Bcc
    BEQ     CODE0110            *SUCCESS
      
    CMP.B   #%0111, D4          *TEST: MOVEQ
    BEQ     CODE0111            *SUCCESS
        
    CMP.B   #%1000, D4          *TEST: OR/DIV/SBCD
    BEQ     CODE1000            *SUCCESS
        
    CMP.B   #%1001, D4          *TEST: SUB/SUBX
    BEQ     CODE1001            *SUCCESS
        
    CMP.B   #%1010, D4          *TEST: UNASSIGNED
    BEQ     CODE1010            *SUCCESS
        
    CMP.B   #%1011, D4          *TEST: CMP/EOR
    BEQ     CODE1011            *SUCCESS
        
    CMP.B   #%1100, D4          *TEST: AND/MUL/ABCD/EXG
    BEQ     CODE1100            *SUCCESS
        
    CMP.B   #%1101, D4          *TEST: ADD/ADDA/ADDX
    BEQ     CODE1101            *SUCCESS
        
    CMP.B   #%1110, D4          *TEST: SHIFT/ROTATE
    BEQ     CODE1110            *SUCCESS
    
    CMP.B   #%1111, D4          *TEST: SPECIAL/RESERVED
    BEQ     CODE1111            *SUCCESS

INC_LOOP
    MOVEA.L  A1LOC, A1          * RESET A1    
    ADDA.L   #$2, A4            * INC Address
CONTINUE_LOOP
    MOVE.W  (A4), D4            * Move Byte contents into Data
    CMPA.L  MEM_TO, A4          * Compare to MAIN
    BGE     ALMOST_DONE         * If Current address is larger than main, exit
    BRA     SEARCH_LOOP         * Repeat Loop

CODE0000
    JSR     CODE_0000_ADDI      * CHECK FOR ADDI, ONLY VALUE USING 0000 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0001
    JSR     CODE_0001_MOVE_B    * CHECK FOR MOVE.B, ONLY VALUE USING 0001 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0010
    JSR     CODE_0010_MOVE_L    * CHECK FOR MOVE.L, ONLY VALUE USING 0010 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0011
    JSR     CODE_0011_MOVE_W    * CHECK FOR MOVE.W, ONLY VALUE USING 0011 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0100
    JSR     CODE_0100           * CHECK FOR DIFFERENT OPCODES AT 0100 (RTS/NOP/CLR/ETC)
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0101
    JSR     CODE_0101_ADDQ      * CHECK FOR ADDQ, ON;Y OPCODE USING 0101
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0110
    JSR     START_CODE_0110_BCC * CHECK FOR BCC, ONLY OPCODE USING 0110
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE0111
    JSR     CODE_0111_MOVEQ     * CHECK FOR MOVEQ, ONLY VALUE USING 0011 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1000
    JSR     CODE_1000_OR        * CHECK FOR OR, ONLY VALUE USING 1000 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1001
    JSR     CODE_1001_SUB        * CHECK FOR SUB, ONLY VALUE USING 1001 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1010
    JSR PRINT_NOP_DATA          *PRINT ANY DATA AT THIS ADDRESS
    JSR GARBAGE_COUNT_INCREASE  *INCREMENT GARBAGE COUNT ONLY
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1011
    JSR     CODE_1011_CMP       * CHECK FOR CMP, ONLY VALUE USING 1011 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1100
    JSR     CODE_1100_AND       * CHECK FOR AND, ONLY VALUE USING 0011 AS FIRST 4 BITS
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1101
    JSR     CODE_1101_ADD       * CHECK FOR ADD, ONLY OPCODE USING 1101
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1110
    JSR     CODE_1110           * CHECK FOR DIFFERENT SHIFT CODES (LSL/ASL/LSR/ASR/ROL/ROR)
    JSR     COUNT_INC           * INCREASE COUNTS FOR CLEARING SCREEN AND TOTAL CODES  
    BRA     INC_LOOP            * CONTINUE LOOPING
CODE1111
    JSR PRINT_NOP_DATA          *PRINT ANY DATA AT THIS ADDRESS
    JSR GARBAGE_COUNT_INCREASE  *INCREMENT GARBAGE COUNT ONLY
    BRA     INC_LOOP            * CONTINUE LOOPING

COUNT_INC
    ADD.B   #1, SCREEN_COUNT    * SUCCESSFUL OPCODE FOUND. INC SCREEN BY 1
    ADD.L   #1, _TOTAL          * TOTAL OPCODES FOUND INC
    RTS
GARBAGE_COUNT_INCREASE
    ADD.B   #1, SCREEN_COUNT    * SUCCESSFUL OPCODE FOUND. INC SCREEN BY 1
    RTS

SCREEN_PAUSE 
    *LEA     PAUSE_MSG, A1
    *MOVE.B  #14, D0             * MOVE 14 FOR TASK 14, TRAP 15: PRINT A1, NO LF/CR
    *TRAP    #15                 * PAUSE UNTIL RETURN HIT
    
    MOVE.B  #2, D0              * MOVE 2 FOR TASK 2, TRAP 15: PAUSE UNTIL 'RETURN' HIT
    TRAP    #15                 * PAUSE UNTIL RETURN HIT

    MOVE.B  #11, D0             * MOVE 11 FOR TASK 11, TRAP 15: SPECIAL OPS USING D1
    MOVE.W  #$FF00, D1          * MOVE $FF00 INTO D1, WHEN TRAP 15 CALLED, CLR SCREEN
    TRAP    #15                 * CLEAR SCREEN
    
    MOVE.B  #0, SCREEN_COUNT    * RESET SCREEN_COUNT TIMER
    MOVEA.L  A1LOC, A1          * RESET A1  


    CLR.L   D1
    BRA     CONTINUE_LOOP

ALMOST_DONE

    MOVE.B  #2, D0              * MOVE 2 FOR TASK 2, TRAP 15: PAUSE UNTIL 'RETURN' HIT
    TRAP    #15                 * PAUSE UNTIL RETURN HIT

    MOVE.B  #11, D0             * MOVE 11 FOR TASK 11, TRAP 15: SPECIAL OPS USING D1
    MOVE.W  #$FF00, D1          * MOVE $FF00 INTO D1, WHEN TRAP 15 CALLED, CLR SCREEN
    TRAP    #15                 * CLEAR SCREEN

SIM_END
    MOVE.B  #11, D0             * MOVE 11 FOR TASK 11, TRAP 15: SPECIAL OPS USING D1
    MOVE.W  #$FF00, D1          * MOVE $FF00 INTO D1, WHEN TRAP 15 CALLED, CLR SCREEN
    TRAP    #15                 * CLEAR SCREEN
      
    LEA     END_MSG, A1         *OP CODES FOUND
    MOVE.B  #14, D0             * MOVE 14 FOR TASK 14, TRAP 15: PRINT A1, NO LF/CR
    TRAP    #15
    
    MOVE.L  A1LOC,A1      *SET A1 TO USER_INPUT 
    CLR.W   D1
    MOVE.L  _TOTAL, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA     LOOP_MSG, A1
    MOVE.B  #14, D0             * MOVE 14 FOR TASK 14, TRAP 15: PRINT A1, NO LF/CR
    TRAP    #15
    
    MOVE.L  A1LOC,A1      *SET A1 TO USER_INPUT 
    MOVE.B  #2, D0              * Task 2 for Trap 15, Read in String
    TRAP    #15                 * Get User input
    
    CMP.B   #$79,(A1)             *COMPARE DATA AT A1 TO y
    BEQ START
    CMP.B   #$59,(A1)             *COMPARE DATA AT A1 TO Y
    BEQ START   
    
    *MOVE.B  #2, D0              * MOVE 2 FOR TASK 2, TRAP 15: PAUSE UNTIL 'RETURN' HIT
    *TRAP    #15                 * PAUSE UNTIL RETURN HIT

    SIMHALT             ; halt simulator
CR      EQU $0D             ;ASCII code for Carriage Return
LF      EQU $0A             ;ASCII code for Line Feed
PAUSE_MSG   DC.B CR,'PRESS ENTER TO CONTINUE' ,0
END_MSG     DC.B CR,'TOTAL OPCODES FOUND: ',0
LOOP_MSG    DC.B CR,LF,'ENTER Y TO LOOP AGAIN: ',0

    END    START        ; last line of source




























































<<<<<<< Updated upstream




=======
>>>>>>> Stashed changes


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
