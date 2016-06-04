*-----------------------------------------------------------
* Title      :  ADD_SPACES
* Written by :  TYLER QUAYLE
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    ADD_SPACES
*    MOVE.W      #7, _SPACES
*    JSR         ADD_SPACES
SPACE_LOOP
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    
    SUB.W       #1, _SPACES
    CMP.B       #0, _SPACES
    BEQ         END_SPACE_LOOP
    BRA         SPACE_LOOP

END_SPACE_LOOP
    CLR.W       _SPACES
    RTS
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
