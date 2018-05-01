@wellington Nascimento ra:178671
LED1_STAT .equ 0x90  @ saida led 1
LED2_STAT .equ 0x91  @ saida led 2
BUTTON_READY .equ 1    @ bit READY
BUTTON_STAT .equ 0x40 @porta do botao
ESTAD_RED .equ 0X04 @sinal vermelho
ESTAD_YEL .equ 0X02 @sinal amarelo
ESTAD_GREEN .equ 0X01 @sinal verde
INT_TIMER   .equ 0x10

.org INT_TIMER*4

.word trata_timer


.org 0x2000

comec:
botao:   @ le o botao
tst   r2,r3          @ botao pronto para ser lido?
jz    botao
cmp   r6,r7 @compara para ver se sao iguais
jz estado_2
cmp   r6, r4 @compara para ver se esta verde o segundo sin
jz estado_1
set r9, 3 @seta a flag e deixa os 2 amarelo
outb LED1_STAT, r8
outb LED2_STAT, r8
mov r6, r8
mov r7, r8
jmp botao
estado_1: @caso amarelo
set r9, 1
outb LED1_STAT, r8
outb LED2_STAT, r8
mov r6, r8
mov r7, r8
jmp botao
estado_2:
cmp r9, r2 @ve o estado de qual rua esta
jz estado_2_3
outb LED1_STAT, r4 @primeira rua verde
outb LED2_STAT, r5 @segunda rua vermelha
mov r6, r4
mov r7, r5
set r9, 1
jmp botao
estado_2_3:
outb LED1_STAT, r5 @primeira rua vermelho
outb LED2_STAT, r4 @segunda rua verde
mov r6, r5
mov r7, r4
set r9, 3
jmp botao
ret


inicio:
set sp,0x8000 @inicializ pilha
sti
set r4,ESTAD_GREEN @seta os sinais nos registradores
set r5,ESTAD_RED
set r8,ESTAD_YEL
set r9,1 @flag de estados
outb LED1_STAT,r4 @inicializa as ruas 1 e 2
outb LED2_STAT,r5
mov r6, r4 @Move o verde para o r6
mov r7, r5 @move o vermelho para o r5
set   r2,BUTTON_READY @cria flag botao
call comec @chama a funcao

trata_timer:
push r3
mov r3,1
pop r3
iret
