.text
.globl main
############################################################
# Procedimento inicial
# Este procedimento imprime a data e uma descricao de eventos, alocados em uma cadeia de estruturas.
# A cadeia e impressa na ordem direta e em seguida na ordem reversa
############################################################
main:
	# imprime os eventos em ordem direta
	la 		$s0, ptrFirst			# $s0 <- endereço do apontador para o primeiro elemento da cadeia
	lw 		$s0, 0($s0) 			# $s0 <- endereço do primeiro elemento da cadeia
loop1: 
	beq 	$s0, $zero, fimLoop1	# Se o endereço e zero, a cadeia de estruturas terminou
	move 	$a0, $s0				# $a0 <- endereço de uma estrutura	
	jal 	apresentaEvento			# imprime a data e o evento armazenado na estrutura
	addi	$s0, $s0, 8				# $s0 <- carrega o apontador para o proximo elemento da cadeia
	lw 		$s0, 0($s0)				# $s0 <- carrega o endereco do proximo elemento
	j 		loop1					# repete
fimLoop1:
	# imprime os eventos em ordem reversa
	la 		$s0, ptrLast			# $s0 <- aponta para o ultimo elemento da cadeia
	lw 		$s0, 0($s0)				# $s0 <-  endereco do ultimo elemento da cadeia
loop2:
	beq 	$s0, $zero, fimLoop2	# se  o endereço e zero, a cadeia terminou
	move 	$a0, $s0				# $a0 <- endereco de uma estrutura
	jal 	apresentaEvento			# imprime a data e o evento armazenado na estrutura
	addi 	$s0, $s0, 12 			# $s0 <- endereco do apontador para o elemento anterior
	lw 		$s0, 0($s0)				# $s0 <- endereco do elemento anterior
	j 		loop2					# repete
fimLoop2:
	# fim do programa
	jal exit
############################################################


############################################################
apresentaData:
	# prologo
	sub $sp, $sp, 8 	#  ajusta a pilha para duas palavras
	sw  $ra, 4($sp)		#  guarda $ra, o endereço de retorno (nao e necessario neste procedimento)
	sw  $a0, 0($sp)		# guarda $a0, o endereço da estrutura
	# escreve o dia
	lb 	$a0, 7($a0)		#  $a0 <- dia
	li 	$v0, 1			# servico para imprimir um inteiro
	syscall 			# executa uma chamada ao sistema
	# adiciona um traco
	li 	$a0, '-'		# $a0 <- caracter a ser impresso
	li 	$v0, 11			# serviço para imprimir um carcacter
	syscall				# executa uma chamada ao sistema
	# escreve o mes
	lw 	$a0, 0($sp)		# restaura o endereco da estrutura
	lb 	$a0, 6($a0) 	# $a0 <- mes
	li 	$v0, 1			# serviço para imprimir um inteiro de $a0
	syscall				# executa uma chamada ao sistema
	#adiciona um tracao
	li 	$a0, '-'		# $a0 <- caracter a ser impresso
	li 	$v0, 11			# serviço para imprimir um caracter
	syscall				# executa uma chamada ao sistema
	# escreve o ano
	lw 	$a0, 0($sp)		# restaura o endereço da estrutura
	lh 	$a0, 4($a0)		# $a0 <- ano
	li 	$v0, 1			# serviço para imprimir um inteiro em $a0
	syscall				# executa a chamada ao sistema
	# epilogo	
	lw 	$ra, 4($sp)		# restaura o endereço de retorno
	lw 	$a0, 0($sp)		# restaura o argumento $a0 do procedimento
	add $sp, $sp, 8		# elimina dois itens (palavras) da pilha
	jr 	$ra				# retorna a funçao chamadora
############################################################

############################################################
apresentaEvento:
	# epilogo
	sub $sp, $sp, 8		# ajusta a pilha para guradar dois itens
	sw  $ra, 4($sp)		# guarda na pilha o endereço de retorno
	sw  $a0, 0($sp)		# guarda na pilha o argumento $a0 (endereço da estrutura)
	# imprime a data do evento
	jal apresentaData	# imprime a data do evento
	# imprime um espaço 
	li  $a0, ' '		# $a0 <- caracter a ser impresso (um espaço)	
	li  $v0, 11			# serviço para a impressao do caracter em $a0
	syscall				# executa uma chamada ao sistema
	# imprime a descriçao do evento
	lw  $a0, 0($sp)		# restaura o endereço da estrutura
	lw  $a0, 0($a0)		# $a0 <- endereço da string com a descriçao do evento
	li  $v0, 4			# serviço para imprimir uma string
	syscall				# executa uma chamada ao sistema
	# prologo
	lw  $a0, 0($sp)		# restaura o argumento $a0
	lw  $ra, 4($sp)		# restaura o endereço de retorno
	add  $sp, $sp, 8	# elimina dois itens da pilha
	jr $ra				# retorna a funçao chamadora
############################################################

############################################################
exit:
	li $a0, 0			# valor de retorno do programa
	li $v0, 17			# serviço para sair do programa: exit 2
	syscall				# executa uma chamada ao sistema
############################################################

		
.data 
	


	ptrFirst: 		.word ptrEvento1 	# apontador para o primeiro elemento da estrutura
	ptrLast: 		.word ptrEvento3 	# apontador para o ultimo elemento da estrutura


	# elemento 0 da estrutura
	ptrEvento1:	.word evento1 			# aponta para uma string: cadeia de caracteres. Descriçao do evento
	ano1: 		.half 1551				# um inteiro de 16 bits. Ano do evento
	mes1: 		.byte 5					# um byte. Mes do evento
	dia1:  		.byte 12				# um byte: Dia do evento
	ptrNext1: 	.word ptrEvento2 		# aponta para o proximo elemento do vetor de estruturas
	ptrPrev1: 	.word 0					# aponta para o elemento anterior do vetor de estruturas
	
	# elemento 1 da estrutura
	ptrEvento2:	.word evento2
	ano2: 		.half	1959
	mes2: 		.byte 5
	dia2: 		.byte 12
	ptrNext2: 	.word ptrEvento3
	ptrPrev2: 	.word ptrEvento1
	
	#elemento 2 da estrutura
	ptrEvento3:	.word evento3
	ano3: 		.half 1941
	mes3: 		.byte 5
	dia3: 		.byte 12
	ptrNext3: 	.word 0
	ptrPrev3: 	.word ptrEvento2
	
	evento1: 	.asciiz "Fundada a Universidade de San Marcos em Lima, Peru, a mais antiga Universidade das americas\n"
	evento2: 	.asciiz "Emancipação política do município de Três Coroas (Rio Grande do Sul, Brasil).\n"
	evento3: 	.asciiz "Konrad Zuse apresenta o Z3, o primeiro computador programavel do mundo, em Berlin.\n"
	
	
