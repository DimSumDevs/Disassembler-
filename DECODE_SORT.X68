*-----------------------------------------------------------
* Title      :  DECODE_SORT
* Written by :  TYLER QUAYLE
* Date       :  MAY 4, 2016
* Description:  DECODE EVERYTING BUT IMM/ABS
*-----------------------------------------------------------
    * A1 -> POINTING AT CURRENT INDEX
    * D5 -> CONTAINS REGISTER 
    * D4 -> CONTAINS MODE
    ORG         DECODE_SORT

    
    CMP.B       #0, D4           *Dn
    BEQ         DATA_REG
    
    CMP.B       #1, D4           *An
    BEQ         ADDR_REG
    
    CMP.B       #2, D4           *(An)
    BEQ         DIR_ADDR
    
    CMP.B       #3, D4           *(An)+
    BEQ         INCR_ADDR
    
    CMP.B       #4, D4           *-(An)
    BEQ         DECR_ADDR
    
    CMP.B       #5, D4           *(D16,An)
    BEQ         DIS_ADDR
    
    CMP.B       #6, D4           *(D8,An,Xn)
    BEQ         INDEX
    
    CMP.B       #7, D4           *(xxx).W or (xxx).L or #iiii
    BEQ         ABS_OR_IMM
    
    BRA         EA_END

ABS_OR_IMM
    CMP.B       #0, D5          * CHECK FOR (XXX).W
    BEQ         IS_ABS      * IS SHORT, GO TO ABS_SHORT
    CMP.B       #1, D5          * CHECK FOR (XXX).L
    BEQ         IS_ABS        * IS LONG, GO TO ABS_LONG
    CMP.B       #4, D5          * CHECK FOR #imm
    BEQ         IMME
    BRA         EA_END
IS_ABS
    JSR         ABS_DECODE
    RTS

IMME
    JSR         IMM_DECODE
    RTS
DATA_REG
    MOVE.B      #$44, (A1)+     *MOVE 'D' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    JSR         GET_NUM
    BRA         EA_END
ADDR_REG
    MOVE.B      #$41, (A1)+     *MOVE 'A' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    JSR         GET_NUM
    BRA         EA_END
DIR_ADDR
    MOVE.B      #$28, (A1)+     *MOVE '(' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    MOVE.B      #$41, (A1)+     *MOVE 'A' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    JSR         GET_NUM
    MOVE.B      #$29, (A1)+     *MOVE ')' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    BRA         EA_END
INCR_ADDR
    MOVE.B      #$28, (A1)+     *MOVE '(' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    MOVE.B      #$41, (A1)+     *MOVE 'A' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    JSR         GET_NUM
    MOVE.B      #$29, (A1)+     *MOVE ')' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    MOVE.B      #$2B, (A1)+     *MOVE '+' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    BRA         EA_END
DECR_ADDR
    MOVE.B      #$2D, (A1)+     *MOVE '-' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    MOVE.B      #$28, (A1)+     *MOVE '(' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    MOVE.B      #$41, (A1)+     *MOVE 'A' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    JSR         GET_NUM
    MOVE.B      #$29, (A1)+     *MOVE ')' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    BRA         EA_END

DIS_ADDR
    BRA BAD_EA
INDEX
    BRA BAD_EA

GET_NUM
    ADD.W       #$30, D5        * Add $30 to D4, giving ASCII hex value of any number
    MOVE.B      D5,  (A1)+      * LOAD 'number' INTO A1 AND INC
    ADD.W       #1, D1          *INC CHAR COUNT
    RTS

EA_END
    RTS
    

BAD_EA
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    JSR PRINT_NOP_DATA
    RTS















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
