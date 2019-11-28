.globl set_engine_torque
.globl set_torque
.globl set_head_servo
.globl get_us_distance
.globl get_time
.globl set_time
.globl get_current_GPS_position
.globl get_gyro_angles
.globl puts

set_engine_torque:
	li a7, 18
	ecall
	ret

set_torque:
	# chama as funcao set_engine_torque
	# para cada motor
	addi sp, sp, -12
	sw a0, 8(sp)
	sw a1, 4(sp)
	sw ra, 0(sp)

	mv a1, a0
	li a0, 0
	jal set_engine_torque

	lw a1, 4(sp)
	li a0, 1
	jal set_engine_torque

	lw ra, 0(sp)
	lw a1, 4(sp)
	lw a0, 8(sp)
	addi sp, sp, 12
	ret

set_head_servo:
	li a7, 17
	ecall
	ret

get_us_distance:
	li a7, 16
	ecall
	ret

get_time:
	li a7, 21
	ecall
	ret

set_time:
	li a7, 22
	ecall
	ret

get_current_GPS_position:
	li a7, 19
	ecall
	ret

get_gyro_angles:	
	li a7, 20
	ecall
	ret

puts:
	li t0, 0
	mv t2, a0
	li t3, 0			
	count_bytes:
		lb t1, 0(t2) # carrega char em t1		
		beq t1, t3, fim
		addi t2, t2, 1
		addi t0, t0, 1
		j count_bytes
	fim:

	mv a1, a0
	li a0, 1
	mv a2, t0
	li a7, 64
	ecall
	ret
