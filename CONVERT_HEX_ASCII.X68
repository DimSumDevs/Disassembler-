*-----------------------------------------------------------
* Title      :  CONVERT HEX->ASCII
* Written by :  TYLER QUAYLE
* Date       :  MAY 6, 2016
* Description:  CONVERT HEX TO ASCII
*-----------------------------------------------------------
    ORG    CONVERT_HEX_ASCII

HEX_TO_ASCII
    MOVE.B      _CONVERT, D3
    CMP.L       #0, D4          * IF AT ANY POINT IN ABS/IMM_DECODE ADD.L D4 RESULTED IN D4 != 0, NO MORE LEADING ZEROS
    BEQ         LEADING_ZERO    * LEADING ZEROS STILL, RETURN
    CMP.B       #10, D3         * IF VALUE OF HEX IS GREATER OR EQUAL TO 10(A)
    BGE         HTA_LETTER      * VALUE IS #10-15, CONVERT LETTER
    BRA         HTA_NUM         * VALUE IS #0-9, CONVERT NUMBER

HTA_LETTER
    ADD.W       #$37, D3        * ADD #$37 TO D3, TO GET ASCII-HEX LETTER VALUE
    MOVE.B      D3, (A1)+       * ADD ASCII-HEX CHAR(A-F) TO A1, INCREMENT A1
    ADD.W       #1, D1          * INC CHAR COUNT 
    RTS
HTA_NUM
    ADD.W       #$30, D3        * ADD #$30 TO D3, TO GET ASCII-HEX NUMBER VALUE
    MOVE.B      D3, (A1)+       * ADD ASCII-HEX CHAR(0-9) TO A1, INCREMENT A1
    ADD.W       #1, D1          * INC CHAR COUNT 
    RTS                         * GO BACK TO ABS_LOOP

LEADING_ZERO
    RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
