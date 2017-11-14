#ackermann function: calculates A($t0, $t1)
#https://en.wikipedia.org/wiki/Ackermann_function
#will stackoverflow if m or n is greater than 4

addi $t0, $zero, 3 #m = t0
addi $t1, $zero, 3 #n = t1
sw   $t0, 4($sp)         #push m
sw   $t1  8($sp)         #push n
addi $sp, $sp, 8
jal ackermann             #ackermann(m, n);
lw   $t2,   ($sp)         #pop the return value
addi $sp, $sp, -4
end:
j end

ackermann:
lw   $t0, -4($sp)         # m = arg1
lw   $t1,  0($sp)         # n = arg2
addi $sp, $sp, -8              # pop two words

bne  $t0, $zero, continue1# if m != 0 goto continue1
addi $t2, $t1, 1          # t2 = n + 1
sw   $t2, 4($sp)          # push return value
addi $sp, $sp, 4          #push one word
jr   $ra                  #return t2

continue1:
bne $t1, $zero, continue2
#push locals
sw   $ra,  4($sp)         #push our return address
addi $t0, $t0, -1         # m = m -1;
addi $t1, $zero, 1        # n = 1;
sw   $t0, 8($sp)         #push m
sw   $t1  12($sp)         #push n
addi $sp, $sp, 12
jal ackermann             #ackermann(m, n);
lw   $t2,   ($sp)         #pop the return value
lw   $ra, -4($sp)         #pop the return address
addi $sp, $sp, -8         #pop 2 words
sw   $t2, 4($sp)          #push return value
addi $sp, $sp, 4          #push one word
jr   $ra                  #return 
continue2:
#push locals
sw   $t0,  4($sp)
sw   $ra,  8($sp)         #push our return address
addi $t1, $t1, -1         # n = n -1;
sw   $t0, 12($sp)         #push m
sw   $t1  16($sp)         #push n
addi $sp, $sp, 16
jal ackermann             #ackermann(m, n);
lw   $t1,   ($sp)         #pop the return value
lw   $ra, -4($sp)         #pop the return address
lw   $t0, -8($sp)         #pop m
addi $sp, $sp, -12        #pop 2 words
addi $t0, $t0, -1         # n = n -1
sw   $ra,  4($sp)         #push our return address
sw   $t0, 8($sp)         #push m
sw   $t1  12($sp)         #push n
addi $sp, $sp, 12
jal ackermann             #ackermann(m, n);
lw   $t2,   ($sp)         #pop the return value
lw   $ra, -4($sp)         #pop the return address
addi $sp, $sp, -8         #pop 2 words
sw   $t2, 4($sp)          #push return value
addi $sp, $sp, 4          #push one word
jr   $ra                  #return 

