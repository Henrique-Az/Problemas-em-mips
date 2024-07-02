.data
	array:.word 1, 2, 3
	tam:.word 3
	x: .word 2
	newline: .asciiz "\n"
.text
	.globl main
main:
	jal horner
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	jal tradicional
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
horner:
	addi $t0, $zero, 1 #Contador do loop
	la $t1, array #Ponteiro pro array
	lw $t2, tam #guarda o tamanho
	blez $t2, exit1 #lida com caso extremo
	lw $t3, x #guarda o valor de x
	lw $a0, 0($t1) #guarda o primeiro elemento
loop1:
	bge $t0, $t2, exit1 #sai se ja foi percorrido o vetor inteiro
	addi $t1, $t1, 4
	lw $a1, 0($t1) #carrega o proximo elemento	
	mult $a0, $t3 #coef*x
	mflo $a0
	add $a0, $a0, $a1 #res+coef
	addi $t0, $t0, 1
	j loop1
exit1:
	move $v0, $a0
	jr $ra
	
tradicional:
	move $t2, $zero #resultado
	lw $t1, tam #guarda o tamanho
	blez $t1, exit2 #lida com caso extremo
	la $t0, array #ponteiro pro array
	lw $a0, x #guarda x
	move $t3, $ra #guarda o retorno
loop2:
	beqz $t1, exit2
	sub $t1, $t1, 1
	move $a1, $t1
	jal programa1
	lw $t9, 0($t0)
	mul $v0, $v0, $t9
	add $t2, $t2, $v0
	addi $t0, $t0, 4
	j loop2
	
exit2:
	move $v0, $t2
	jr $t3
	
programa1:
        li $t5,1 #result = 1;
        while:
            beq $a1,$zero,saida #while (n!=0) senão pula para o label saida
            mul $t5,$t5,$a0 #result *= x;
            subi $a1,$a1,1 #n--;
            j while
        saida:
            move $v0,$t5 #Move o resultado para o registrador de retorno
            jr $ra
