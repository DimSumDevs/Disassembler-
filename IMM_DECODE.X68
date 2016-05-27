*-----------------------------------------------------------
* Title      :  IMM_DECODE
* Written by :  TYLER QUAYLE
* Date       :  MAY 5, 2016
* Description:  
*-----------------------------------------------------------
    * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L
    * IF _SIZE = 0 -> BYTE SIZE
    * IF _SIZE = 1 -> WORD SIZE
    * IF _SIZE = 2 -> LONG SIZE
    ORG    IMM_DECODE
IMM_START
    CLR.L       D3                  * LONG CLEAR D3, USED TO CONVERT/ FIND LEADING ZERO
    CLR.L       D4                  * LONG CLEAR D4, USED TO FIND LEADING ZERO
    MOVE.B      #$23, (A1)+         * MOVE '#' INTO A1 AND INC
    ADD.W       #1, D1              * INC CHAR COUNT
    MOVE.B      #$24, (A1)+         * MOVE '$' INTO A1 AND INC
    ADD.W       #1, D1              * INC CHAR COUNT
    ADDA.L      #2, A4              * MOVE A4 CURRENT ADDRESS BY 2, TO GET VALUE AFTER OPCODE
    MOVE.B      #0, D2              * D2 USED IN FOR LOOP(I) SET TO ZERO
    CMP.B       #0, _SIZE           * CHECK IF SIZE IS BYTE(0)
    BEQ         IMM_BYTE            * IS SHORT, GO TO ABS_SHORT
    CMP.B       #1, _SIZE           * CHECK IF SIZE IS WORD(1)
    BEQ         IMM_WORD            * IS LONG, GO TO ABS_LONG
    CMP.B       #1, _SIZE           * CHECK IF SIZE IS WORD(1)
    BEQ         IMM_WORD            * IS LONG, GO TO ABS_LONG
    BRA         IMM_LONG            * ERR: LEAVE

IMM_BYTE
IMM_WORD
    MOVE.B      #2, FOR_ABS         * FOR(d2=0, d2 < 2, d2++)
    BRA         IMM_LOOP
IMM_LONG
    MOVE.B      #4, FOR_ABS         * FOR(d2=0, d2 < 2, d2++)
    BRA         IMM_LOOP

IMM_LOOP
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
 
IMM_END
    SUBA.L      #2,A4               * ACCOUNT FOR OPCODE OFFSET
    RTS                             * RETURN TO DECODE_SORT















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
