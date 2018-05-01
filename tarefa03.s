@wellington brito - ra178681
KEYBD_DATA .equ 0x80  @ porta de dados
KEYBD_STAT .equ 0x81  @ porta de estado
KEYBD_READY .equ 1    @ bit READY
DISPLAY_DATA .equ 0x40 @porta do display
.org 0x2000
read:
set   r2,KEYBD_READY
le_tecla1:
inb   r3,KEYBD_STAT   @ l^e porta de estado
tst   r2,r3           @ dado pronto para ser lido?
jz    le_tecla1       @ espera que dado esteja pronto
inb   r0,KEYBD_DATA   @ le porta de dados
le_tecla2:
inb   r3,KEYBD_STAT   @ l^e porta de estado
tst   r2,r3           @ dado pronto para ser lido?
jz    le_tecla2       @ espera que dado esteja pronto
inb   r1,KEYBD_DATA   @ le porta de dados
ret

display:
set r2,tab_digitos @ indexa valor lido no vetor de d´ıgitos
add r2,r0 @ para determinar a configura¸c~ao de bits
ldb r6,[r2] @ a ser escrita no mostrador
outb DISPLAY_DATA,r6 @ envia para o mostrador
ret


inicio:
set sp,0x8000 @inicializ pilha
call display @inicia a o display
comec_loop: @ inicializa o loop
set r5,10
cmp r5,r1 @marca o fim
jz fim
call read @chama o teclado
add r4,r0 @realiza a soma
mov r0,r4
call display
jmp comec_loop
fim:
hlt

tab_digitos: @mascara do display
.byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1f,0x4e,0x3d,0x4f,0x47
