@wellington Nascimento ra:178671
LED1_STAT .equ 0x90  @ saida led 1
LED2_STAT .equ 0x91  @ saida led 2
BUTTON_READY .equ 1    @ bit READY
BUTTON_STAT .equ 0x40 @porta do botao
ESTAD_RED .equ 0X04 @sinal vermelho
ESTAD_YEL .equ 0X02 @sinal amarelo
ESTAD_GREEN .equ 0X01 @sinal verde
INT_TIMER   .equ 0x10 @tipo interrupcao

.org INT_TIMER*4  @posicao da interru

.word trata_timer @interrupcao do tipo 0x10


.org 0x2000

comec:
botao:   @           @ botao pronto para ser lido?
jmp    botao
trata_timer:
cmp   r6,r7 @compara para ver se sao iguais
jz estado_2
cmp   r6, r4 @compara para ver se esta verde o segundo sin
jz estado_1
set r9, 3 @seta a flag e deixa os 2 amarelo
outb LED1_STAT, r8
outb LED2_STAT, r8
mov r6, r8
mov r7, r8
iret @retorno da interrupcao
estado_1: @caso amarelo
set r9, 1
outb LED1_STAT, r8
outb LED2_STAT, r8
mov r6, r8
mov r7, r8
iret @retorno da interrupcao
estado_2:
cmp r9, r2 @ve o estado de qual rua esta
jz estado_2_3
outb LED1_STAT, r4 @primeira rua verde
outb LED2_STAT, r5 @segunda rua vermelha
mov r6, r4
mov r7, r5
set r9, 1
iret @retorno da interrupcao
estado_2_3:
outb LED1_STAT, r5 @primeira rua vermelho
outb LED2_STAT, r4 @segunda rua verde
mov r6, r5
mov r7, r4
set r9, 3
iret @retorno da interrupcao



inicio:
set sp,0x8000 @inicializ pilha
sti @inicializa as interrupcoes
ld r4,intervalo @valor do intervalo
set r5,0x50
out r5,r4 @coloca na porta o valor do intervalo
set r4,ESTAD_GREEN @seta os sinais nos registradores
set r5,ESTAD_RED
set r8,ESTAD_YEL
set r9,1 @flag de estados
outb LED1_STAT,r4 @inicializa as ruas 1 e 2
outb LED2_STAT,r5
mov r6, r4 @Move o verde para o r6
mov r7, r5 @move o vermelho para o r5
set   r2,BUTTON_READY @cria flag botao
jmp comec @chama a funcao



intervalo:
.word 1000
