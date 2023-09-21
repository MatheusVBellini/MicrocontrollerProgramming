org 00h               ; colocar 33h

JMP main              ; salta para a main

main:
	CLR  A            ; limpa ACC
	MOV  R0, #02h     ; move 2 para R0

segment1:
	JZ   segment2     ; vai para segment2 se ACC = 0
	JNZ  segment3     ; vai para segment3 se ACC != 0
	NOP               ; ciclo ocioso

segment2:
	MOV  ACC, R0      ; move R0 para ACC
	JMP  segment1     ; volta para segment1 

segment3:
	DJNZ R0, segment3 ; volta para segment3 se --R0 != 0
	JMP  main         ; volta para a main
