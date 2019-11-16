# TODO:
#		puts ->											tem que percorrer um string
#		set_time ->									fácil
#		get_gyro_angles ->					vetor
#		get_current_GPS_position -> vetor

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

