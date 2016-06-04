*-----------------------------------------------------------
* Title      : CODE_1110
* Written by : TYLER QUAYLE
* Date       : MAY 3, 2016
* Description: Decodes LSL,ASL,LSR,ASR,ROL,ROR
*-----------------------------------------------------------
    * PAGE 218 -> LSL/ASR
    * PAGE 125 -> ASL/ASR
    * PAGE 264 -> ROL/ROR

* A S L . W _ D 3 , _ D 3
* 0 1 2 3 4 5 6 7 8 9 A B


    ORG CODE_1110
    CLR.W       D1              * RESET CHAR COUNT
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    MOVE.W      (A4),D4         * Give D4 value at A4
    
    BTST.L      #3, D4          * Test Bit 3, if 1, its Logical, otherwise Arithmatic
    BNE         LOG_OR_ROLL     * BNE to LOG_OR_ROLL. Bit 3 was 1
    BRA         ARITHMETIC      * Bit 3 was 0, go to ARITHMETIC
LOG_OR_ROLL
    BTST.L      #4, D4          * Test Bit 3, if 1, its Logical, otherwise Arithmatic
    BNE         ROLL            * BNE to Logical. Bit 3 was 1
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$53, (A1)+     * LOAD 'S' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CHECK_DIR       * Go to Check_Dir, to see if its LSL or LSR
ARITHMETIC
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$53, (A1)+     * LOAD 'S' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CHECK_DIR       * Go to CHECK_DIR, to see if its ASL or ASR
ROLL
    MOVE.B      #$52, (A1)+     * LOAD 'R' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4F, (A1)+     * LOAD '0' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
********************************************************************************************
CHECK_DIR
    BTST.L      #8, D4          * Test Bit 8, 1 = Left, 0 = Right
    BNE         SHIFT_LEFT      * Bit 8 was 1, goto SHIFT_LEFT
    BRA         SHIFT_RIGHT     * Bit 8 was 0, goto SHIFT_RIGHT
SHIFT_LEFT
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         GET_SIZE        * Go To GET_SIZE
SHIFT_RIGHT
    MOVE.B      #$52, (A1)+     * LOAD 'R' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         GET_SIZE        * Go To GET_SIZE
********************************************************************************************
GET_SIZE
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    LSR.B       #6, D4          * Logic Shift right D4, getting 000000XX where XX is size
    CMP.B       #0,D4           * Compare D4 to 0
    BEQ         SIZE_BYTE       * D4 is 0, go to SIZE_BYTE
    CMP.B       #1,D4           * Compare D4 to 1
    BEQ         SIZE_WORD       * D4 is 1, go to SIZE_WORD
    BRA         SIZE_LONG       * D4 is 2, go to SIZE_LONG
SIZE_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CHECK_C_R       * Go to CHECK_C_R (check count or register)
SIZE_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CHECK_C_R       * Go to CHECK_C_R (check count or register)
SIZE_LONG 
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         CHECK_C_R       * Go to CHECK_C_R (check count or register)
********************************************************************************************
CHECK_C_R
    MOVE.W      #4, _SPACES
    JSR         ADD_SPACES
    
    MOVE.B      #$20, (A1)+    * LOAD ' ' INTO A1[5]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.W      (A4),D4         * Restore D4 to value at A5
    MOVE.W      (A4),D5         * Restore D4 to value at A5
    LSL.W       #4, D5          * Logic shift left 4 bits, getting CCCXXXXXXXXXX0000 where CCC is count or register
    MOVE.B      #13, D2         * Move 13 into D2, used for LSR
    LSR.W       D2, D5          * Logic shift right 13 bits, getting 0000000000000CCC where CCC is count or register
    BTST.L      #5, D4          * Test bit 5, if 1 11-9 is Register, else count
    BNE         REGISTER        * Bit 5 was 1, goto REGISTER
    BRA         COUNT           * Bit 5 was 0, goto COUNT
REGISTER
    MOVE.B      #0, D4
    JSR         DECODE_SORT     * DECODE ADDRESS
    BRA         DEST_REGISTER   * Go to DEST_REGISTER
COUNT
    MOVE.B      #$23, (A1)+     * LOAD '#' INTO A1[6]
    ADD.W       #1, D1          * INC CHAR COUNT

    ADD.W       #$30, D5        * Add $30 to D4, giving ASCII hex value of any number
    MOVE.B      D5,  (A1)+      * LOAD 'number' INTO A1[7]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         DEST_REGISTER   * Go to DEST_REGISTER   
********************************************************************************************
DEST_REGISTER
    MOVE.B      #$2C, (A1)+     * LOAD ',' INTO A1[8]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[9]
    ADD.W       #1, D1          * INC CHAR COUNT

    MOVE.W      (A4),D5         * Restore D4 to value at A5    
    MOVE.W      #0, D4          * MOVE 0 INTO D4 (for decode_ea, 0 = D)
    LSL.B       #5, D5          * XXXXXRRR -> RRR00000 WHERE RRR IS REGISTER
    LSR.B       #5, D5          * RRR00000 -> 00000RRR WHERE RRR IS REGISTER
    JSR         DECODE_SORT     * DECODE ADDRESS           

********************************************************************************************
LOAD_TO_PRINT
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
