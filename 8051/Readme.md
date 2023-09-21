# Respostas das Questões
## Exercício 1
(a) O tempo de cada instrução está especificado nos comentários do código "Exercise1.asm". O tempo total de execução, descontando o tempo da instrução final "SJMP $" foi de 20 us.

(b) Cada ciclo de máquina do 8051 dura 1 us, isso significa que o programa, descontando a instrução final "SJMP $", possui 20 ciclos de máquina.

(c) Os valores dos cada um dos 8 bits de P1 foram passados para ACC como um valor de 2 bytes. Esse valor foi FFh, pois os Ports 0-3 do 8051 são automaticamente inicializados para o valor binário 11111111b.

(d) O valor que ACC assumiu ao passar R1 indiretamente para ele foi o que havia contido no endereço 7Eh, que, nesse caso, era FFh.

(e) Foi possível mover um valor de 4 digitos hexadecimais para DPTR, pois DPTR é composto de 2 outros registradores de 8 bits, DPH e DPL, portanto 2 digitos foram colocados em DPH e 2 outros em DPL. Dito isso, o maior valor que pode ser passado para DPTR é FFFFh.

## Exercício 2
Ao realizar o teste descrito, o bit menos significativo de PSW é 1 quando ACC é 4 e 0 quando ACC é 3, pois esse bit contém a informação da "Parity Flag", isto é, quando o acumulador contém um número par, essa flag é 1, quando contém um ímpar, a flag é 0. 
