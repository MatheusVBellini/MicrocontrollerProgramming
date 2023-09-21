org 00h

main:
	MOV  ACC, #01101001b ; move 01101001b para ACC
	MOV  B,   #10100101b ; move 10100101b para B
	ANL  A,   B          ; A & B
	RR   A               ; rotaciona A a direita 2 bits
	RR   A
	CPL  A               ; ~A
	RL   A               ; rotaciona A a esquerda 2 bits
	RL   A
	ORL  A,   B          ; A | B
	XRL  A,   B          ; A ^ B
	SWAP A               ; A = XYh -> A = YXh
	JMP  main            ; salta de volta para a main 
