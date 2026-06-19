# nome: Gabriel Souza Baggio

.data
    x_val:      .double 0.31       # Valor de teste (x = 0.31 radianos)
    const_um:  .double 1.0        # Constante 1.0 (usada para soma e incrementos)
    const_zero: .double 0.0        # Constante 0.0 (usada para inicializar o contador)
    msg_cos:    .asciiz "cos(x) = "
    msg_quebra:     .asciiz "\n"

.text
.globl main

main:
    # 1. Imprimir a string de introducao
    li $v0, 4                      # syscall 4: print string
    la $a0, msg_cos                # Carrega o endereco da mensagem
    syscall

    # 2. Preparar argumento e chamar o procedimento 'cos'
    la $t0, x_val                  # Carrega o endereco de x_val
    l.d $f12, 0($t0)               # Carrega 0.31 no registrador $f12
    jal cos                        # Salta para o procedimento 'cos' e salva o retorno em $ra

    # 3. Imprimir o resultado
    # O procedimento 'cos' retorna o resultado em $f0.
    # O syscall 3 (print double) exige que o valor a ser impresso esteja em $f12.
    mov.d $f12, $f0                # Move o resultado de $f0 para $f12
    li $v0, 3                      # syscall 3: print double precision
    syscall

    # 4. Imprimir quebra de linha
    li $v0, 4                      # syscall 4: print string
    la $a0, msg_quebra
    syscall

    # 5. Finalizar o programa
    li $v0, 10                     # syscall 10: exit
    syscall

cos:
    # Argumentos:   $f12 = x (angulo em radianos)
    # Retorno:      $f0 = cos(x)

    la $t0, const_um
    l.d $f8, 0($t0)                # $f8 = 1.0 (Constante para incrementar o denominador)
    
    la $t0, const_zero
    l.d $f6, 0($t0)                # $f6 = 0.0 (Contador do divisor do fatorial)

    mov.d $f0, $f8                 # $f0 = S = 1.0 (Soma acumulada, comeca com o termo n=0)
    mov.d $f2, $f8                 # $f2 = T = 1.0 (Termo atual da iteracao)

    # --- calcular -x^2 ---
    # Multiplicar o termo atual por -x^2 inverte o sinal e eleva a potencia em +2
    mul.d $f4, $f12, $f12          # $f4 = x * x (x^2)
    neg.d $f4, $f4                 # $f4 = -x^2

    # --- configurar loop de n=1 ate 7 ---
    li $t1, 7                      # Contador do loop em registrador inteiro

cos_loop:
    beqz $t1, cos_end              # Se n chegou a 0, termina o loop

    # Passo 1: Multiplicar o termo anterior por -x^2 (Cobre o sinal e a potencia de x)
    mul.d $f2, $f2, $f4            # T = T * (-x^2)

    # Passo 2: Dividir pela primeira parte do fatorial (2n - 1)
    add.d $f6, $f6, $f8            # C = C + 1.0
    div.d $f2, $f2, $f6            # T = T / C

    # Passo 3: Dividir pela segunda parte do fatorial (2n)
    add.d $f6, $f6, $f8            # C = C + 1.0
    div.d $f2, $f2, $f6            # T = T / C

    # Passo 4: Adicionar o novo termo calculado a soma total
    add.d $f0, $f0, $f2            # S = S + T

    # Decrementar contador e repetir
    sub $t1, $t1, 1                # Reduz 1 do contador de iteracoes
    j cos_loop                     # Volta para o inicio do loop

cos_end:
    jr $ra                         # Retorna para o chamador (main). O resultado ja esta em $f0.