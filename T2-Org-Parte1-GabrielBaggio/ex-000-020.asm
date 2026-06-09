#*******************************************************************************
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# Descrição: exemplo de procedimento que chamam outros procedimentos
# Assembler: MARS
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M       O                       #
################################################################################
.text
.globl main

# programa que retorna a soma do maior e do menor valor de 
# uma lista

###############################################################################
# Inicia o programa
###############################################################################
init:
            jal   main          # vai para o procedimento principal
            j     finit         # termina o programa

            
###############################################################################
# Termina o programa
###############################################################################
finit:
            move  $a0, $v0      # o valor de retorno de main é colocado em $a0
            li    $v0, 17       # serviço 17: termina o programa
            syscall             # fazemos a chamada ao serviço 17.
    

# int menorValor(int a0, int a1, int a2)
# {
#   int menor;
#   menor = a0;
#   if (a1 < menor) menor = a1;
#   if (a2 < menor) menor = a2;
#   return menor;
# }
#
#       Mapa da Pilha
#       ----------------------------
#       Variável | Endereço na Pilha 
#       ----------------------------
#       menor    |  $sp + 0
#       -----------------------------
# 
# Obs.: este código poderia ter sido otimizado. A variável menor poderia ter sido
# maintida em um registrador

menorValor:
# prólogo
#   int menor;
            addi  $sp, $sp, -4  # Reservamos na pilha espaço para 2 itens
# corpo do procedimento
#   menor = a0;
            sw    $a0, 0($sp)   # menor = a0
#   if (a1 < menor) menor = a1;   
            lw    $t0, 0($sp)   # $t0 <- menor 
            blt   $a1, $t0, a1_menor # $a1 < menor?    
# a1 >= menor
            j testa_a2_menor    # nenhuma ação
a1_menor:
            sw    $a1, 0($sp)   # menor = a1
testa_a2_menor:    
#   if (a2 < menor) menor = a2;
            lw   $t0, 0($sp)    # $t0 <- menor
            blt  $a2, $t0, a2_menor
# a2 >= menor
            j fim_compara_menor # nenhuma ação
a2_menor:
            sw   $a2, 0($sp)    # menor = a2
fim_compara_menor:
# epílogo
# return menor
            lw   $v0, 0($sp)    # valor de retorno é igual a menor
            addi $sp, $sp, 4    # restauramos a pilha
            jr   $ra            # retorna ao procedimento chamador


# int maiorValor(int a0, int a1, int a2)
# {
#   int maior;
#   maior = a0;
#   if (a1 > maior) maior = a1;
#   if (a2 > maior) maior = a2;
#   return maior;
# }
#       Mapa da Pilha
#       ----------------------------
#       Variável | Endereço na Pilha 
#       ----------------------------
#       maior    | $sp + 0
#       ----------------------------
# 
# Obs.: este código poderia ter sido otimizado. A variável maior poderia ter sido
# mantida em um registrador
maiorValor:
# prólogo
#   int maior;
            addi  $sp, $sp, -4  # ajustamos a pilha
# corpo do procedimento
#   maior = a0;
            sw    $a0, 0($sp)   # maior = a0
#   if (a1 > maior) maior = a1;
            lw    $t0, 0($sp)   # $t0 <- maior
            bgt   $a1, $t0, a1_maior # se a1> maior a1_maior
# a1 <= maior
            j testa_a2_maior    # nenhum ação
a1_maior:
            sw    $a1, 0($sp)   # maior = a1  
testa_a2_maior:
#   if (a2 > maior) maior = a2;
            lw    $t0, 0($sp)   # $t0 <- maior
            bgt   $a2, $t0, a2_maior # se a2>maior a2_maior
# a2 <= maior
            j fim_compara_maior # nenhuma ação
a2_maior:    
            sw   $a2, 0($sp)    # maior  = a2
fim_compara_maior:
# epílogo
#   return maior;
            lw   $v0, 0($sp)
            addi $sp, $sp, 4    # restaura a pilha
            jr   $ra            # retorna ao procedimento chamador            


# int soma_maior_menor(int a0, int a1, int a2)
# {
#   int maior;
#   int menor;
#   maior = maiorValor(a0, a1, a2);
#   menor = menorValor(a0, a1, a2);
#   return maior + menor;
# }
#
#       Mapa da Pilha
#       ----------------------------
#       Variável | Endereço na Pilha 
#       ----------------------------
#           $a2  |    $sp + 24
#           $a1  |    $sp + 20
#           $a0  |    $sp + 16
#           $ra  |    $sp + 12  endereço de retorno - procedimento não é folha
#           maior|    $sp + 8
#           menor|    $sp + 4
#           soma |    $sp + 0
#       ----------------------------
# 
# Obs.: este código poderia ter sido otimizado. Variáveis poderiam ter sido
# maintidas em um registradores, sem a necessidade do uso da pilha.
soma_maior_menor:
    # prólogo
#   int maior;
#   int menor;   
#   int soma;
            addi  $sp, $sp, -28 # ajustamos a pilha
            sw    $ra, 12($sp)   # armazena $ra
# corpo do procedimento
# precisamos armazenar $a0, $a1 e $a2 porque após a chamada ao procedimento
# maiorValor, o valor destes registradores é desconhecido
            sw    $a0, 16($sp)  # guardamos na pilha a0
            sw    $a1  20($sp)  # guardamos na pilha a1
            sw    $a2, 24($sp)  # guardamos na pilha a2
# maior = maiorValor(a0, a1, a2);            
            jal maiorValor
            sw    $v0, 8($sp)   # maior = maiorValor(a0, a1, a2);            
# restauramos os valores de a0, a1 e a2       
            lw    $a2, 24($sp)  # restauramos o valor de a2
            lw    $a1, 20($sp)  # restauramos o valor de a1
            lw    $a0, 16($sp)  # restauramos o valor de a0
# menor = menorValor(a0, a1, a2);
            jal   menorValor
            sw    $v0, 4($sp)   # menor = menorValor(a0, a1, a2);
# soma = maior + menor;         
            lw    $t0, 8($sp)   # $t0 <- maior
            lw    $t1, 4($sp)   # $t1 <- menor
            add   $v0, $t0, $t1 # $v0 <-maior + menor
            sw    $v0, 0($sp)   # soma <- maior + menor
# return soma
            # $v0 já possui o valor da soma.
#epílogo
            lw    $ra, 12($sp)    # restaura $ra
            addi  $sp, $sp,28    # libera o espaço na pilha
            jr    $ra            # retorna maior+menor


# int main(void)
# {
#   int k;
#   k = 1000;
#   k = soma_maior_menor(3,1,2);
#   printf("A soma do maior e menor valor da lista é %d\n",k );
#   return 0;
# }
# procedimento main
#
#
#       Mapa da Pilha
#       ----------------------------
#       Variável | Endereço na Pilha 
#       ----------------------------
#           $ra  |   $sp + 4
#           k    |   $sp + 0
#       ----------------------------
main:
# prólogo
# int k;
            addi  $sp, $sp, -8  # reserva na pilha um espaço para k e endereço de retorno
            sw    $ra, 4($sp)   # armazena na pilha o endereço de retorno
# corpo do procedimento    
# k = 1000
            addiu $t0, $zero, 1000
            sw    $t0, 0($sp)
#   k = soma_maior_menor(3,1,2);    
            li    $a0, 3        # Os argumentos da função são guradados em $a0 a $a2
            li    $a1, 1
            li    $a2, 7
            jal   soma_maior_menor # chamamos o procedimento soma_maior_menor
            sw    $v0, 0($sp)   # k = soma_maior_menor()
#   printf("A soma do maior e menor valor da lista é %d\n",k );    
            la    $a0, msg_01   # imprime a mensagem
            li    $v0, 4
            syscall
            lw      $a0, 0($sp) # imprime k
            li    $v0, 1
            syscall
            li    $a0, '\n'     # imprime um retorno de carro
            li    $v0, 11
            syscall
# epílogo    
# return 0;
            li    $v0, 0        # retorna 0
            lw    $ra, 4($sp)   # restaura o endereço de retorno
            addi  $sp, $sp, 8   # restauramos a pilha
            jr    $ra           # retorna ao procedimento chamador
end_main:

.data
    msg_01: .asciiz "A soma do maior e do menor valor da lista é "

