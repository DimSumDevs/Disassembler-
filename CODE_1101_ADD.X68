*-----------------------------------------------------------
* Title      :  CODE_1000_OR
* Written by :  TYLER QUAYLE
* Date       :  5/15/2016
* Description:
*-----------------------------------------------------------
    ORG    CODE_1101_ADD
    
    CLR.W       D1              * RESET CHAR COUNT
    
    MOVE.W      (A4),D3
    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
    MOVE.B      D3,_SIZE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L  
    
    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    CMP.B       #0, _SIZE
    BEQ         ADD_BYTE
    
    CMP.B       #1, _SIZE
    BEQ         ADD_WORD
    
    CMP.B       #2, _SIZE
    BEQ         ADD_LONG
    
ADD_BYTE
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE
ADD_WORD
    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE
ADD_LONG
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA         ADD_DECODE

ADD_DECODE  
    MOVE.W      (A4),D3
    BTST.L      #8, D3
    BNE         ADD_DN_SOURCE
    
ADD_EA_SOURCE    
    MOVE.B      #0,DEST_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG   * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE
    BRA         LOAD_TO_PRINT_ADD
    
ADD_DN_SOURCE    
    MOVE.B      #0,SOURCE_MODE  * FOR SOURCE MODE
    MOVE.W      (A4),D3
    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG
    
    MOVE.W      (A4),D3    
    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
    MOVE.B      D3,DEST_REG   * FOR SOURCE REG    

    MOVE.W      (A4),D3    
    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
    MOVE.B      D3,DEST_MODE  * FOR SOURCE MODE
    
    
LOAD_TO_PRINT_ADD
    JSR         DECODE_MAIN 
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN



**-----------------------------------------------------------
** Title      :ADD
** Written by :Fuli Lan
** Date       :05/11/2016
** Description:The different between ADDA ADD ADD is the 8th bit ADD 7th bit always 11. 
** however, the ADD only 00, 01, 10. Depend on 7th bit ADD 8th bit, we can decide 
** ADDA or ADD.
**-----------------------------------------------------------
*    ORG    CODE_1101_ADD
*    
*ADD_START
*    CLR.W       D1              * RESET CHAR COUNT
*    
*    MOVE.W      (A4),D3
*    LSR.B       #6, D3          * SSXXXXXX -> 000000SS
*    MOVE.B      D3,OPMODE        * MOVE 0 INTO SIZE FOR IMM_DECODE. 0=B, 1=W,2=L  
*    
******************** ADD.********************
*    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[0]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[1]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    MOVE.B      #$44, (A1)+     * LOAD 'D' INTO A1[2]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    
******************** CHECK SIZE***************
*
*OPMODE
*    CMP.B       #0, OPMODE
*    BEQ         ADD_BYTE
*    
*    CMP.B       #1, OPMODE
*    BEQ         ADD_WORD
*    
*    CMP.B       #2, OPMODE
*    BEQ         ADD_LONG 
*    
*ADD_BYTE
*    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[4]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    BRA         ADD_DECODE
*ADD_WORD
*    MOVE.B      #$57, (A1)+     * LOAD 'W' INTO A1[4]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    BRA         ADD_DECODE
*ADD_LONG
*    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[4]
*    ADD.W       #1, D1          * INC CHAR COUNT
*    BRA         ADD_DECODE
*
*    
******************** TEST 8TH BIT************
*ADD_DECODE  
*    MOVE.W      (A4),D3
*    BTST.L      #8, D3
*    BNE         ADD_DN_SOURCE
*
*ADD_EA_SOURCE    
*    MOVE.B      #0,DEST_MODE    * FOR SOURCE MODE
*    MOVE.W      (A4),D3
*    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
*    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
*    MOVE.B      D3,DEST_REG   * FOR SOURCE REG
*    
*    MOVE.W      (A4),D3    
*    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
*    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
*    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG    
*
*    MOVE.W      (A4),D3    
*    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
*    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
*    MOVE.B      D3,SOURCE_MODE  * FOR SOURCE MODE
*    BRA         LOAD_TO_PRINT_ADD
*    
*ADD_DN_SOURCE    
*    MOVE.B      #0,SOURCE_MODE  * FOR SOURCE MODE
*    MOVE.W      (A4),D3
*    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX -> RRRXXXXX WHERE RRR IS DEST REG
*    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR WHERE RRR IS DEST REG
*    MOVE.B      D3,SOURCE_REG   * FOR SOURCE REG
*    
*    MOVE.W      (A4),D3    
*    LSL.B       #5, D3          * XXXXXRRR -> RRR00000 WHERE RRR IS DEST REG
*    LSR.B       #5, D3          * RRR00000 -> 00000RRR WHERE RRR IS DEST REG
*    MOVE.B      D3,DEST_REG   * FOR SOURCE REG    
*
*    MOVE.W      (A4),D3    
*    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00 WHERE MMM IS DEST MODE
*    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM WHERE MMM IS DEST MODE
*    MOVE.B      D3,DEST_MODE    * FOR SOURCE MODE
*    
*    
*LOAD_TO_PRINT_ADD
*    JSR         DECODE_MAIN 
*    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
*    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
*    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
*    RTS                         * GO BACK TO MAIN
* 
**    MOVE.W      (A4),D3   
**    LSR.W       #4, D3          * XXXXRRRXXXXXXXXX-> 0000XXXXRRRXXXXX
**    LSR.B       #5, D3          * RRRXXXXX -> 00000RRR
**    MOVE.B      D3,SOURCE_REG   * FOR SOURCE_REG
**    
**    MOVE.W      (A4),D3        * SOURCE MODE
**    LSL.B       #2, D3          * XXMMMXXX -> MMMXXX00
**    LSR.B       #5, D3          * MMMXXX00 -> 00000MMM
**    MOVE.B      D3, DEST_MODE   * GET DEST MODE
**    
**    MOVE.W      (A4),D3        * DEST_REG
**    LSL.B       #5, D3          * XXXXXRRR -> RRR00000
**    LSR.B       #5, D3          * RRR00000 -> 00000RRR
**    MOVE.B      D3, DEST_REG    * GET THE DEST_REG
**       
**
**    
**    MOVE.W      (A4),D3         * Decide ADDA or ADD
**    LSR.B       #6, D3          * AAXXXXXX -> 000000AA          
**    CMP.B       #3, D3          * Compare AA with binary number 11-->decimal 3
**    BEQ         ADD_A             * If not equal, branch to ADD  
**     
**
**
**
**    MOVE.W      (A4),D3         * Get OPMODE
**    LSR.W       #1, D3          * XXXXXXXPXXXXXXXX -> 0XXXXXXXPXXXXXXX
**    LSR.B       #7, D3          * PXXXXXXX-> 0000000P
**    MOVE.B      D3, OPMODE_ADD  * GET THE OPMODE
**    
**ADD_A
**    MOVE.B      #$41, (A1)+     * LOAD 'A' INTO A1[3]
**    ADD.W       #1, D1          * INC CHAR COUNT
**     
**    MOVE.B      #$2E, (A1)+     * LOAD '.' INTO A1[3]
**    ADD.W       #1, D1          * INC CHAR COUNT
**
**    MOVE.W      (A4),D3         * Get OPMODE
**    LSR.W       #1, D3          * XXXXXXXPXXXXXXXX -> 0XXXXXXXPXXXXXXX
**    LSR.B       #7, D3          * PXXXXXXX-> 0000000P
**    MOVE.B      D3, OPMODE_ADDA  * GET THE OPMODE
**    
**OPMODE_ADDA
**    CMP.B       #0, OPMODE   * WORD
**    BEQ         ADD_WORD
**    
**    CMP.B       #1, OPMODE   * LONG
**    BEQ         ADD_LONG
**  
**    
**OPMODE_ADD
**    CMP.B       #0, OPMODE_EA   * ADD <EA>, Dn
**    BEQ         CMP
**    
**    CMP.B       #1, OPMODE_DN   * ADD Dn, <EA>
**    BEQ         CMP
**    
**CMP
**    MOVE.W      (A4),D3         
**    LSR.W       #1, D3          * XXXXXXXXPPXXXXXX -> 0XXXXXXXXPPXXXXX
**    LSR.B       #6, D3          * PPXXXXXX-> 000000PP
**    MOVE.B      D3, OPMODE
**    
**
** 
**
**ADD_DECODE
**    JSR         DECODE_MAIN 
**
**LOAD_TO_PRINT_ADD
**    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
**    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
**    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
**    RTS                         * GO BACK TO MAIN
**    
*
*
*
*
*
*
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
