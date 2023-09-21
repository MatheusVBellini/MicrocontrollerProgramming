org 00h

main:
	MOV  ACC, #02h ; move 2 para ACC
	MOV  B,   #03h ; move 3 para B
	MOV  7Fh, #07h ; move 7 para o endereco 7Fh
	ADD  A,   7Fh  ; soma o conteudo de 7Fh com o ACC
	DEC  ACC       ; decrementa ACC 3 vezes
	DEC  ACC
	DEC  ACC
	INC  B         ; incrementa B em 1 unidade
	SUBB A, B      ; substrai A por B
	MUL  AB        ; multiplica A por B
	INC  B         ; incrementa B 2 vezes
	INC  B
	DIV  AB        ; divide A por B
	MOV  7Eh,  A   ; coloca A em 7Eh
	MOV  7Dh,  B   ; coloca B em 7Dh
	JMP  main      ; volta para a label main
