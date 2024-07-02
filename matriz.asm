.data
	matriz:
		.word 16, 3, 2, 13
		.word 5, 10, 7, 8
		.word 9, 6, 7, 12
		.word 4, 15, 14, 1
	tam: .word 4
	msgValido: .asciiz "O quadrado é mágico"
	msgInvalido: .asciiz "O quadrado não é mágico"
.text
.globl main
main:
	li $v1, 1 #guarda verdadeiro ou falso
	li $t0, 0 #guarda ind da diagonal principal
	lw $t8, tam #guarda tam
	move $t2, $zero #guarda soma da diagonal principal
	move $t3, $zero #guarda soma da diagonal secundaria
	move $t4, $zero #indice i
	li $t5, 4 
	mul $t5, $t5, $t8 #usado para deslocar verticalmente, guarda quantos enderecos devem ser pulados de uma linha pra outra
	mul $t1, $t5, $t8 #guarda ind da diagonal secundaria
	sub $t1, $t1, $t5
diagonal:
	beq $t4, $t8, exitDiagonal
	lw $t6, matriz($t0)
	add $t2, $t2, $t6 #soma na variavel da diagonal principal
	lw $t6, matriz($t1)
	add $t3, $t3, $t6 #soma na variavel da diagonal secundaria
	add $t0, $t0, $t5 #salta uma linha pra baixo
	addi $t0, $t0, 4 #anda uma coluna pra direita
	sub $t1, $t1, $t5 #salta uma linha pra cima
	addi $t1, $t1, 4 #anda uma coluna pra direira
	addi $t4, $t4, 1
	j diagonal
exitDiagonal:
	bne $t2, $t3, falha
	move $a0, $t2 #a0 guarda o valor que cada linha/coluna tem que ter
	move $t4, $zero #indice i
for1:
	beq $t4, $t8, exitFor
	mul $t0, $t4, $t5 #calcula (qtd de linhas)*(qtd de memoria pra saltar uma linha), guarda indice da linha respectiva
	li $t1, 4
	mul $t1, $t1, $t4 #calcula (qtd de colunas)*4, guarda indice da coluna respectiva 
	move $t7, $zero #indice j
	move $t2, $zero #soma da linha
	move $t3, $zero #soma da coluna
for2:
		lw $t6, matriz($t0)
		add $t2, $t2, $t6
		lw $t6, matriz($t1)
		add $t3, $t3, $t6
		addi $t0, $t0, 4
		add $t1, $t1, $t5
		addi $t7, $t7, 1
		blt $t7, $t8, for2
	bne $t2, $a0, falha #aqui "volta" pro for1
	bne $t3, $a0, falha
	addi $t4, $t4, 1
	j for1
exitFor: #sai normalmente
	jal imprimeValido
	li $v0, 10
	syscall
falha: #sai do programa imprimindo que eh invalido no terminal
	jal imprimeInvalido
	li $v0, 10
	li $v1, 0
	syscall
	
imprimeValido:
	la $a0, msgValido
	li $v0, 4
	syscall
	jr $ra
imprimeInvalido:
	la $a0, msgInvalido
	li $v0, 4
	syscall
	jr $ra
