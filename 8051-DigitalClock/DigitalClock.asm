fullsec    EQU 498     ; numero de referencia de delay para troca de numero a cada segundo
quartersec EQU 123     ; numero de referencia de delay para troca de numero a cada 0.25s

ORG 0000h
MOV P3, #11100111b     ; seleciona o display 0

; seleciona entre contagem de 0.25s, 1s ou desligado
selectmode:
	JNB P2.1, fullspeed
	JNB P2.2, quarterspeed
	JMP turnoff


; contagem de 0 a 9
count:
	MOV P1, #0C0h ; display 0 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #0F9h ; display 1 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #0A4h ; display 2 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #0B0h ; display 3 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #99h  ; display 4 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #92h  ; display 5 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #82h  ; display 6 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #0F8h ; display 7 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #80h  ; display 8 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

	MOV P1, #90h  ; display 9 ; 2 us
	ACALL delay   ; wait      ; (7Fh*2)ms + 4ms + 5us

JMP selectmode   ; verifica selecao de opcao ; 

; desliga o display
turnoff:
	MOV P1, #0FFh    ; turn off  ; 2 us
	JMP selectmode  ; volta para a selecao de opcao


; opcao de 1s
fullspeed:
	MOV 7Fh, #fullspeed	 ; endereco 7Fh recebe o valor de referencia de delay para 1s
	JMP count

; opcao de 0.25s
quarterspeed:
	MOV 7Fh, #quartersec ; endereco 7Fh recebe o valor de referencia de delay para 0.25s
	JMP count


; gera delay temporal de acordo com o valor no endereco 7Fh
delay:                       ; tempo de execucao de sub-rotina = (7Fh*2)ms + 4ms + 5us
	MOV R0, #1000            ; o loop principal deve se repetir 1000 vezes (us -> ms)   ; 1us
	_delay:                  ; 1000x
		MOV R1, 7Fh          ; o loop secundario deve se repetir R1 vezes (0.25s ou 1s) ; 2us * 1000 = 2ms
		__delay:             ; R1x
			DJNZ R1, __delay ; decrementa R1 ate chegar a zero 1000 vezes               ; 2us * 1000 * R1 = 2ms * R1
		DJNZ R0, _delay      ; decrementa R0 ate chegar a zero                          ; 2us * 1000 = 2ms
RET                          ; retorna do chamado de sub-rotina                         ; 2us
