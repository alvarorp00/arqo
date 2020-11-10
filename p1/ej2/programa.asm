.data 0
n: .word 100
buff: .word 0

.text 0
main:

    lw $t1, 0($zero)
    add $t2, $zero, $zero
    addi $t3, $zero, 10
    addi $t4, $zero, 2
    nop
    nop
    nop
    sub $t3, $t3, $t2
    nop
    nop
    nop
    lui $t6, 1
    xor $t2, $t5, $t5
    nop
    nop
    nop
    addi $t5, $zero, 1
    nop
    nop
    nop
    nop
    beq $t5, $t2, err
    and $t5, $t5, $t2
    slti $t5, $t1, 1 
    nop
    nop
    nop
    j no_err
    err:
    addi $t3, $zero, -1
    nop
    nop
    nop
    nop
    j ends
    no_err:
    or $t1, $t1, $t5
    mul $t3, $t6, $t3
    ends:
    sw $t3, 4($zero)
