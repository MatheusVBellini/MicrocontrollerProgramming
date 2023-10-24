# Relógio Digital com 8051

## Alunos
- Matheus Violaro Bellini (12547600)
- Enzo Serrano Conti (12547147)
- Rafael Freitas Garcia (11222374)

## Descrição do projeto

O projeto é composto por diversas subrotinas em assembly de modo a usar o microcontrolador 8051 para criar um relógio digital. O relógio é exibido em um display de 7 segmentos acessado pela porta P3, e é possível alterar o intervalo de contagem dos segundos a partir do uso de duas chaves, SW1 e SW2, sendo que SW1 ativa a contagem, e SW2 quando pressionada muda o intervalo de 1s para 0.25s. Caso SW2 seja desativado, o intervalo volta a ser de 1s. Chegando em 9, o display de 7 segmentos volta a 0 e o contador de segundos é zerado, recomeçando a contagem. Todas as linhas do código estão devidamente comentadas no arquivo .asm, e aqui será explicado o funcionamento geral do código e suas subrotinas de modo lógico.

### Início do programa

O código inicia-se a partir da declaração de alguns parâmetros, como variáveis de referência para os valores que serão usados em cada delay, no caso, _fullsec_ e _quartersec_, para 1s e .25s, respectivamente.

```
fullsec    EQU 10h     			; Number of reference for a delay of 1s
quartersec EQU 04h     			; Number of reference for a delay of 0.25s

ORG 0000h						; Starting address of the program
MOV P3, #11100111b     			; Selects display 0
MOV TMOD, #01h 					; Selects Timer 0 on mode 1 (16-bit counter)

```

Em seguida, declara-se o endereço de inicío do programa, e seleciona-se o display 0 para ser exibido inicialmente movendo o binário correspondente para a porta 3, a qual está conectada com o display. Move-se para o resgitrador _TMOD_ do Timer 0 o valor necessário para ser usado como contador de 16 bits. Em seguida, entra-se na execução da primeira subrotina, _selectmode_.

#### Subrotina _selectmode_

A subrotina _selectmode_ é responsável por selecionar o modo de contagem do relógio, ou desligá-lo. Para isso, ela verifica o estado das chaves SW1 e SW2, conectadas aos pinos P2.1 e P2.2, respectivamente. Caso SW1 esteja pressionada, pula-se para a subrotina _fullspeed_. Caso SW2 esteja pressionada, pula-se para a subrotina _quarterspeed_, caso nada esteja pressionado, pula-se para a subrotina _turnoff_. O código da subrotina é o seguinte:

```
; Selects between counting mode of 1s delay and 0.25s delay, or turns off the display
selectmode:
	JNB P2.1, fullspeed 		; If Switch(1) = 0,	jumps to fullspeed
	JNB P2.2, quarterspeed 		; If Switch(2) = 0, jumps to quarterspeed
	JMP turnoff					; Else, jumps to turnoff
```


#### Subrotinas _fullspeed_, _quarterspeed_ e _turnoff_

As subrotinas _fullspeed_ e _quarterspeed_ são responsáveis por selecionar o intervalo de contagem do relógio, sendo que _fullspeed_ seleciona o intervalo de 1s, e _quarterspeed_ seleciona o intervalo de 0.25s. Para isso, elas movem para o registrador 7Fh o valor de referência para o intervalo de contagem desejado, e pulam para a subrotina _count_.

Fullspeed:

```
; 1s - delay option
fullspeed:
	MOV 7Fh, #fullsec 			; Loads 7Fh with 16 (repeats 16 times, because 65536 - 3036 = 62500, 62500*16 = 1,000,000 us = 1s)
	JMP count        			; Starts counting
```

Quarterspeed:

```
; 0.25s - delay option
quarterspeed:
	MOV 7Fh, #quartersec 		;Loads 7Fh with 4 (repeats 4 times, because 65536 - 3036 = 62500, 62500*4 = 250000 us = 0.25s)
	JMP count
```

A subrotina _turnoff_  é responsável por desligar o display, e para isso, move-se para o registrador P1 o valor 0FFh, que é o valor necessário para desligar todos os segmentos do display. Em seguida, pula-se para a subrotina _selectmode_ reinicia-se o check se alguma das chaves foi pressionada.

```
; Turns-off the display
turnoff:
	MOV P1, #0FFh   			; turn off  - 2 us
	JMP selectmode  			; Returns to selectmode
```

#### Subrotina _count_

A subrotina _count_ é responsável por fazer com que os segmentos respectivos a cada número sejam acendidos no display 0, e também responsável por fazer o atraso. A subrotina faz isso movendo para a porta P1 o valor correspondente ao número que se deseja exibir, e em seguida, pulando para a subrotina _delay_, onde será feito o atraso. O código da subrotina é o seguinte:

```
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
```

#### Subrotina _delay_

A subrotina _delay é formada por duas outras subrotinas, _RESET_ e _COUNT\_TIMER_, e mais alguns comandos, como o movimento do valor do endereço 7Fh para o registrador R7, o qual fará uma contagem da quantidade de loops que será necessário da subrotina para que seja feito o atraso no tempo correto. Após isso, a subrotina _RESET_ é chamada, e após isso, a subrotina _COUNT\_TIMER_ é chamada. A subrotina _COUNT\_TIMER_ é responsável por fazer a contagem do tempo até que a flag de _overflow_ do sistema do timer seja atingida, e a subrotina _RESET_ é responsável por resetar o timer, colocando o valor para a contagem, e iniciando o timer. O valor escolhido para o timer é de 3036, de tal modo que considerando o timer como um registrador de 16 bits, tal que seu valor máximo é 65536, 65536-3036 = 62500, e 62500*16 = 1,000,000 us = 1s ou  62500*4 = 250000 us = 0.25s, facilitando os cálculos ao usar números inteiros.

Em seguida, 

```
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

	DJNZ R7, check_switches    ; Decrement R7. If it's not 0, jump to check_switches, does it until R7 = 0
    RET                 	   ; Returns from subroutine call
```

A cada loop de _delay_, no fim é é decrementado o valor de R7, e caso ele não seja 0, pula-se para a subrotina _check\_switches_, que verifica se alguma das chaves foi pressionada, e caso não tenha sido, RET retorna da subrotina para a subrotina _count_.

#### Subrotina _check\_switches_,

A subrotina _check\_switches_ é responsável por verificar se alguma das chaves foi pressionada (isto é, para verificar a cada loop se uma das chaves foi pressionada ou alterada), e caso tenha sido, uma das duas subrotinas, _update\_fullspeed_ ou _update\_quarterspeed_ será chamada de modo a .atualizar o valor de R7 para o valor de referência do intervalo de contagem desejado, caso nada tenha mudado, pular para a subrotina _RESET_, onde o timer será resetado e iniciado novamente. O código da subrotina é o seguinte:

```
; Checks which switch is pressed and updates the delay option accordingly 
check_switches:
	JNB P2.1, update_fullspeed 		; If Switch(1) = 0,	update to fullspeed
	JNB P2.2, update_quarterspeed 	; If Switch(2) = 0, update to quarterspeed
	JMP RESET						; Else, jumps back to RESET
```

#### Subrotinas _update\_fullspeed_ e _update\_quarterspeed_


As subrotinas _update\_fullspeed_ e _update\_quarterspeed_ são responsáveis por atualizar o valor de R7 para o valor de referência do intervalo de contagem desejado, e em seguida, pular para a subrotina _RESET_, onde o timer será resetado e iniciado novamente. O código das subrotinas é o seguinte:

```
; Updates the delay option to 1s 
update_fullspeed:
	MOV 7Fh, #fullsec 				; Loads 7Fh with 16 (repeats 16 times)
	JMP RESET						; Jumps back to RESET
```

```
; Updates the delay option to 0.25s
update_quarterspeed:
	MOV 7Fh, #quartersec 			; Loads 7Fh with 4 (repeats 4 times)
	JMP RESET						; Jumps back to RESET
```


## Diagrama e considerações finais

Um diagrama especificando o funcionamento e interação das subrotinas do programa pode ser visto abaixo:

![Diagrama de subrotinas](https://github.com/MatheusVBellini/MicrocontrollerProgramming/blob/main/8051-DigitalClock/diagrama.png)

Com isso, compreende-se o funcionamento do relógio digital conforme as especificações do trabalho. Vale notar que há imprecisões de 100-300us aproximadamente em cada uma das opções, devido ao tempo que cada operação leva para ser executada. Porém, isso não afeta o funcionamento do relógio dada a necessidade de precisão do projeto