*-----------------------------------------------------------
* Title      :  VARIABLES
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $2000
*************************************************************
******************SUBROUTINE LOCATIONS***********************    
MAIN                EQU $1080                               *

_INIT               EQU $1350                               
DECODE_SORT         EQU $1400                              *
CONVERT_HEX_ASCII   EQU $1520                              *
ABS_DECODE          EQU $1570                              *
IMM_DECODE          EQU $1600                              *

CODE_0000_ADDI      EQU $16A0                              *
CODE_0001_MOVE_B    EQU $1780                              *
CODE_0010_MOVE_L    EQU $1810                              *
CODE_0011_MOVE_W    EQU $18A0                              *
CODE_0100           EQU $3200                              *
CODE_0100_CLR       EQU $19F0                              *
CODE_0100_NOP       EQU $1A80                              *
CODE_0100_RTS       EQU $1AC0                              *
CODE_0100_JSR       EQU $1AF0                              *
CODE_0100_STOP      EQU $1B40                              *
CODE_0100_LEA       EQU $1B90                              *
CODE_0100_MOVEM     EQU $1BF0
CODE_0101_ADDQ      EQU $1D90                              *
CODE_0110_BCC       EQU $1EF0
CODE_0111_MOVEQ     EQU $1E60                              *
CODE_1000_OR        EQU $2040
CODE_1001_SUB       EQU $2170                              *
CODE_1011_CMP       EQU $2260                              *
CODE_1101_ADD       EQU $2320                              *
CODE_1100_AND       EQU $2480                              *
CODE_1110           EQU $25A0                              *
DECODE_MAIN         EQU $26C0                              *
USER_INPUT          EQU $2750                              *
CONVERT_HTA         EQU $2B20                              *
PRINT_NOP_DATA      EQU $2C40
ADD_SPACES          EQU $2E00
*******************END SUBROUTINE LOCS***********************
*************************************************************

*************************************************************
*******************VARIABLES*********************************

*   USE VALUES BETWEEN 1000-1100

A1LOC               EQU $30E0       * USED FOR 'OUTPUT BUFFER' FOR A1
PRINTER             EQU $3100       * NUM VARIABLE, CHANGE THIS TO CHANGE PRINT LOC!
FOR_ABS             EQU $1046       * USED IN ABS_DECODE FOR LOOPING

SOURCE_REG          EQU $1014       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
SOURCE_MODE         EQU $1010       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
DEST_REG            EQU $1024       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
DEST_MODE           EQU $1020       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)

SCREEN_COUNT        EQU $1028       * USED TO COUNT THE OUTPUT OF THE SCREEN FOR PAUSES

_CONVERT            EQU $1018       * USED FOR CONVERT_HEX_ASCII VALUES
_SIZE               EQU $101C       * USED FOR IMME ADDR       
_TOTAL              EQU $1050       * USED TO COUNT TOTAL OPCODES
MEM_FROM            EQU $1030       * NEEDS TO BE FILLED FROM USER INPUT
MEM_TO              EQU $1040       * NEEDS TO BE FILLED FROM USER INPUT
STORE_INPUT         EQU $1070       * USED BY UESER_INPUT
OFFSET              EQU $102C       

HTA_CONVERT         EQU $1048       *USED BY CONVERT_HTA
HTA_SIZE            EQU $104D       *USED BY CONVERT_HTA
HTA_LEADING_ZEROS   EQU $1056       *USED BY CONVERT_HTA

_SPACES             EQU $102C


































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
