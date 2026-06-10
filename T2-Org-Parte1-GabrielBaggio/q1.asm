# Nome: Gabriel Souza Baggio

# Obs.: Fiz algumas coisas a mais um pouco desnecessárias, como o prologo na main guardando $ra,
#       mas queria treinar pra sempre guardar o endereco de retorno e variaveis locais da função na pilha.

.data
        x: .word 0                     # int x;
        str: .asciiz "O resultado e " 
        quebra_linha: .asciiz "\n"

.text
.globl main

        # Mapa de registradores:
        # Utilizo $s0 como o endereço da variável global 'x'

main:
        # --- Prólogo ---
        # $ra ($sp + 8) Endereço de retorno
        # 'z' ($sp + 4) Variável local z
        # 'y' ($sp + 0) Variável local y
        # Total de deslocamento da pilha: (12)
        addiu $sp, $sp, -12
        sw $ra, 8($sp)

        # --- Corpo ---
        la $s0, x # Carregando o endereco de x (variavel global)

        # x = 5
        addi $t0, $zero, 5  # Carrega 5 em t0
        sw $t0, 0($s0)      # Salva 5 no endereco de x

        # y = 10
        addi $t0, $zero, 10 # Carrega 10 em t0
        sw $t0, 0($sp)      # Salva 10 no endereco de pilha de y

        # z = media3x2y(x, y)
        lw $a0, 0($s0)      # Carrega o valor de x em a0
        lw $a1, 0($sp)      # Carrega o valor de y em a1
        jal media3x2y       # Chama media3x2y com x e y como argumentos
        sw $v0, 4($sp)      # valor retornado em $v0 salvo no endereco de pilha de z

        # printf("O resultado e %d\n", z);
        addi $v0, $zero, 4  # Servico 4 (print string)
        la $a0, str
        syscall

        addi $v0, $zero, 1  # Servico 1 (print int)
        lw $a0, 4($sp)      # Carrega o valor no endereco de pilha de z em a0
        syscall

        addi $v0, $zero, 4  # Servico 4 (print string)
        la $a0, quebra_linha
        syscall

        # --- Epílogo ---
        lw $ra, 8($sp)      # Restaura o endereco de retorno
        addiu $sp, $sp, 12  # Restaura o espaco da pilha

        # return 0
        addi $v0, $zero, 17 # Servico 17 (exit)
        addi $a0, $zero, 0  # Valor de retorno 0
        syscall

media3x2y:
        # Parâmetros
        # $a0 = x
        # $a1 = y

        # --- Prólogo ---
        # $ra ($sp + 8) Endereço de retorno
        # 'b' ($sp + 4) Variável local b
        # 'a' ($sp + 0) Variável local a
        # Total de deslocalmento da pilha: (12)
        addiu $sp, $sp, -12
        sw $ra, 8($sp)

        # --- Corpo ---
        # a = 3 * x
        addi $t0, $zero, 3     # Carrega 3 em t0
        mul $t0, $t0, $a0      # Faz a multiplicacao (3 * x)
        sw $t0, 0($sp)         # Salva 3 * x em a

        # b = 2 * y
        addi $t0, $zero, 2     # Carrega 2 em t0
        mul $t0, $t0, $a1      # Faz a multiplicacao (2 * y)
        sw $t0, 4($sp)         # Salva 2 * y em b

        # if (x < y)
        slt $t0, $a0, $a1      # $t0 = 1 se x < y, senao $t0 = 0
        beq $t0, $zero, while  # Se $t0 for 0, pula para while

        # troca(&a, &b)
        addiu $a0, $sp, 0      # Passa o endereco de a como parametro
        addiu $a1, $sp, 4      # Passa o endereco de b como parametro
        jal troca

while:
        # while (a > b)
        lw $t0, 0($sp)          # Carrega o valor de a em t0
        lw $t1, 4($sp)          # Carrega o valor de b em t1
        ble $t0, $t1, fim_while # Se a <= b, pula para fim_while

        # a = a - 1
        addi $t0, $t0, -1       # Decrementa a em 1
        sw $t0, 0($sp)          # Salva a atualizado

        # b = b + 1
        addi $t1, $t1, 1        # Incrementa b em 1
        sw $t1, 4($sp)          # Salva b atualizado

        j while

fim_while:
        # return a
        lw $v0, 0($sp)          # Carrega o valor de a em v0

        # --- Epílogo ---
        lw $ra, 8($sp)          # Restaura o endereco de retorno
        addiu $sp, $sp, 12      # Restaura o espaco da pilha
        jr $ra                  # Retorna ao procedimento chamador


troca:
        # Parametros:
        # $a0 = *x
        # $a1 = *y

        # --- Prólogo ---
        # $ra ($sp + 4) Endereço de retorno
        # 'tmp' ($sp + 0) Variável local tmp
        # Total de deslocalmento da pilha: (8)
        addiu $sp, $sp, -8
        sw $ra, 4($sp)

        # --- Corpo ---
        # tmp = *x
        lw $t0, 0($a0)    # Carrega o valor de x em t0
        sw $t0, 0($sp)    # Salva em tmp o valor de x

        # *x = *y
        lw $t1, 0($a1)    # Carrega o valor de y em t1
        sw $t1, 0($a0)    # Salva em x o valor de y

        # *y = tmp
        lw $t0, 0($sp)    # Carrega o valor de tmp em t0
        sw $t0, 0($a1)    # Salva em y o valor de tmp

        # --- Epílogo ---
        lw $ra, 4($sp)      # Restaura o endereco de retorno
        addiu $sp, $sp, 8   # Restaura o espaco da pilha
        jr $ra              # Retorna ao procedimento chamador