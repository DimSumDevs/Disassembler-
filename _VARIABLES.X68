*-----------------------------------------------------------
* Title      :  VARIABLES
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $2000
*************************************************************
******************SUBROUTINE LOCATIONS***********************    
MAIN                EQU $100                                *
_INIT               EQU $900                                *
DECODE_MAIN         EQU $16000                              *
DECODE_SORT         EQU $16200                              *
CONVERT_HEX_ASCII   EQU $16300                              *
ABS_DECODE          EQU $16500                              *
IMM_DECODE          EQU $17000                              *
                                                            *
CODE_0001_MOVE_B    EQU $30000                              *
                                                            *
CODE_0010_MOVE_L    EQU $30100                              *
                                                            *
CODE_0011_MOVE_W    EQU $30200                              *
                                                            *
CODE_0100           EQU $20000                              *
CODE_0100_CLR       EQU $20200                              *
CODE_0100_NOP       EQU $20300                              *
CODE_0100_RTS       EQU $20400                              *
CODE_0100_JSR       EQU $20500                              *
CODE_0100_STOP      EQU $20600                              *
CODE_0100_LEA       EQU $20700                              *
                                                            *
CODE_0111_MOVEQ     EQU $26000                              *
                                                            *
CODE_1000_OR        EQU $21100
CODE_1001_SUB       EQU $23000                              *
                                                            *
CODE_1100_AND       EQU $21200                              *
                                                            *
CODE_0101_ADDQ      EQU $21000                              *                                                            
                                                            *
CODE_1101_ADD       EQU $22000                              *
                                                            *
CODE_1011_CMP       EQU $27000                              *
                                                            *
CODE_1110           EQU $31000                              *
*******************END SUBROUTINE LOCS***********************
*************************************************************

*************************************************************
*******************VARIABLES*********************************

*   USE VALUES BETWEEN 1010-1060
A1LOC               EQU $1040       * USED FOR 'OUTPUT BUFFER' FOR A1
PRINTER             EQU $1080       * NUM VARIABLE, CHANGE THIS TO CHANGE PRINT LOC!
FOR_ABS             EQU $9100       * USED IN ABS_DECODE FOR LOOPING

SOURCE_REG          EQU $1014       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
SOURCE_MODE         EQU $1010       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
DEST_REG            EQU $1024       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)
DEST_MODE           EQU $1020       * USED FOR ADDRESSES (ABS_DECODE/DECODE_SORT/DECODE_MAIN)

SCREEN_COUNT        EQU $1028       * USED TO COUNT THE OUTPUT OF THE SCREEN FOR PAUSES

_CONVERT            EQU $1018       * USED FOR CONVERT_HEX_ASCII VALUES
_SIZE               EQU $101C       * USED FOR IMME ADDR       
_TOTAL              EQU $1050       * USED TO COUNT TOTAL OPCODES
MEM_FROM            EQU $1030       * NEEDS TO BE FILLED FROM USER INPUT
MEM_TO              EQU $1036       * NEEDS TO BE FILLED FROM USER INPUT

OFFSET              EQU $102C


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
