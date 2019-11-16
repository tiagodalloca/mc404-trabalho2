# TODO:
#		puts ->											tem que percorrer um string
#		get_gyro_angles ->					vetor

.globl set_engine_torque
set_torque:
	li a7, 18
	ecall
	ret

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
	ret

.globl set_head_servo
set_head_servo:
	li a7, 17
	ecall
	ret

.globl get_us_distance
get_us_distance:
	li a7, 16
	ecall
	ret

.globl get_time
get_time:
	li a7, 21
	ecall
	ret

.globl set_time
set_time:
	li a7, 22
	ecall
	ret

.globl get_current_GPS_position
get_current_GPS_position:
	la t0, a0
	la t1, 4(a0)
	la t2, 8(a0)
	
	slli t0, t0, 20
	slli t1, t1, 10
	or t0, t0, t1
	or t0, t0, t2
	
	lw a0, t0
	ecall
	ret
