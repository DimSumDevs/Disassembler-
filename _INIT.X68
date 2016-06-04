*-----------------------------------------------------------
* Title      :  INIT_VAR
* Written by :  TYLER QUAYLE
* Date       :  MAY 6, 2016
* Description:  'INITIALIZE' ALL VARIABLES INTO MEMORY
*-----------------------------------------------------------
    ORG    _INIT
    
    CLR.W   DEST_MODE
    CLR.W   DEST_REG
    CLR.W   SOURCE_REG
    CLR.W   SOURCE_MODE
    CLR.W   _CONVERT
    CLR.W   _SIZE
    CLR.L   _TOTAL
    CLR.W   _SPACES
    
    MOVE.B  #30, DEST_MODE      * GIVE STARTING VALUE OF DEST_MODE, ABOVE 9 WILL BE IGNORED
    MOVE.B  #30, DEST_REG       * GIVE STARTING VALUE OF DEST_REG, ABOVE 9 WILL BE IGNORED
    MOVE.L  #PRINTER, A1LOC    
    CLR.W   SCREEN_COUNT        * CLR SCREEN_COUNT FOR PROPER COUNTING.

    
    *JSR USER_INPUT              *JUMP INTO USER INPUT TO GET MEM_FROM AND MEM_TO LOCATIONS
    MOVE.L  #$7000, MEM_FROM    ********************** ONLY FOR TESTING!! ONCE USER INPUT GETS WRITTEN DELETE THIS
    MOVE.L  #$11000, MEM_TO     ********************** ONLY FOR TESTING!! ONCE USER INPUT GETS WRITTEN DELETE THIS  

GRID:   *USING THIS FOR 'DEBUG', TO SEE VARIABLES EASIER
    CLR.L   $1000
    CLR.L   $1004
    CLR.L   $1008
    CLR.L   $100C
    CLR.L   $1070
    CLR.L   $1074
    CLR.L   $1078
    CLR.L   $107C
    MOVE.W  #$AAAA, $1012
    MOVE.W  #$AAAA, $1016
    MOVE.W  #$AAAA, $101A
    MOVE.W  #$AAAA, $101E
    MOVE.W  #$AAAA, $1022
    MOVE.W  #$AAAA, $1026
    MOVE.W  #$AAAA, $1034

    RTS

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
