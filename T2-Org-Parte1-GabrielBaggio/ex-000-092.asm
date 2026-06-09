#***********************************************************************************************************************
# ex-000-092.asm               Copyright (C) 2023 Giovani Baratto
#
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# Descrição: Programa para ler e imprimir o elemento 1 de um vetor de strings
#
#***********************************************************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M       O                       #


.text

init:
            jal     main                    # executa o procedimento principal
finit:
            move	$a0, $v0                # $a0 <- código de retorno do programa
            li      $v0, 17                 # $v0 <- número do serviço exit2
            syscall                         # executamos o serviço exit 2

########################################################################################################################
########################################################################################################################
main:
# prólogo
            # não precisamos criar um quadro para o procedimento main
# corpo do procedimento
            la      $t0, vetor_strings      # $t0 <- endereço base do vetor
            li      $t1, 1                  # $t1 <- índice da string caneta
            li      $t2, 16                 # $t2 <- tamanho em bytes das strings (elementos do vetor)
            mul     $t3, $t1, $t2           # $t3 <- i * tam = deslocamento
            # Como o tamanho do elemento é 16 = 2 ^ 4, poderímos ter usado a instrução sll $t3, $t1, 4 para multiplicar
            add     $a0, $t0, $t3           # $a0 <- endereço efetivo do elemento vetor_strings[1]   
            li      $v0, 4                  # $v0 <- serviço 4: imprime uma string
            syscall                         # executamos  serviço para imprimir a string vetor_strings[1] 
# epílogo
            jr	    $ra                     # retornamos ao procedimento chamador
########################################################################################################################

.data
########################################################################################################################
########################################################################################################################
vetor_strings:
str0: .ascii "lápis de cor\0   "
str1: .ascii "caneta\0         "
str2: .ascii "borracha\0       "
str3: .ascii "papel\0          "
########################################################################################################################



      
