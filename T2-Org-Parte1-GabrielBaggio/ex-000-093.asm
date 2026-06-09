#***********************************************************************************************************************
# ex-000-092.asm               Copyright (C) 2023 Giovani Baratto
#
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# Descrição: Programa para ler e imprimir o elemento 1 de um vetor de ponteiros para strings
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
            la      $t0, vetor_ponteiros    # $t0 <- endereço base do vetor de ponteiros para strings
            lw      $a0, 4($t0)             # $a0 <- carregamos o ponteiro índice 1, que aponta para strings[1] 
            li      $v0, 4                  # $v0 <- serviço 4: imprime uma string
            syscall                         # executamos  serviço para imprimir a string strings[1] 
# epílogo
            jr	    $ra                     # retornamos ao procedimento chamador
########################################################################################################################

.data
########################################################################################################################
########################################################################################################################
strings:
str0: .ascii "lápis de cor\0"
str1: .ascii "caneta\0"
str2: .ascii "borracha\0"
str3: .ascii "papel\0"
vetor_ponteiros: .word str0, str1, str2, str3
########################################################################################################################



      
