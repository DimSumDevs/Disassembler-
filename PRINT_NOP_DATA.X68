*-----------------------------------------------------------
* Title      :  PRINT_NOP_DATA
* Written by :  Michael Ritchie 
* Date       :
* Description:  Prints non-opcode data 
*-----------------------------------------------------------
    ORG    PRINT_NOP_DATA
PRINT_NOP_DATA:                  ; first instruction of program
    
    CLR.L   D1                  *CLEAR D1
    JSR PRINT_MEMORY_ADDRESS    *PRINT THE ADDRESS OF THE DATA
    
    MOVE.B      #$44,(A1)+      *LOAD 'D' INTO A1[4]
    ADD.W       #1,D1           *INC CHAR COUNT
    MOVE.B      #$41,(A1)+      *LOAD 'A' INTO A1[4]
    ADD.W       #1,D1           *INC CHAR COUNT
    MOVE.B      #$54,(A1)+      *LOAD 'T' INTO A1[4]
    ADD.W       #1,D1           *INC CHAR COUNT
    MOVE.B      #$41,(A1)+      *LOAD 'A' INTO A1[4]
    ADD.W       #1,D1           *INC CHAR COUNT
    
    MOVE.W  #6, _SPACES         *6 SPACES
    JSR ADD_SPACES              *PRINT SPACES
    MOVE.B      #$24,(A1)+      *LOAD '$' INTO A1[4]
    ADD.W       #1,D1           *INC CHAR COUNT
    
    MOVE.L      (A4),HTA_CONVERT
    MOVE.B      #4,HTA_SIZE
    JSR CONVERT_HTA
    
    MOVEA.L     A1LOC, A1       * RESET A1 TO START OF ADDR
    MOVE.B      #0, D0          * Move (Task)14 into D0 for Trap 15
    TRAP        #15             * PRINT WHAT IS AT A1, 0 - D1.B
    RTS                         * GO BACK TO MAIN





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
