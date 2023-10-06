ORG 0000h
CLR   P3.4       ; seleciona o display 0
CLR   P3.3
; 1 000 ms = 9us + 4ms + 2ms*7Fh
MOV 7Fh, #498   ; referencia temporal para o delay

main:
	MOV P1, #0C0h ; display 0 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #0F9h ; display 1 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #0A4h ; display 2 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #0B0h ; display 3 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #99h  ; display 4 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #92h  ; display 5 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #82h  ; display 6 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #0F8h ; display 7 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

	MOV P1, #80h  ; display 8 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us
	
	MOV P1, #90h  ; display 9 - 2 us
	ACALL delay   ; wait      - 2ms*7Fh + 4ms + 5us

JMP main

; delay em us pelo valor no endereco 7Fh
delay:                       ; 2us + 1us + 2ms + 2ms*7Fh + 2ms + 2us = 2ms*7Fh + 4ms + 5us
	MOV R0, #1000            ; 1us
	_delay:                  ; 1000x
		MOV R1, 7Fh          ; 2us * 1000 = 2ms
		__delay:             ; R1x
			DJNZ R1, __delay ; 2us * 1000 * R1 = 2ms * R1
		DJNZ R0, _delay      ; 2us * 1000 = 2ms
RET                          ; 2us
