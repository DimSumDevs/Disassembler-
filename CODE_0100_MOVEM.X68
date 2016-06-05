*-----------------------------------------------------------
* Title      :CODE_0100_MOVEM
* Written by :Michael Ritchie
* Date       :5/14
* Description: Print MOVEM and decode register mask
*-----------------------------------------------------------
    ORG    CODE_0100_MOVEM
    * _SIZE (0 = word, 1 = long)
    * D4 -> EA_MODE
    * D5 -> EA_REG
    * D6 -> DIRECTION (1 = MEMORY TO REGISTER)
    * D7 -> MASK 
MOVEM_START:                  ; first instruction of program

    CLR.W D1                    *clear char count at d1
    JSR     PRINT_MEMORY_ADDRESS *PRINT THE MEMORY ADDRESS OF THE OPCODE
    
* put MOVE.M into A1
    MOVE.B      #$4D, (A1)+     * LOAD 'M' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4F, (A1)+     * LOAD 'O' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$56, (A1)+     * LOAD 'V' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$45, (A1)+     * LOAD 'E' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4D, (A1)+     *lOAD 'M' INTO A1[4]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    
*use A4 to get size, register, mode, and direction
    MOVE.W  (A4),D6             *load op_code into d6 to get bit 10 for direction
    LSR.W   #3,D6               *shift right 3 bits to get direction bit to be the uppermost bit
    LSR.B   #7,D6               *shift right 7 bits, now D2.B = direction bit
    
    MOVE.W  (A4),D3             *load op_code into d3 to get bit 6 for size
    LSL.B   #1,D3               *shift 1 bit left to clear upper bits
    LSR.B   #7,D3               *shift 7 bits right, now D3.B = size bit
    MOVE.B  D3,_SIZE            *MOVE SIZE FROM D3 INTO VARIABLE

    MOVE.W  (A4),D4             *load op_code into D4 to get ea_mode XXCCCXXX
    LSL.B   #2,D4               *shift left 2 bits to get CCCXXX00
    LSR.B   #5,D4               *shift right 5 bits to get 00000CCC
    MOVE.W  D4, SOURCE_MODE
    
    MOVE.W  (A4),D5             *load op_code int D5 to get ea_register XXXXXCCC
    LSL.B   #5,D5               *shift left 5 bits to get CCC00000
    LSR.B   #5,D5               *shift right 5 bits to get 00000CCC
    MOVE.W  D5, SOURCE_REG
    
*get the mask from memory and load it into D7
    ADDA.L  #2,A4
    MOVE.W  (A4),D7
    
*use size bit to add '.', 'W' or 'L', and ' ' to A1
    MOVE.B      #$2E,(A1)+      *LOAD '.' INTO A1[5]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    CMP.B       #0, D3          *compare 0 to size bit
    BEQ SIZE_W                  *branch to size_w
    
    CMP.B       #1, D3          *compare 1 to size bit
    BEQ SIZE_L
    
SIZE_L
    MOVE.B      #$4C,(A1)+      *LOAD 'L' INTO A1[6]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA SPACE
    
    
SIZE_W
    MOVE.B      #$57,(A1)+      *LOAD 'W' INTO A1[6]
    ADD.W       #1, D1          * INC CHAR COUNT
    BRA SPACE
 
SPACE
    MOVE.B      #$20,(A1)+      *LOAD ' ' INTO A1[7]
    ADD.W       #1, D1          * INC CHAR COUNT
    
    MOVE.W      #2, _SPACES
    JSR         ADD_SPACES
    
 
    CMP.B       #1,D6           *COMPARE DIRECTION BIT TO 1
    BEQ MEM_TO_REG
    
    CMP.B       #0,D6           *COMPARE DIRECTION BIT TO 0
    BEQ REG_TO_MEM
    
MEM_TO_REG
    JSR DECODE_SORT             *JUMP INTO DECODE_SORT
    
    MOVE.B      #$2C, (A1)+     *LOAD ',' INTO A1
    ADD.W       #1,D1            INC CHAR COUNT
    
    JSR DECODE_MASK             *JUMP INTO DECODE_MASK
    BRA LOAD_TO_PRINT_MOVEM     

REG_TO_MEM
    JSR DECODE_MASK             *JUMP INTO DECODE_MASK
    
    MOVE.B      #$2C, (A1)+     *LOAD ',' INTO A1
    ADD.W       #1,D1           * INC CHAR COUNT

    JSR DECODE_SORT             *JUMP INTO DECODE_SORT
    BRA LOAD_TO_PRINT_MOVEM    
 
LOAD_TO_PRINT_MOVEM
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN


*SUBROUTINE FOR DECODING THE MASK, MAYBE BETTER TO PUT THIS INTO SPERATE FILE
DECODE_MASK
    CMP.B   #%100,D4            *COMPARE %100 TO MODE, CHECKING FOR PRE-DECREMENT
    BEQ PRE_DECREMENT
    
DLP_SETUP 
    CLR.W   D2                  *CLEAR D2 FOR COUNTER
    MOVE.W  #-1,D2
DATA_LOOP_PLUS
    CMP.W   #7,D2               *COMPARE COUNTER TO 7
    BEQ ALP_SETUP       *LOOP IS DONE, GO TO NEXT ONE
    ADD.W   #1,D2               *INCREMENT COUNTER
    LSR.W   #1,D7               *SHIFT MASK RIGHT 1 BIT
    BCC DATA_LOOP_PLUS          *BIT SHIFTED WAS 0, SO PRINT NOTHING AND LOOP AGAIN
    
    MOVE.B  #$44,(A1)+          *LOAD 'D' INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    
    CLR.W   D3                  *NEED D3 FOR CALCULATION
    MOVE.B  D2,D3               *MOVE ITERATION NUMBER INTO D3
    ADD.B   #$30,D3             *ADD 30 TO GET ASCII FOR REGISTER NUMBER
    
    MOVE.B  D3,(A1)+            *LOAD REGISTER NUMBER INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    MOVE.B      #$2F, (A1)+     *LOAD '/' INTO A1
    ADD.W       #1,D1           * INC CHAR COUNT
    
    BRA DATA_LOOP_PLUS          *GO BACK TO TOP OF LOOP

ALP_SETUP
    CLR.W   D2                  *CLEAR D2 FOR COUNTER
    MOVE.W  #-1,D2
ADDRESS_LOOP_PLUS
    CMP.W   #7,D2               *COMPARE COUNTER TO 7
    BEQ MASK_RTS                *BOTH LOOPS DONE, GOTO RETURN
    ADD.W   #1,D2               *INCREMENT COUNTER
    LSR.W   #1,D7               *SHIFT MASK RIGHT 1 BIT
    BCC ADDRESS_LOOP_PLUS       *BIT SHIFTED WAS 0, SO PRINT NOTHING AND LOOP AGAIN
    
    MOVE.B #$41,(A1)+           *LOAD 'A' INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    
    CLR.W   D3                  *NEED D3 FOR CALCULATION
    MOVE.B  D2,D3               *MOVE ITERATION NUMBER INTO D3
    ADD.B   #$30,D3             *ADD 30 TO GET ASCII FOR REGISTER NUMBER
    
    MOVE.B  D3,(A1)+            *LOAD REGISTER NUMBER INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    MOVE.B      #$2F, (A1)+     *LOAD '/' INTO A1
    ADD.W       #1,D1           * INC CHAR COUNT
    
    BRA ADDRESS_LOOP_PLUS        *GO BACK TO TOP OF LOOP
    
PRE_DECREMENT
    
ALM_SETUP
    CLR.W   D2                  *CLEAR D2 FOR COUNTER
    MOVE.W #8,D2                *SET D2 TO 7
ADDRESS_LOOP_MINUS
    CMP.W   #0,D2               *COMPARE COUNTER TO 0
    BEQ DLM_SETUP               *LOOP DONE, GOTO DATA LOOP MINUS
    SUB.W   #1,D2               *DECCREMENT COUNTER
    LSR.W   #1,D7               *SHIFT MASK RIGHT 1 BIT
    BCC ADDRESS_LOOP_MINUS       *BIT SHIFTED WAS 0, SO PRINT NOTHING AND LOOP AGAIN
    
    MOVE.B #$41,(A1)+           *LOAD 'A' INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    
    CLR.W   D3                  *NEED D3 FOR CALCULATION
    MOVE.B  D2,D3               *MOVE ITERATION NUMBER INTO D3
    ADD.B   #$30,D3             *ADD 30 TO GET ASCII FOR REGISTER NUMBER
    
    MOVE.B  D3,(A1)+            *LOAD REGISTER NUMBER INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    MOVE.B      #$2F, (A1)+     *LOAD '/' INTO A1
    ADD.W       #1,D1           * INC CHAR COUNT
    
    BRA ADDRESS_LOOP_MINUS        *GO BACK TO TOP OF LOOP
    
DLM_SETUP 
    CLR.W   D2                  *CLEAR D2 FOR COUNTER
    MOVE.W  #8,D2
DATA_LOOP_MINUS
    CMP.W   #0,D2               *COMPARE COUNTER TO 7
    BEQ MASK_RTS                *BOTH LOOPS DONE, GOTO RETURN
    SUB.W   #1,D2               *DECCREMENT COUNTER
    LSR.W   #1,D7               *SHIFT MASK RIGHT 1 BIT
    BCC DATA_LOOP_MINUS         *BIT SHIFTED WAS 0, SO PRINT NOTHING AND LOOP AGAIN
    
    MOVE.B  #$44,(A1)+          *LOAD 'D' INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    
    CLR.W   D3                  *NEED D3 FOR CALCULATION
    MOVE.B  D2,D3               *MOVE ITERATION NUMBER INTO D3
    ADD.B   #$30,D3             *ADD 30 TO GET ASCII FOR REGISTER NUMBER
    
    MOVE.B  D3,(A1)+            *LOAD REGISTER NUMBER INTO A1
    ADD.W   #1,D1               * INC CHAR COUNT
    MOVE.B      #$2F, (A1)+     *LOAD '/' INTO A1
    ADD.W       #1,D1           * INC CHAR COUNT
    
    BRA DATA_LOOP_MINUS          *GO BACK TO TOP OF LOOP

MASK_RTS
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
