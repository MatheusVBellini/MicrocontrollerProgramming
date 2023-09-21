org 00h

main:
	MOV  ACC,  #0Ah   ; move 0Ah diretamente para ACC
	MOV  ACC,  #00h   ; move 00h diretamente para ACC
	MOV  R0,   #0Bh   ; move 0Bh para R0 do banco 0
	MOV  B,    #0Ch   ; move 0Ch para o registrador C
	MOV  7Fh,  P1     ; move a porta P1 para o enderco 7Fh
	SETB PSW.3        ; seleciona o banco 1
	MOV  R0,   7Fh    ; escreve conteudo de 7Fh em R0 do banco 1
	MOV  7Eh,  R0     ; escreve R0 (banco 1) em 7Eh
	MOV  R1,   #7Eh   ; R1 ponteiro para 7Eh
	MOV  ACC,  @R1    ; move conteudo no endereco R1 para ACC
	MOV  DPTR, #9A5Bh ; move 9A58h para DPTR
	NOP               ; ciclo ocioso
	SJMP $            ; pula para a mesma instrucao
