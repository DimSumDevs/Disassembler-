*-----------------------------------------------------------
* Title      : CODE_0110_BCC
* Written by : MICHAEL RITCHIE
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    CODE_0110_BCC
START_CODE_0110_BCC             ; first instruction of program


    CLR.W D1                    *clear char count at d1
*get the status nibble into D6
     MOVE.W  (A4),D6            *load op_code into d6 to get status XCXX
     LSL.W   #4,D6              *SHIFT LEFT 4 DIGITS XCXX ---> CXX0
     LSR.W   #8,D6             *SHIFT RIGHT 8 (MAXIMUM) DIGITS CXX0 ---> 00CX
     LSR.W   #4,D6              *SHIFT THE REMAINING 4 DIGITS 00CX ---> 000C
     
*branch to correct code based on status
CHOOSE_CODE
    CMP.B   #$4,D6               *COMPARE STATUS CODE TO D6
    BEQ BCC
    
    CMP.B   #$E,D6               *COMPARE STATUS CODE TO D6
    BEQ BGT
    
    CMP.B   #$F,D6               *COMPARE STATUS CODE TO D6
    BEQ BLE
    
    *NOT VALID OPCODE, SO RETURN
    BRA RETURN_BCC

BCC   
* put BCC into A1
    MOVE.B      #$42,(A1)+     * LOAD 'B' INTO A1[0]
    ADD.W       #1,D1          * INC CHAR COUNT
    MOVE.B      #$43,(A1)+     * LOAD 'C' INTO A1[1]
    ADD.B       #1,D1          * INC CHAR COUNT
    MOVE.B      #$43, (A1)+     * LOAD 'C' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$24,(A1)+       *LOAD '$' INTO A1[4]
    ADD.W       #1,D1           INC CHAR COUNT
    BRA GET_ADDRESS_DATA        *BRANCH TO GETTING DATA FOR CALCULATING ADDRESS

BGT
* put BGT into A1
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$47, (A1)+     * LOAD 'G' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$54, (A1)+     * LOAD 'T' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$24,(A1)+       *LOAD '$' INTO A1[4]
    ADD.W       #1,D1           INC CHAR COUNT
    BRA GET_ADDRESS_DATA        *BRANCH TO GETTING DATA FOR CALCULATING ADDRESS
BLE
* put BLE into A1
    MOVE.B      #$42, (A1)+     * LOAD 'B' INTO A1[0]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$4C, (A1)+     * LOAD 'L' INTO A1[1]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$45, (A1)+     * LOAD 'E' INTO A1[2]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$20, (A1)+     * LOAD ' ' INTO A1[3]
    ADD.W       #1, D1          * INC CHAR COUNT
    MOVE.B      #$24,(A1)+       *LOAD '$' INTO A1[4]
    ADD.W       #1,D1           INC CHAR COUNT
    BRA GET_ADDRESS_DATA        *BRANCH TO GETTING DATA FOR CALCULATING ADDRESS
    
GET_ADDRESS_DATA
*get the displacement into D5
    MOVE.W  (A4),D5             *LOAD LOWER BYTE OF OP_CODE INTO D5 TO GET DISPLACMENT
    
*if displacment is 00 get word displacment
    CMP.B #00,D5                  *COMPARE DISPLACMENT TO 00, INDICATING WORD DISPLACMENT
    BEQ WORD_DISPLACMENT
    
*if displacment is FF get long word displacment
    CMP.B #$FF,D5
    BEQ LONG_WORD_DISPLACMENT
    
*otherwise byte displacment
    MOVE.L  A4,D4                  *LOAD MEMORY LOCATION INTO D4, USED TO CALCULATE ABSOLUTE ADDRESS
    ADD.L  #2,D4                   *ADD 2 TO D4 FOR NEXT INSTRUCTION
    
    LSL.W   #8,D5                   *SHIFT D5 LEFT 8 BITS XXXXXXXXXCCCCCCCC ---> CCCCCCCC00000000
    EXT.L   D5                      *EXTEND BYTE DATA TO LONG
    ASR.W   #8,D5                   *SHIFT D5 BACK RIGHT 8 BITS CCCCCCCC00000000 ---> 00000000CCCCCCCC
    BRA CALCULATE_ABSOLUTE_ADDRESS
    
WORD_DISPLACMENT
    MOVE.L  A4,D4                  *LOAD MEMORY LOCATION INTO D4, USED TO CALCULATE ABSOLUTE ADDRESS
    ADD.L  #2,D4                   *ADD 2 TO D4 FOR NEXT INSTRUCTION

    ADDA.L  #2,A4                 *ADD 2 TO ADDRESS SO THAT A4 WILL POINT AT DATA
    MOVE.W  (A4),D5                 *LOAD DATA INTO D5
    EXT.L   D5                      *EXTEND WORD DATA TO LONG
    BRA CALCULATE_ABSOLUTE_ADDRESS
LONG_WORD_DISPLACMENT
    MOVE.L  A4,D4                  *LOAD MEMORY LOCATION INTO D4, USED TO CALCULATE ABSOLUTE ADDRESS
    ADD.L  #2,D4                   *ADD 2 TO D4 FOR NEXT INSTRUCTION

    ADDA.L  #2,A4                  *ADD 2 TO ADDRESS SO THAT A4 WILL POINT AT DATA
    MOVE.L  (A4),D5                 *LOAD DATA INTO D5
    ADDA.L  #2,A4                  *ADD 2 TO ADDRESS SO THAT A4 WILL BE IN RIGHT PLACE FOR NEXT OPCODE
    BRA CALCULATE_ABSOLUTE_ADDRESS

*calculate absolute address
CALCULATE_ABSOLUTE_ADDRESS
    CMP.L   #0,D5
    BLT NEGATIVE_DISPLACMENT
    
    ADD.L   D5,D4               *ADD THE DISPLACMENT TO ADDRESS OF NEXT OPCODE
    MOVE.L  D4,D5               *COPY ADDRESS AT D4 BACK INTO D5 FOR CONVERSION
    BRA LOAD_TO_A1
    
NEGATIVE_DISPLACMENT
    MOVE.L #0,D6                *MOVE 0 INTO D6
    SUB.L   D5,D6               *SUBRACT 0 - DISPLACMENT
    
    SUB.L   D6,D4               *SUBTRACT THE DISPLACMENT TO ADDRESS OF NEXT OPCODE
    MOVE.L  D4,D5               *COPY ADDRESS AT D4 BACK INTO D5 FOR CONVERSION
    BRA LOAD_TO_A1

LOAD_TO_A1
    MOVE.B #00,D2               *SET D2 TO 0 FOR LOOPING
LOAD_LOOP
    CMP.B   #2,D2               *COMPARE D2 TO 3 TO END LOOP
    BEQ PRINT_ALL              *ALL DONE PRINT IT OUT
    ADD.B   #1,D2               *INCREMENT
    SWAP    D5                  *SWAP DATA AT D5 SO THAT THE LEFT HAND SIDE CAN BE PRINTED FIRST
    ROR.W   #8,D5                *ROTATE THE LOWER WORD 8 BITS TO GET THE LEFT HAND BYTE FIRST
    JSR PRINT_BYTE              *PRINT THE LEFT HAND BYTE (NOW LOWER BYTE)
    ROR.W   #8,D5                *ROTATE LOWER WORD AGAIN TO GET THE RIGHT HAND BYTE
    JSR PRINT_BYTE              *PRINT THE RIGHT HAND BYTE (NOW LOWER BYTE)
    
    BRA LOAD_LOOP               *LOOP BACK
    
PRINT_BYTE
    MOVE.B  D5,D3               *MOVE THE BYTE OF DATA AT D5 TO D3
    LSR.B   #4,D3               *GET THE FIRST BYTE FROM D3 FOR PRINTING
    
    JSR PRINT_DIGIT             *CONVERT THE DIGIT AT D3 TO ASCCI
    
    MOVE.B  D5,D3               *MOVE THE BYTE OF DATA AT D5 TO D3
    LSL.B   #4,D3                *SHIFT THE SENCOND BYTE AT D3 LEFT
    LSR.B   #4,D3               *SHIFT 2ND BYTE BACK RIGHT
    
    JSR PRINT_DIGIT             *CONVERT THE DIGIT AT D3 TO ASCCI
    
    RTS
PRINT_DIGIT
    CMP.B       #10, D3         * IF VALUE OF HEX IS GREATER OR EQUAL TO 10(A)
    BGE PRINT_LETTER            * VALUE IS #10-15, CONVERT LETTER
    BRA PRINT_NUMBER            * VALUE IS #0-9, CONVERT NUMBER
PRINT_LETTER
    ADD.W       #$37, D3        * ADD #$37 TO D3, TO GET ASCII-HEX LETTER VALUE
    MOVE.B      D3, (A1)+       * ADD ASCII-HEX CHAR(A-F) TO A1, INCREMENT A1
    ADD.W       #1, D1          * INC CHAR COUNT 
    RTS
PRINT_NUMBER
    ADD.W       #$30, D3        * ADD #$30 TO D3, TO GET ASCII-HEX NUMBER VALUE
    MOVE.B      D3, (A1)+       * ADD ASCII-HEX CHAR(0-9) TO A1, INCREMENT A1
    ADD.W       #1, D1          * INC CHAR COUNT 
    RTS                         * GO BACK TO ABS_LOOP
    
PRINT_ALL
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    BRA RETURN_BCC
RETURN_BCC
    RTS











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
