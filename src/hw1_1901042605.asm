	.data
msg1: .asciiz "\nsize: "
msg2: .asciiz "\nnumber: "
msg3: .asciiz "\nEnter an array element: "
msg4: .asciiz "\nResult is: "
err1: .asciiz "\nSize must between 2 and 100!"
err2: .asciiz "\nnumber must between 1 and 100!"
err3: .asciiz "\narray element must between 1 and 100!"
#test
#msg5: .asciiz "\n i = "
#msg6: .asciiz "\n j = "

#msg7: .asciiz "\n arr[i] = "
#msg8: .asciiz "\n arr[j] = "
#test
	.text
	.globl main
main:
	li $s4, 2			# load lower bound to s4
	li $s5, 100			# load upper bound to s5
readLoop1:
	la $a0, msg1			# load message
	jal print			# print message
	jal read			# read size
	sgt $t1, $v0, $s5		# if(v0 > 100) t1 = 1
	slt $t2, $v0, $s4		# if(v0 < 2) t2 = 1
	bne $t1, $zero, printError1	# if(t1 != 0) print error
	bne $t2, $zero, printError1	# if(t2 != 0) print error
	j exitReadLoop1
printError1:
	la $a0, err1
	jal print
	j readLoop1
					
exitReadLoop1:	
	move $s0, $v0			# load size
	li $s4, 1			# load new lower bound for number
	
readLoop2:	
	la $a0, msg2			# load message
	jal print			# print message
	jal read			# read number
	sgt $t1, $v0, $s5		# if(v0 > 100) t1 = 1
	slt $t2, $v0, $s4		# if(v0 < 2) t2 = 1
	bne $t1, $zero, printError2	# if(t1 != 0) print error
	bne $t2, $zero, printError2	# if(t2 != 0) print error
	j exitReadLoop2	

printError2:
	la $a0, err2			# load error message
	jal print
	j readLoop2
		
exitReadLoop2:		
	move $s2, $v0			# load number		
	move $t0, $zero			# load 0 to t0, t0 is counter
	add $s1, $sp, -4		# s1 points arrays first element
	
loop1:
	slt $t1, $t0, $s0		# if(i < size)
	beq $t1, $zero, exitLoop1	# if (i >= size) exit
readLoop3:	
	la $a0, msg3
	jal print
	jal read			# read an array element
	sgt $t1, $v0, $s5		# if(v0 > 100) t1 = 1
	slt $t2, $v0, $s4		# if(v0 < 2) t2 = 1
	bne $t1, $zero, printError3	# if(t1 != 0) print error
	bne $t2, $zero, printError3	# if(t2 != 0) print error
	j exitReadLoop3		
printError3:
	la $a0, err3
	jal print
	j readLoop3
exitReadLoop3:		
	addi $sp, $sp, -4		# allocate space on stack
	sw $v0, 0($sp)			# add element to stack 
	addi $t0, $t0, 1	
	j loop1
	
exitLoop1:
	move $s3, $zero		# result is on $s3
	move $t0, $zero		# i = 0
	move $t5, $s1
outerLoop2:
	slt $t1, $t0, $s0	# if(t0 < size)
	beq $t1, $zero, result	# jump result
	move $t2, $t0		# j = i
	lw $t3, 0($s1)		# t3 = arr[i]
	j innerLoop2	
innerLoop2:
	addi $t2, $t2, 1	# j++
	slt $t1, $t2, $s0
	beq $t1, $zero, return2
	addi $t5, $t5, -4	
	lw $t6, 0($t5)		# t6 = arr[j]
	add $t7, $t6, $t3	# t7 = arr[j] + arr[i]
	div $t7, $s2
	mfhi $t8		# t8 = (arr[i] + arr[j])%number
	
	#test
#	la $a0, msg5		# load message
#	jal print		# print message
#	move $a0, $t0
#	li $v0, 1
#	syscall
#	la $a0, msg6		# load message
#	jal print		# print message
#	move $a0, $t2
#	li $v0, 1
#	syscall		
	#test
	
	bne $t8, $zero, innerLoop2	# if remainder is not 0, continue to iterate

	#test
#	la $a0, msg7		# load message
#	jal print		# print message		
#	move $a0, $t3
#	li $v0, 1
#	syscall
#	la $a0, msg8		# load message
#	jal print		# print message
#	move $a0, $t6
#	li $v0, 1
#	syscall
#	la $a0, msg5		# load message
#	jal print		# print message
#	move $a0, $t0
#	li $v0, 1
#	syscall
#	la $a0, msg6		# load message
#	jal print		# print message
#	move $a0, $t2
#	li $v0, 1
#	syscall
	#test
			
	addi $s3, $s3, 1
	j innerLoop2
return2:
	addi $t0, $t0, 1	# i++
	addi $s1, $s1, -4
	move $t5, $s1
	j outerLoop2		

result:
	la $a0, msg4		# load message
	jal print		# print message
	move $a0, $s3
	li $v0, 1
	syscall

	move $t0, $zero		# t0 is counter
loop4:	# restore stack memory
	slt $t1, $t0, $s0	# if(i < size)
	beq $t1, $zero, exit
	addi $sp, $sp, 4
	addi $t0, $t0, 1
	j loop4

print:	# prints the value on $a0	
	li $v0, 4		# load print string command
	syscall			# execute
	jr $ra			# return
read:
	li $v0, 5		# load read command
	syscall			# execute
	jr $ra			# return

exit:
	li $v0, 10		# load exit command
	syscall			# return
