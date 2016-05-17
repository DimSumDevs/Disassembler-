*-----------------------------------------------------------
* Title      :  ABS_DECODE
* Written by :  TYLER QUAYLE
* Date       :  MAY 5, 2016
* Description:  GET ABS ADDRESS AND LOAD INTO A1
*-----------------------------------------------------------
   
    ORG    ABS_DECODE
ABS_START
    CLR.L       D3                  * LONG CLEAR D3, USED TO CONVERT/ FIND LEADING ZERO
    CLR.L       D4                  * LONG CLEAR D4, USED TO FIND LEADING ZERO
    MOVE.B      #$24, (A1)+         * MOVE '$' INTO A1 AND INC
    ADD.W       #1, D1              * INC CHAR COUNT
    ADDA.L      #2, A4              * MOVE A4 CURRENT ADDRESS BY 2, TO GET VALUE AFTER OPCODE
    MOVE.B      #0, D2              * D2 USED IN FOR LOOP(I) SET TO ZERO
    CMP.B       #0, D5              * CHECK FOR (XXX).W
    BEQ         ABS_SHORT           * IS SHORT, GO TO ABS_SHORT
    CMP.B       #1, D5              * CHECK FOR (XXX).L
    BEQ         ABS_LONG            * IS LONG, GO TO ABS_LONG
    BRA         ABS_END             * ERR: LEAVE

ABS_SHORT
    MOVE.B      #2, FOR_ABS         * FOR(d2=0, d2 < 2, d2++)
    BRA         ABS_LOOP
ABS_LONG
    MOVE.B      #4, FOR_ABS         * FOR(d2=0, d2 < 2, d2++)
    BRA         ABS_LOOP

ABS_LOOP
    CMP.B       FOR_ABS,D2          * D2 < FOR_ABS VALUE
    BEQ         ABS_END             * FOR LOOP DONE, EXIT
    ADD.B       #1, D2              * D2++
    MOVE.B      (A4), D3            * GIVE D3 VALUE IN CURRENT A4 ADDRESS
    LSR.B       #4, D3              * NNNNXXXX -> 0000NNNN WHERE NNNN IS 4-BIT CHAR
    MOVE.B      D3, _CONVERT        * LOAD D3 INTO _CONVERT (CONVERT_HEX_ASCII)
    ADD.L       D3, D4              * IF D4 != 0 AT ANY TIME, NO MORE LEADING ZERO
    JSR         CONVERT_HEX_ASCII   * CONVERT HEX VALUE AT A4 AND CONVERT TO ASCII-HEX
    MOVE.B      (A4)+, D3           * GIVE D3 THEN INCREMENT TO A4+1
    LSL.B       #4, D3              * XXXXNNNN -> NNNN0000 WHERE NNNN IS 4-BIT CHAR
    LSR.B       #4, D3              * NNNN0000 -> 0000NNNN WHERE NNNN IS 4-BIT CHAR
    MOVE.B      D3, _CONVERT        * LOAD D3 INTO _CONVERT (CONVERT_HEX_ASCII)
    ADD.L       D3, D4              * IF D4 != 0 AT ANY TIME, NO MORE LEADING ZERO
    JSR         CONVERT_HEX_ASCII   * CONVERT HEX VALUE AT A4 AND CONVERT TO ASCII-HEX
    BRA         ABS_LOOP            * RESTART LOOP
 
ABS_END
    SUBA.L      #2,A4               * ACCOUNT FOR OPCODE OFFSET
    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
