# TODO: testar

.globl set_engine_torque
set_engine_torque:
	li a7, 18
	ecall
	ret

.globl set_torque
set_torque:
	addi sp, sp, -12
	sw a0, 8(sp)
	sw a1, 4(sp)
	sw ra, 0(sp)

	mv a1, a0
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
	mv t0, a0
	addi a0, a0, 4
	mv t1, a0
	addi a0, a0, 4
	mv t2, a0
	
	slli t0, t0, 20
	slli t1, t1, 10
	or t0, t0, t1
	or t0, t0, t2
	
	mv a0, t0
	li a7, 19
	ecall
	ret

.globl get_gyro_angles
get_gyro_angles:
	mv t0, a0
	addi a0, a0, 4
	mv t1, a0
	addi a0, a0, 4
	mv t2, a0
	
	slli t0, t0, 20
	slli t1, t1, 10
	or t0, t0, t1
	or t0, t0, t2
	
	mv a0, t0
	li a7, 20
	ecall
	ret

.globl puts
puts:
	li t0, 0
	mv t2, a0
	li t3, 0			
	count_bytes:
		addi t0, t0, 1
		lb t1, 0(t2)
		addi t2, t2, 1
		beq t1, t3, count_bytes

	mv a1, a0
	li a0, 0
	mv a2, t1
	ecall
	ret
