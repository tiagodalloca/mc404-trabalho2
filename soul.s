tratador_de_interrupcoes:
guarda_contexto:

    csrrw t6, mscratch, t6 
    sw a0, 0(t6)    
    sw a1, 4(t6) 
    sw a2, 8(t6)    
    sw a3, 12(t6)    
    sw a4, 16(t6)    
    sw a5, 20(t6)    
    sw a6, 24(t6)    
    sw a7, 28(t6)    
    sw s0, 32(t6)    
    sw s1, 36(t6)
    sw s2, 40(t6)    
    sw s3, 44(t6)    
    sw s4, 48(t6)    
    sw s5, 52(t6)    
    sw s6, 56(t6)    
    sw s7, 60(t6)    
    sw s8, 64(t6)    
    sw s9, 68(t6)    
    sw s10, 72(t6)
    sw s11, 76(t6)  
    sw t0, 80(t6)
    sw t1, 84(t6)
    sw t2, 88(t6)
    sw t3, 92(t6)
    sw t4, 96(t6)
    sw t5, 100(t6)
    sw ra, 104(t6)    
    sw sp, 108(t6)
    sw gp, 112(t6)
    sw tp, 116(t6) 


Verifica_qual_e_a_syscall:

    li t0, 64 # t0 = 64
    beq t0, a7, write; # if t0 == a7 then write

    li t0, 22 # t0 = 22
    beq t0, a7, set_time; # if t0 == a7 then set_time

    li t0, 21 # t0 = 21
    beq t0, a7, get_time; # if t0 == a7 then get_time

    li t0, 20 # t0 = 20
    beq t0, a7, read_gyroscope; # if t0 == a7 then read_gyroscope

    li t0, 19 # t0 = 19
    beq t0, a7, read_gps; # if t0 == a7 then read_gps

    li t0, 18 # t0 = 18
    beq t0, a7, set_engine_torque; # if t0 == a7 then set_engine_torque

    li t0, 17 # t0 = 17
    beq t0, a7, set_servo_angles; # if t0 == a7 then set_servo_angles

    li t0, 16 # t0 = 16
    beq t0, a7, read_ultrasonic_sensor; # if t0 == a7 then read_ultrasonic_sensorx


read_ultrasonic_sensor: #Código: 16
    sw zero, 0xFFFF0020 
    medir_sensor:
        lw t0, 0xFFFF0020 
        bne t0, zero, medir_sensor # if t0 != zero then medir_sensor
    lw a0, 0xFFFF0024 # 
    
    bge t0, zero, objeto_detectado # if t0 >= zero then objeto_detectado



    objeto_detectado:
    

    j pos_a0  # jump to pos_a0


set_servo_angles: #Código: 17


    j pos_a0  # jump to pos_a0


set_engine_torque: #Código: 18


    j pos_a0  # jump to pos_a0


read_gps: #Código: 19


    j recupera_contexto  # jump to recupera_contexto


read_gyroscope: #Código: 20


    j recupera_contexto  # jump to recupera_contexto


get_time: #Código: 21


    j pos_a0  # jump to pos_a0


set_time: #Código: 22


    j recupera_contexto  # jump to recupera_contexto


write: #Código: 64


    j pos_a0  # jump to pos_a0




recupera_contexto:
    lw a0, 0(t6)
    pos_a0:

    csrr t0, mepc  # carrega endereco de retorno (endereco da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no enderecoo de retorno (para retornar a ecall) 
    csrw mepc, t0  # armazena endereco de retorno de volta no mepc


    lw tp, 116(t6)   
    lw gp, 112(t6)     
    lw sp, 108(t6)
    lw ra, 104(t6)
    lw t5, 100(t6)
    lw t4, 96(t6)
    lw t3, 92(t6)
    lw t2, 88(t6)
    lw t1, 84(t6)
    lw t0, 80(t6)
    lw s11, 76(t6)
    lw s10, 72(t6)
    lw s9, 68(t6)
    lw s8, 64(t6)
    lw s7, 60(t6)
    lw s6, 56(t6)
    lw s5, 52(t6)
    lw s4, 48(t6)
    lw s3, 44(t6)
    lw s2, 40(t6)
    lw s1, 36(t6)
    lw s0, 32(t6)
    lw a7, 28(t6)
    lw a6, 24(t6)
    lw a5, 20(t6)
    lw a4, 16(t6)
    lw a3, 12(t6)
    lw a2, 8(t6)
    lw a1, 4(t6)


    csrrw t6, mscratch, t6    
    Fim_do_tratador_de_interrupcoes:
        mret           # Recuperar o resto do contexto

.globl _start
_start:
# Configura o tratador de interrupções
la t0, tratador_de_interrupcoes # Grava o endereço do rótulo int_handler
csrw mtvec, t0 # no registrador mtvec
# Habilita Interrupções Global
csrr t1, mstatus # Seta o bit 3 (MIE)
ori t1, t1, 0x80 # do registrador mstatus
csrw mstatus, t1
# Habilita Interrupções Externas
csrr t1, mie # Seta o bit 11 (MEIE)
li t2, 0x800 # do registrador mie
or t1, t1, t2
csrw mie, t1
# Ajusta o mscratch
la t1, reg_buffer # Coloca o endereço do buffer para salvar
csrw mscratch, t1 # registradores em mscratch
li sp, 100000000#seta o endereço da pilha

# Muda para o Modo de usuário
csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
li t2, ~0x1800 # do registrador mstatus
and t1, t1, t2 # com o valor 00
csrw mstatus, t1
la t0, user # Grava o endereço do rótulo user
csrw mepc, t0 # no registrador mepc
mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP

.align 4