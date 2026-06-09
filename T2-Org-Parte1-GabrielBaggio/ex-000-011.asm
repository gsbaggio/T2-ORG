#*******************************************************************************
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# Descrição: exemplo com procedimentos
# Assembler: MARS
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M       O                       #
################################################################################

################################################################################
.text                                       # Segmento de texto (código)
################################################################################

.globl main                                 # Declaração global para o rótulo `main`
 
#/************/
# int main(void)
#/************/
#{
#   int var0, var1, var2;
#   var0 = 10;
#   var1 = 20;
#   var2 = soma_incrementa(var0, var1);
#   return 0;
#}

###############################################################################
# Mapa da memória para o procedimento `main`
#
#  | $ra  | $sp + 12    Endereço de retorno
#  | var2 | $sp + 8     Variável local var2
#  | var1 | $sp + 4     Variável local var1
#  | var0 | $sp + 0     Variável local var0
###############################################################################
main:
###############################################################################
# Prólogo: Configuração inicial da pilha e salvamento do endereço de retorno.
        addiu       $sp, $sp, -16           # ajustamos a pilha (veja o mapa da memória)
        sw          $ra, 12($sp)            # Salva o endereço de retorno na pilha
  #int var0, var1, var2;        
# corpo do programa
  #var0 = 10;
        li          $a0, 10                 # $t0 <- 10
        sw          $a0, 0($sp)             # var0 = 10
  #var1 = 20;
        li          $a1, 20                 # $t1 <- 20
        sw          $a1, 4($sp)             # var1 = 20
  #var2 = soma_incrementa(var0, var1);  
        # $a0 = var0
        # $a1 = var1
        jal         soma_incrementa         # soma_incrementa(var0, var1)
        sw          $v0, 8($sp)             # var2 = soma_incrementa(var0, var1)
# Epílogo: Restauração do estado anterior da pilha e encerramento do programa.
        lw          $ra, 12($sp)            # restauramos o endereço de retorno
        addiu       $sp, $sp, 16            # restauramos a pilha para o valor original
        #jr         $ra                     # Em um programa escrito em C, o procedimento
                                            # main retorna a outros códigos que terminam 
                                            # o programa. 
        # Neste curso vamos admitir que o procedimento main é o primeiro procedimento
        # executado. Neste caso, fazemos uma chamada ao sistema para encerrar o programa.
# terminamos o programa
        li          $a0, 0                  # retornamo o valor 0: programa executado com sucesso
        li          $v0, 17                 # serviço 17, termina o programa
        syscall                             # executamos o serviço
###############################################################################

#/*****************************************/
# int soma_incrementa(int valor1, int valor2) 
#/*****************************************/
#{
#   int soma;
#   int resultado;
#   soma = valor1 + valor2;
#   resultado = incrementa(soma);
#   return resultado;
#}
###############################################################################
# Mapa da memória para o procedimento `soma_incrementa`
#
#  |  $ra       | $sp + 8    Endereço de retorno
#  |  resultado | $sp + 4    Variável local resultado
#  |  soma      | $sp + 0    Variável local soma
###############################################################################
# Obs.: Este procedimento pode ser otimizado. As variáveis resultado e soma podem
#       ser mantidas em registradores.
#
#       addiu       $sp, $sp, -12            # ajustamos a pilha
#       sw          $ra, 0($sp)             # guardamos na pilha o endereço de retorno
#       add         $a0, $a0, $a1           # $a0 <- valor1 + valor2
#       jal         incrementa              # $v0 <- incrementa(soma)
#       lw          $ra, 0($sp)             # restauramos o endereço de retorno
#       addiu       $sp, $sp, 12             # restauramos a pilha
#       jr          $ra                     # retornamos ao procedimento chamador
soma_incrementa:
###############################################################################
# Prólogo: Configuração inicial da pilha e salvamento do endereço de retorno.
        addiu       $sp, $sp, -12            # ajustamos a pilha
        sw          $ra, 8($sp)             # guardamos na pilha o endereço de retorno
  #int soma;
  #int resultado;
# corpo do programa
   #soma = valor1 + valor2;
        add         $a0, $a0, $a1           # $a0 <- valor1 + valor2
        sw          $a0, 0($sp)             # soma = valor1 + valor2
#resultado = incrementa(soma);        
        jal         incrementa              # $v0 <- incrementa(soma)
        sw          $v0, 4($sp)             # resultado = incrementa(soma)
# Epílogo: Restauração do estado anterior da pilha e retorno ao chamador.
        lw          $ra, 8($sp)             # restauramos o endereço de retorno
        addiu       $sp, $sp, 12             # restauramos a pilha
        jr          $ra                     # retornamos ao procedimento chamador
###############################################################################



#/************************/
# int incrementa(int valor1)
#/************************/
#{
#   int resultado;
#   resultado = valor1 + 1;
#   return resultado;
#}
###############################################################################
# Mapa da memória para o procedimento `incrementa`
#
#  |  resultado | $sp + 0     Variável local resultado
###############################################################################
# Obs.: Este procedimento é um procedimento folha. Ele não chama outros procedimentos.
#       Neste caso, não é necessário armazenar na pilha o endereço de retorno de $ra.
# Obs2.: A variável resultado poderia ter sido mantida em um registrador. Assim, o
#       quador do procedimento na pilha poderia ser eliminado. O código otimizado seria:
#       
#       addi        $v0, $a0, 1             # resultado = valor + 1
#       jr          $ra                     # retornamos ao procedimento chamador
incrementa:
###############################################################################
# Prólogo: Configuração inicial da pilha.
        addiu       $sp, $sp, -4            # ajustamos a pilha
  #int resultado;        
# corpo do programa
#resultado = valor1 + 1;
        addi        $v0, $a0, 1             # $v0 <- valor1 + 1
        sw          $v0, 0($sp)             # resultado = valor1 + 1
# Epílogo: Restauração do estado anterior da pilha e retorno ao chamador.
        addiu       $sp, $sp, 4             # restauramos a pilha
        jr          $ra                     # retornamos ao procedimento chamador
###############################################################################


