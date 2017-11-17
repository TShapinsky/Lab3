#addi 0
addi $t0, $zero, 10
addi $t9, $t0, 5
syscall #15 0
#sw,lw 1
addi $t1, $zero, 20
sw   $t1, 0($sp)
lw   $t9, 0($sp)
syscall #20 1
#j 2
addi $t9, $zero, 25
j jumpOver
addi $t9, $zero, 50
jumpOver:
syscall #25 2
#jal 4
jal jumpAndLink
add $t9, $zero, 35
syscall #35 4
j jumpPast
jumpAndLink:
#jr 3
add $t9, $zero, 30
syscall #30 3
jr $ra
jumpPast:
#bne 5 6
addi $t0, $zero, 10
addi $t1, $zero, 11
addi $t9, $zero, 40
bne $t0, $t1, takenBranch
addi $t9, $zero, 50
addi $t8, $zero, 10
takenBranch:
syscall #40 5
addi $t0, $zero, 10
addi $t1, $zero, 10
addi $t9, $zero, 50
bne $t0, $t1, untakenBranch
addi $t9, $zero, 45
untakenBranch:
syscall #45 6
#xori 7
addi $t0, $zero, 0xC
xori $t9, $t0,   0x05
syscall #9 7
#add 8
addi $t0, $zero, 12
addi $t1, $zero, 15
add $t9, $t0, $t1
syscall #27 8
#sub 9
addi $t0, $zero, 15
addi $t1, $zero, 12
sub $t9, $t0, $t1
syscall #3 9
#slt 10 11
addi $t0, $zero, 12
addi $t1, $zero, 15
slt $t9, $t0, $t1
syscall #1 10
addi $t0, $zero, 15
addi $t1, $zero, 12
slt $t9, $t0, $t1
syscall #0 11
end:
j end
