*-----------------------------------------------------------
* Title      :  DEC_MAIN
* Written by :  TYLER QUAYLE
* Date       :  MAY 5, 2016
* Description:  GO TO DECODE_SORT, THEN TESTS IF BOTH SOURCE/DEST ARE GIVEN
*-----------------------------------------------------------
    * D4 -> SOURCE_MODE
    * D5 -> SOURCE_REG
    * D6 -> DEST_MODE
    * D7 -> DEST_REG
    * D3 -> SIZE
    ORG    DECODE_MAIN
DEC_START
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[5]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      SOURCE_MODE,D4
    MOVE.B      SOURCE_REG, D5
    JSR         DECODE_SORT     * DECODE SOURCE
    CMP.B       #8, DEST_REG    * CHECK IF DEST_REG CONTAINS VALID REGISTER (0-7)
    BGE         DEC_END         * INVALID REGISTER FOUND
    CMP.B       #7, DEST_MODE   * REG IS VALID, CHECK TO SEE IF IT'S 7 (ABS/IMM)
    BEQ         IM_OR_ABS_CHECK * IS SAID, FIND OUT WHICH REG/IMM
    BRA         OTHER_ADDR
    
OTHER_ADDR
    MOVE.B      #$2C, (A1)+     * LOAD ',' INTO A1[8]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[9]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      DEST_MODE, D4
    MOVE.B      DEST_REG, D5
    JSR         DECODE_SORT
    BRA         DEC_END

IM_OR_ABS_CHECK
    MOVE.B      #$2C, (A1)+     * LOAD ',' INTO A1[8]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[9]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      DEST_MODE, D4
    MOVE.B      DEST_REG, D5
    JSR         DECODE_SORT
    BRA         DEC_END

DEC_END
    MOVE.B  #30, DEST_MODE              
    MOVE.B  #30, DEST_REG
    RTS















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
