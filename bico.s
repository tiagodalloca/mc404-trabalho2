.globl set_engine_torque
set_torque:
	li a7, 18
	ecall

.globl set_torque
set_torque:
	addi sp, sp, -12
	sw a0, 8(sp)
	sw a1, 4(sp)
	sw ra, 0(sp)

	lw a1, a0
	li a0, 0
	jal set_torque

	lw a1, 4(sp)
	li a0, 1
	jal set_torque

	lw ra, 0(sp)
	lw a1, 4(sp)

