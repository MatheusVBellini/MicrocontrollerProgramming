ORG 0000h
CLR   P3.4       ; seleciona o display 0
CLR   P3.3
ACALL rst        ; comeca o programa no numero 0

main:
; display 1 - 4 us
	SETB  P1.0
	SETB  P1.3
	SETB  P1.4
	SETB  P1.5

; display 2 - 5 us
	CLR  P1.0
	SETB P1.2
	CLR  P1.3
	CLR  P1.4
	CLR  P1.6

; display 3 - 2 us
	CLR  P1.2
	SETB P1.4

; display 4 - 3 us
	SETB P1.0
	SETB P1.3
	CLR  P1.5

; display 5 - 3 us
	CLR  P1.0
	SETB P1.1
	CLR  P1.3

; display 6 - 1 us
	CLR  P1.4	

; display 7 - 5 us
	CLR  P1.1
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6

; display 8 - 4 us
	CLR  P1.3
	CLR  P1.4
	CLR  P1.5
	CLR  P1.6

; display 9 - 1 us
	SETB P1.4

; display 0 - 2 us
	CLR  P1.4
	SETB P1.6

JMP main

; inicia o display com 0
rst:              ; 8us execucao + 4us chamada
	CLR   P1.0
	CLR   P1.1
	CLR   P1.2
	CLR   P1.3
	CLR   P1.4
	CLR   P1.5
	SETB  P1.6
	SETB  P1.7
RET