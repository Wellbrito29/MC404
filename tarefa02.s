@wellington Nascimento
@ra178671
.org 0x30

ivetor: .word 0x400 @salva o endereço do inicio do vetor

.org 0x400
    vetor:
    .skip 400
.org 0x10
    divisor:
    .word 0
    num_elem:
    .word 0
    variav_div:
    .word 0
    .org 0x100
    variav_i:
    .word 0
    soma:
    .word 0
@@ novo teste

  inicio:   @ procura qual divisor eh (2,4,8)
  ld r2,divisor
  set r1,2
  cmp r1,r2
  jz div2
  set r1,4
  cmp r1,r2
  jz div4
  set r1,3 @divisao por 8
  st variav_div,r1
  jmp comec

  div2: @divisao por 2
  set r1,1
  st variav_div,r1
  jmp comec

  div4:
  set r1,2 @divisao por 4 
  st variav_div,r1
  jmp comec

  fim1: @um jump para o fim pois o jna nao suporta um pulo grande
  jmp fim

comec:
   ld r6,num_elem @carrega o numero de elementos
   ld r7,variav_i @carrega o i de um for
   cmp r6,r7
   jna fim1 @se acabar de percorrer vetor vai para o fim
   add r7,1
   st variav_i,r7
   ld r11,ivetor @carrega o endere do vetor
   ld r6,[r11] @carrega o conteudo
   set r10,0x0ffff @mascara para a palavra da direita
   and r6,r10 @ salva a parte da direita
   mov r8,r6 @r8 possui a palavra da direita
   set r1,0x8000 @mascara para ver se o num eh negativo
   and r8,r1
   cmp r8,r1
   jz trata_neg1 @se for trata o negativo
   cont2:
   ld r9,variav_div @carrega o divisor
   sar r6,r9 @realiza a divisao
   add r0,r6 @realiza a soma
   ld r4,[r11]
   set r10,0x0ffff0000 @mascara para a palavra da esquerda
   and r4,r10
   shr r4,16 @move para os ultimos bytes
   mov r8,r4
   and r8,r1 @checa se eh negativo
   cmp r8,r1
   jz trata_neg2 @trata se for negativo
   cont3:
   sar r4,r9 @realiza a divisao
   add r0,r4
   add r11,4
   add r7,1 @++i
   st variav_i,r7
   st ivetor,r11
   jmp comec @volta para o for

   trata_neg1: @trata o negativo
      set r10,0xffff0000
      or r6,r10
      jmp cont2

    trata_neg2: @trata o negativo da palavra a esquerda
      set r10,0xffff0000
      or r4,r10
      jmp cont3


   fim:
   hlt
