#*******************************************************************************
# ex-000-014.s               Copyright (C) 2022 Giovani Baratto
# This program is free software under GNU GPL V3 or later version
# see http://www.gnu.org/licences
#
# Autor: Giovani Baratto (GBTO) - UFSM - CT - DELC
# e-mail: giovani.baratto@ufsm.br
# versão: 0.2
# Descrição: Copia a string1 na string2 e imprime.
# Documentação:
# Assembler: MARS
# Revisões:
# Rev #  Data           Nome   Comentários
# 0.1    ????           GBTO   versão inicial
# 0.2    10/01/2022     GBTO   corrigida o procedimento copiaString
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M       O                   #
.text
.globl      main

# Este programa copia a string1 na string2 e em seguida
# imprime a string2

###############################################################################
# Procedimento principal
# Copia string1 em string2 e imprime string2
#int main(void)
#{
main:
###############################################################################

#copiaString(string1, string2);
            la      $a0, string1        # a0 <- &string1
            la      $a1, string2        # a1 <- &string2
            jal     copiaString         # chama a função copiaString: copia a string1 na string2
            # imprime a string2
#printf("%s\n", string2);
            # Usamos uma chamada ao sistema para imprimir a string. Não será desenvolvido
            # o procedimento printf.
            li      $v0, 4              # serviço 4 - imprime uma string
            la      $a0, string2        # a0 <- endereço da string terminada com um zero (nulo)
            syscall                     # chamada ao sistema
            li      $v0, 11             # serviço 11 - imprime o caractere de $a0
            li      $a0, '\n'           # $a0 <- nova linha
            syscall                     # chamamos o sistema
            #return 0;
            li      $a0, 0              # main retorna 0
            li      $v0, 17             # serviço 17 - término do programa
            syscall                             # chamada ao sistema
#}

###############################################################################
# Procedimento copiaString
# copia a string s1 na string s2
#void copiaString(char *s1, char *s2)
#{
copiaString:
# argumentos
#   $a0 : endereço da string s1
#   $a1 : endereço da string s2
#
###############################################################################
# prólogo
# corpo do programa
            j       copia_string_testa_while
#while(*s1 != '\0'){
copia_string_while:
#*s2 = *s1;
            #lw      $t0, 0($a0)         # $t1 <-*s1
            # esta instrução não é necessária porque $t0 contém o caractere apontado
            # por s1
            sb      $t0, 0($a1)         # *s2 = *s1
#s2++;
            addiu   $a0, $a0, 1         # s2++
#s1++;
            addiu   $a1, $a1, 1         # s1++
copia_string_testa_while:
#while(*s1 != '\0'){
            lb      $t0, 0($a0)         # $t0 <- *s1
            bne     $t0, $zero, copia_string_while
#}
#*s2 = '\0';
            sb     $zero, 0($a1)        # *s2 = '\0'
# epílogo
            jr      $ra                 # retorna para o procedimento chamador

.data
string1:    .asciiz "teste de uma string\0xxxxxx"
string2:    .asciiz "???????????????????????????"
