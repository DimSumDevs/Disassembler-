*****************************
*
*
* Created 2/18/2016
*
* Test program
*
*****************************

begin		EQU	$00007000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	begin


                BCC	compares		
		BGT	compares		
		BLE	compares  
                ADDI.B      #$11, D3
                ADDI.W      #$1234,D1
                ADDI.L      #$12CDEF43,D2
                
                MULU.W      $11,D3
                DIVU.W      $12,D3

                SUB.B      D3,$12
                ADDA.W     $2222,A2
                ADD.B      D3,$13
                ADD.B      D3,$14
                ADD.B      D3,$15
                ADD.B      $12,D3
                ADD.L      $1B23,D3
                ADD.W      $8AD99,D3
                ADD.W      D3, $12
                ADDA.W     $12,A3
                AND.B      $1200, D3
                AND.W      $1200, D3
                AND.L      $1200, D3
                AND.B      D3, $1200
                AND.W      D3, $1200
                AND.L      D3, $1200     
                OR.B      $1200, D3
                OR.W      $1200, D3
                OR.L      $1200, D3
                OR.B      D3, $1200
                OR.W      D3, $1200
                OR.L      D3, $1200
                JSR       $12000
                JSR       begin
                LEA       $12000, A1
                LEA       (A1), A2
                MOVEQ     #$A, D3
                MOVEQ     #$99, D3
                CMP.B     #$1, D1
                CMP.B     #10, D1
                CMP.B     $1, D1


*NOP
                MOVEM.W A0-A7/D0-D7,(A3)

                NOP
*MOVE, needs all three sizes and all address types
                MOVE.B  D3,D4
                MOVE.B  (A3),D4
                MOVE.B  (A3)+,D4
                MOVE.B  -(A3),D4
                MOVE.B  $7500,D4
                MOVE.B  $F8000,D4
                MOVE.B  #$99, D4
                MOVE.B  #$98,D4
                
                MOVE.W  A3,D4
                MOVE.W  D4, D3
                MOVE.W  D4,(A3)
                MOVE.W  D4,(A3)+
                MOVE.W  D4,-(A3)
                MOVE.W  D4,$7500
                MOVE.W  D4,$F8000
                MOVE.W  #$45,D4
                MOVE.W  #$4567,D4
                MOVE.W  #$0067,D4
                
                MOVE.L  A3,(A3)
                MOVE.L  $7500,(A3)+
                MOVE.L  -(A3),$F8000
                MOVE.L  #$00000045,D4
                MOVE.L  #$0004567,D4
                MOVE.L  #$45,D4
                MOVE.L  #$4567,D4
                MOVE.L  #$4567890,D4 
                
                MOVE.L  #256,D4
                MOVE.W  #%1111101001010001,D4
                
                NOP
                
*MOVEA
                MOVEA.W D4,A3
                MOVEA.W A2,A3
                MOVEA.W (A2),A3
                MOVEA.W (A2)+,A3
                MOVEA.W -(A2),A3
                MOVEA.W $7500,A3
                MOVEA.W $F8000,A3
                MOVEA.W #$3456,A3
                MOVEA.W #16,A3
                
                MOVEA.L D4,A3
                MOVEA.L A2,A3
                MOVEA.L (A2),A3
                MOVEA.L (A2)+,A3
                MOVEA.L -(A2),A3
                NOP
                MOVEA.L $7500,A3
                MOVEA.L $F8000,A3
                MOVEA.L #$3456,A3
                MOVEA.L #16,A3
                MOVEA.L #$12345678,A3
                NOP
*MOVEQ
                MOVEQ   #$AF,D4
                MOVEQ   #$2,D4
                MOVEQ   #%10101111,D4
                MOVEQ   #45,D4
                NOP
*MOVEM
                MOVEM.W  $7500,D0-D5
                MOVEM.W  $F8000,A0-A5
                
                MOVEM.W (A3),D0-D3
                MOVEM.W  D0-D3,(A3)
                MOVEM.W  D3-D0,(A3)
                MOVEM.W  D3-D0,(A4)
                MOVEM.W  A3-A0,(A3)
                MOVEM.W  D4-D0,(A3)
                MOVEM.W  D0/D2/D4/D6/A1/A3/A5/A7,$7500
                
                MOVEM.W D0,(A3)
                MOVEM.W A2/D1,-(A3)
                MOVEM.W D2,$7500
                MOVEM.W D3,$F8000
                NOP
                MOVEM.W D0-D4,(A3)
                MOVEM.W A2/D2,-(A3)
                MOVEM.W D2-D5/A4,$7500
                MOVEM.W A1-A4/D3,$F8000

                MOVEM.L D0-D7/A0-A6,-(A7)
                MOVEM.L A5-A2/D1-D5,(A1)
                MOVEM.L A4/D4-D0,$7500
                MOVEM.L A4,$F8000
                NOP
*ADD
                ADDI.W	#$4000,D0
                NOP
*ADDA*
                NOP
*ADDI
                NOP
*ADDQ
                ADDQ.B  #8,D4
                ADDQ.B  #6,(A3)
                ADDQ.B  #5,(A3)+
                ADDQ.B  #4,-(A3)
                ADDQ.B  #3,$7500
                ADDQ.B  #2,$F8000
                
                ADDQ.W  #8,D4
                ADDQ.W  #7,A3
                ADDQ.W  #6,(A3)
                ADDQ.W  #5,(A3)+
                ADDQ.W  #4,-(A3)
                ADDQ.W  #3,$7500
                ADDQ.W  #2,$F8000
                
                ADDQ.L  #8,D4
                ADDQ.L  #7,A3
                ADDQ.L  #6,(A3)
                ADDQ.L  #5,(A3)+
                ADDQ.L  #4,-(A3)
                ADDQ.L  #3,$7500
                ADDQ.L  #2,$F8000
                NOP
*SUB
                SUBA.W	(A4),A6
                NOP
*MULS
                NOP
*DIVU
                NOP
*LEA
                LEA	$DC00FF00,A2
                NOP
*CLR
                CLR.L	D4
                CLR.L   (A1)+
                CLR.L   -(A2)
                CLR.L   (A3)
                CLR.L	D4
                CLR.L   (A1)+
                CLR.L   -(A2)
                CLR.L   (A3)
                CLR	D4
                CLR     (A1)+
                CLR     -(A2)
                CLR     (A3)
                CLR.B	D4
                CLR.B   (A1)+
                CLR.B   -(A2)
                CLR.B   (A3)
                CLR.B   $54
                CLR.W	D4
                CLR.W   (A1)+
                CLR.W   -(A2)
                CLR.W   (A3)
                CLR.W   $0045
                CLR.L   $00007777
                CLR.L   $00080000
                CLR.L   $88888888
                CLR.L   $88880000
                NOP
*AND
                AND.B	#$01,$4568
                NOP
*OR
                NOP
*LSL
                LSL.B	D3,D0
                LSL.W   #4,D1
                LSL.L   D4,D2
                NOP
*LSR
                LSR.B	D3,D0
                LSR.W   #4,D1
                LSR.L   D4,D2
                NOP
*ASR
                ASR.B	D3,D0
                ASR.W   #4,D1
                ASR.L   D4,D2
                NOP
*ASL
                ASL.B	D3,D0
                ASL.W   #4,D1
                ASL.L   D4,D2
                NOP
*ROL
                ROL.B	D1,D3
                ROL.W	D2,D3
                ROL.L	D3,D3
                NOP
*ROR
                ROR.B	#1,D3
                ROR.W	#2,D3
                ROR.L	#3,D3
                NOP
*CMP
compares        CMP.B	(A3),D5
                NOP
*BCC
                BCC	compares		
		BGT	compares		
		BLE	compares
                NOP
*JSR
                JSR     $7500
                JSR     $F8000
                NOP
*RTS
                NOP




































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
