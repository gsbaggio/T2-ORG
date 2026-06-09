# Autor: Gabriel Baggio

.data

x:            .word   0                       # int x; (variável global)
str_result:   .asciiz "O resultado e "        # string para printf
quebra_linha: .asciiz "\n"

.text                               

.globl main

#/************/
# int main(void)
#/************/
#{
#   int y;
#   int z;
#   x = 5;
#   y = 10;
#   z = media3x2y(x, y);
#   printf("O resultado e %d\n", z);
#   return 0;
#}

###############################################################################
# Mapa da memória para o procedimento `main`
#
#  | $ra  | $sp + 12    Endereço de retorno
#  | z    | $sp + 8     Variável local z
#  | y    | $sp + 4     Variável local y
#  | ---  | $sp + 0     (alinhamento)
###############################################################################
main:
###############################################################################
# Prólogo
        addiu       $sp, $sp, -16           # ajusta a pilha
        sw          $ra, 12($sp)            # salva o endereço de retorno

# x = 5;  (variável global)
        li          $t0, 5                  # $t0 <- 5
        la          $t1, x                  # $t1 <- endereço de x
        sw          $t0, 0($t1)             # x = 5

# int y; y = 10;
        li          $t0, 10                 # $t0 <- 10
        sw          $t0, 4($sp)             # y = 10

# z = media3x2y(x, y);
        la          $t1, x                  # $t1 <- endereço de x
        lw          $a0, 0($t1)             # $a0 <- x (1º argumento)
        lw          $a1, 4($sp)             # $a1 <- y (2º argumento)
        jal         media3x2y               # chama media3x2y(x, y)
        sw          $v0, 8($sp)             # z = media3x2y(x, y)

# printf("O resultado e %d\n", z);
# Serviço 4: imprime string
        la          $a0, str_result         # $a0 <- endereço da string
        li          $v0, 4                  # serviço 4: print_string
        syscall

# Serviço 1: imprime inteiro
        lw          $a0, 8($sp)             # $a0 <- z
        li          $v0, 1                  # serviço 1: print_int
        syscall

# printf("\n");
        la          $a0, quebra_linha       # $a0 <- endereço da string
        li          $v0, 4                  # serviço 4: print_string
        syscall

# Epílogo
        lw          $ra, 12($sp)            # restaura o endereço de retorno
        addiu       $sp, $sp, 16            # restaura a pilha

# termina o programa
        li          $a0, 0                  # retorna 0
        li          $v0, 17                 # serviço 17: exit2
        syscall
###############################################################################


#/*****************************/
# int media3x2y(int x, int y)
#/*****************************/
#{
#   int a;
#   int b;
#   a = 3 * x;
#   b = 2 * y;
#   if (x < y) {
#       troca(&a, &b);
#   }
#   while (a > b) {
#       a = a - 1;
#       b = b + 1;
#   }
#   return a;
#}

###############################################################################
# Mapa da memória para o procedimento `media3x2y`
#
#  | $ra  | $sp + 12    Endereço de retorno
#  | $s1  | $sp + 8     salva $s1 (y original)
#  | $s0  | $sp + 4     salva $s0 (x original)
#  | b    | $sp + 0     Variável local b (endereço usado em troca)
#
# Nota: a é mantida em $s0, b em $sp+0; passamos &a e &b via $a0/$a1
# Simplificação: usamos a pilha para a e b para poder passar endereços
###############################################################################
# Mapa da memória para o procedimento `media3x2y`
#
#  | $ra  | $sp + 20    Endereço de retorno
#  | y    | $sp + 16    argumento y (salvo)
#  | x    | $sp + 12    argumento x (salvo)
#  | b    | $sp + 4     Variável local b
#  | a    | $sp + 0     Variável local a
###############################################################################
media3x2y:
###############################################################################
# Prólogo
        addiu       $sp, $sp, -24           # ajusta a pilha
        sw          $ra, 20($sp)            # salva o endereço de retorno
        sw          $a0, 12($sp)            # salva x
        sw          $a1, 16($sp)            # salva y

# a = 3 * x;
        lw          $t0, 12($sp)            # $t0 <- x
        li          $t1, 3                  # $t1 <- 3
        mul         $t0, $t0, $t1           # $t0 <- 3 * x
        sw          $t0, 0($sp)             # a = 3 * x

# b = 2 * y;
        lw          $t0, 16($sp)            # $t0 <- y
        li          $t1, 2                  # $t1 <- 2
        mul         $t0, $t0, $t1           # $t0 <- 2 * y
        sw          $t0, 4($sp)             # b = 2 * y

# if (x < y) { troca(&a, &b); }
        lw          $t0, 12($sp)            # $t0 <- x
        lw          $t1, 16($sp)            # $t1 <- y
        bge         $t0, $t1, fim_if        # se x >= y, pula o if

        # x < y: chama troca(&a, &b)
        addiu       $a0, $sp, 0             # $a0 <- &a  (endereço de a na pilha)
        addiu       $a1, $sp, 4             # $a1 <- &b  (endereço de b na pilha)
        jal         troca                   # troca(&a, &b)

fim_if:

# while (a > b) { a = a - 1; b = b + 1; }
loop_while:
        lw          $t0, 0($sp)             # $t0 <- a
        lw          $t1, 4($sp)             # $t1 <- b
        ble         $t0, $t1, fim_while     # se a <= b, sai do while

        # a = a - 1;
        addi        $t0, $t0, -1            # $t0 <- a - 1
        sw          $t0, 0($sp)             # a = a - 1

        # b = b + 1;
        addi        $t1, $t1, 1             # $t1 <- b + 1
        sw          $t1, 4($sp)             # b = b + 1

        j           loop_while              # volta ao início do while

fim_while:

# return a;
        lw          $v0, 0($sp)             # $v0 <- a (valor de retorno)

# Epílogo
        lw          $ra, 20($sp)            # restaura o endereço de retorno
        addiu       $sp, $sp, 24            # restaura a pilha
        jr          $ra                     # retorna ao chamador
###############################################################################


#/***********************/
# void troca(int* x, int* y)
#/***********************/
#{
#   int tmp;
#   tmp = *x;
#   *x = *y;
#   *y = tmp;
#}

###############################################################################
# Mapa da memória para o procedimento `troca`
#  Procedimento folha: não chama outros procedimentos, não salva $ra
#
#  $a0 = ponteiro para x (int*)
#  $a1 = ponteiro para y (int*)
###############################################################################
troca:
###############################################################################
# Corpo do procedimento (sem prólogo de pilha, pois é procedimento folha)

# tmp = *x;
        lw          $t0, 0($a0)             # $t0 <- *x  (tmp = *x)

# *x = *y;
        lw          $t1, 0($a1)             # $t1 <- *y
        sw          $t1, 0($a0)             # *x = *y

# *y = tmp;
        sw          $t0, 0($a1)             # *y = tmp

# retorna (void)
        jr          $ra                     # retorna ao chamador
###############################################################################
