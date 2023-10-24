fullsec    EQU 10h     			; Number of reference for a delay of 1s
quartersec EQU 04h     			; Number of reference for a delay of 0.25s

ORG 0000h						; Starting address of the program
MOV P3, #11100111b     			; Selects display 0
MOV TMOD, #01h 					; Selects Timer 0 on mode 1 (16-bit counter)

; Selects between counting mode of 1s delay and 0.25s delay, or turns off the display
selectmode:
	JNB P2.1, fullspeed 		; If Switch(1) = 0,	jumps to fullspeed
	JNB P2.2, quarterspeed 		; If Switch(2) = 0, jumps to quarterspeed
	JMP turnoff					; Else, jumps to turnoff


; Counting from 0 to 9
count:
	MOV P1, #0C0h 				; display 0 - 2 us
	ACALL delay   				; wait      

	MOV P1, #0F9h 				; display 1 - 2 us
	ACALL delay   				; wait      

	MOV P1, #0A4h 				; display 2 - 2 us
	ACALL delay   				; wait      

	MOV P1, #0B0h 				; display 3 - 2 us
	ACALL delay   				; wait      

	MOV P1, #99h  				; display 4 - 2 us
	ACALL delay   				; wait      

	MOV P1, #92h  				; display 5 - 2 us
	ACALL delay   				; wait      

	MOV P1, #82h  				; display 6 - 2 us
	ACALL delay   				; wait      

	MOV P1, #0F8h 				; display 7 - 2 us
	ACALL delay   				; wait      

	MOV P1, #80h  				; display 8 - 2 us
	ACALL delay   				; wait      

	MOV P1, #90h  				; display 9 - 2 us
	ACALL delay   				; wait      

	JMP selectmode   			; Checks for option selected

; Turns-off the display
turnoff:
	MOV P1, #0FFh   			; turn off  - 2 us
	JMP selectmode  			; Returns to selectmode


; 1s - delay option
fullspeed:
	MOV 7Fh, #fullsec 			; Loads 7Fh with 16 (repeats 16 times, because 65536 - 3036 = 62500, 62500*16 = 1,000,000 us = 1s)
	JMP count        			; Starts counting


; 0.25s - delay option
quarterspeed:
	MOV 7Fh, #quartersec 		;Loads 7Fh with 4 (repeats 4 times, because 65536 - 3036 = 62500, 62500*4 = 250000 us = 0.25s)
	JMP count

; Delays based on the value in R7
delay:							
	MOV R7, 7Fh					; Moves the value on 7Fh to R7
	RESET:
		MOV TH0, #00Bh 			; Load the timer with high byte of 3036
		MOV TL0, #0DCh 			; Load the timer with low byte of 3036
		SETB TR0 	   			; Start the timer

	COUNT_TIMER:
		JNB TF0, COUNT_TIMER  	; Jump if TF0=0
		CLR TR0 	    		; Stop Timer 0 after it overflows
		CLR TF0         		; Clear TF0 for the next operation

	DJNZ R7, check_switches   	; Decrement R7. If it's not 0, jump to check_switches, does it until R7 = 0
	RET                 	   	; Returns from subroutine call

; Checks which switch is pressed and updates the delay option accordingly 
check_switches:
	JNB P2.1, update_fullspeed 		; If Switch(1) = 0,	update to fullspeed
	JNB P2.2, update_quarterspeed 	; If Switch(2) = 0, update to quarterspeed
	JMP RESET						; Else, jumps back to RESET

; Updates the delay option to 1s 
update_fullspeed:
	MOV 7Fh, #fullsec 				; Loads 7Fh with 16 (repeats 16 times)
	JMP RESET						; Jumps back to RESET

; Updates the delay option to 0.25s
update_quarterspeed:
	MOV 7Fh, #quartersec 			; Loads 7Fh with 4 (repeats 4 times)
	JMP RESET						; Jumps back to RESET