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
    csrr t5, mcause
    blt t5, zero, GPT # if t0 < t1 then GPT

    li t0, 64 # t0 = 64
    beq t0, a7, write # if t0 == a7 then write

    li t0, 22 # t0 = 22
    beq t0, a7, set_time # if t0 == a7 then set_time

    li t0, 21 # t0 = 21
    beq t0, a7, get_time # if t0 == a7 then get_time

    li t0, 20 # t0 = 20
    beq t0, a7, read_gyroscope # if t0 == a7 then read_gyroscope

    li t0, 19 # t0 = 19
    beq t0, a7, read_gps # if t0 == a7 then read_gps

    li t0, 18 # t0 = 18
    beq t0, a7, set_engine_torque # if t0 == a7 then set_engine_torque

    li t0, 17 # t0 = 17
    beq t0, a7, set_servo_angles # if t0 == a7 then set_servo_angles

    li t0, 16 # t0 = 16
    beq t0, a7, read_ultrasonic_sensor # if t0 == a7 then read_ultrasonic_sensorx

read_ultrasonic_sensor: #Código: 16
    li t0, 0xFFFF0020
    sw zero, 0(t0)
    medir_sensor:
        lw t1, 0(t0)
        beq t1, zero, medir_sensor # if t0 != zero then medir_sensor
    li t0, 0xFFFF0024  
    lw a0, 0(t0) #coloca o valor do sensor em a0 
    j pos_a0  # jump to pos_a0


set_servo_angles: #Código: 17

    addi t0, a0, 0 # t0 = a0 + 0
    addi t1, a1, 0 # t1 = a1 + 0
    li a0, -2 # a0 = -2
    li t3, 2 
    li t4, 1 

    bgt t0, t3, fim_do_set # if t0 > t3 then fim_do_set
    blt t0, zero, fim_do_set # if t0 < zero then fim_so_set
    addi a0, a0, 1 # a0 = a0 + 1

    beq t0, zero, set_base# if t0 == zero then base
    beq t0, t4, set_mid # if t0 == t4 then mid

    set_top:
        li t2,0  # t2 =0 
        li t3,156  # t3 = 156
        bgt t1, t3, fim_do_set # if t1 > t3 then fim_do_set
        blt t1, t2, fim_do_set # if t1 < t2 then fim_do_set
        addi a0, a0, 1; # a0 = a0 + 1

        li t5, 0xFFFF001C
        sb t1, 0(t5) # guarda o angulo
        j fim_do_set  # jump to fim_do_set
        
    set_mid:
        li t2,52  # t2 = 52
        li t3,90  # t3 = 90
        bgt t1, t3, fim_do_set # if t1 > t3 then fim_do_set
        blt t1, t2, fim_do_set # if t1 < t2 then fim_do_set
        addi a0, a0, 1; # a0 = a0 + 1

        li t5, 0xFFFF001D
        sb t1, 0(t5) # guarda o angulo
        j fim_do_set  # jump to fim_do_set

    set_base:
        li t2,16  # t2 = 16
        li t3,16  # t3 = 116
        bgt t1, t3, fim_do_set # if t1 > t3 then fim_do_set
        blt t1, t2, fim_do_set # if t1 < t2 then fim_do_set
        addi a0, a0, 1 # a0 = a0 + 1

        li t5, 0xFFFF001E
        sb t1, 0(t5) # guarda o angulo

    fim_do_set:
    j pos_a0  # jump to pos_a0


set_engine_torque: #Código: 18

    addi t0, a0, 0 # t0 = a0 + 0
    addi t1, a1, 0 # t1 = a1 + 0
    li a0, -1 # a0 = -1
    li t2, 1 #t2 = 1
    li s1, 0xFFFF001A 
    li s2, 0xFFFF0018
    li s3, 0xFFFF0004
    li s4, 0xFFFF0008 
    li s5, 0xFFFF000C 
    li s6, 0xFFFF0010

    beq t0, zero, set_engine_0 # if t0 == zero then set_engine_0
    beq t0, t2, set_engine_1 # if t0 == t2 then set_engine_1
    j pos_a0  # jump to pos_a0

    set_engine_0:
        li a0, 0 # a0 = 0
        sh t1, 0(s1) # guarda o torque
        j pos_a0  # jump to pos_a0

    set_engine_1:
        li a0, 0 # a0 = 0
        sh t1, 0(s2) # guarda o torque
        j pos_a0  # jump to pos_a0

read_gps: #Código: 19

    li s3, 0xFFFF0004
    li s4, 0xFFFF0008 
    li s5, 0xFFFF000C 
    li s6, 0xFFFF0010

    chama_o_gps:
        sw zero, 0(s3)
    gps_nao_lido:
        lw t3, 0(s3)
        beq t3, zero, gps_nao_lido # if t0 != zero then gps_nao_lido

    #t4 = x
    lw t4, 0(s4)
    #t5 = y
    lw t5, 0(s5)
    #s4 = z
    lw s4, 0(s6)	 
    
    sw t4, 0(a0) #guarda o x
    sw t5, 4(a0) #guarda o y
    sw s4, 8(a0) #guarda o z
    
    j recupera_contexto  # jump to recupera_contexto


read_gyroscope: #Código: 20

    li s1, 0xFFFF0004 
    li s2, 0xFFFF0014

    chama_a_leitura:
        sw zero, 0(s1)
    leitura:
        lw t3, 0(s1)
        beq t3, zero, leitura # if t0 != zero then leitura

    lw t3, 0(s2)

    #t4 = x
    srli t4, t3, 20

    #t5 = y
    slli t5, t3, 12
    srli t5, t5, 22

    #s4 = z
    slli s4, t3, 22
    srli s4, s4, 22

    sw t4, 0(a0) #guarda o x
    sw t5, 4(a0) #guarda o y
    sw s4, 8(a0) #guarda o z
    j recupera_contexto  # jump to recupera_contexto

get_time: #Código: 21
    la t0, clock
    lw a0, 0(t0)
    j pos_a0  # jump to pos_a0


set_time: #Código: 22
    la t0, clock
    sw a0, 0(t0) #   
    j recupera_contexto  # jump to recupera_contexto


write: #Código: 64

    beq a0, zero, le; # ve se é pra ler ou escrever
    
    escreve:
        li t0, 1 # t0 = 1
        li t1, 0xFFFF0108
        li t2, 0xFFFF0109
        li t3, 0

    escrevendo:
        lb t4, 0(a1)
        sb t0, 0(t1)
        sb t4, 0(t2)
        esperae:
            lb t5, 0(t1)
            bne t5, zero, esperae # if t5 != zero then esperae
        addi t3, t3, 1; # t3 = t3 + 1
        addi a1, a1, 1
        bne t3, a2, escrevendo # if t3 != a2 then escreve
        mv  a0, a2 # a0 = a2

    j pos_a0  # jump to pos_a0

    le:
        li t0, 1 # t0 = 1   
        li t1, 0xFFFF010A
        li t2, 0xFFFF010B
        li t3, 0

    lendo:
        lb t4, 0(a1)
        sb t4, 0(t2)
        sb t0, 0(t1)
        esperal:
            lb t5, 0(t1)
            bne t5, zero, esperal # if t5 != zero then esperal
        addi t3, t3, 1; # t3 = t3 + 1
        addi a1, a1, 1
        bne t3, a2, lendo # if t3 != a2 then escreve
        mv  a0, a2 # a0 = a2

    j pos_a0  # jump to pos_a0

GPT: #interrupcao externa (clock)

    
    li t1, 0xFFFF0104
    lb t3, 0(t1)
    beq zero, t3, pula_GPT # interrupcao falsa

    li t0, 0xFFFF0100
    li t2, 100
    la t4, clock
    lw t5, 0(t4)  

    addi t5, t5, 100 # incrementa clock
    sb zero, 0(t1)
    sw t2, 0(t0)
    sw t5, 0(t4)

    pula_GPT:
    lw a0, 0(t6)
    j pula_a0

    
recupera_contexto:
    lw a0, 0(t6)
    pos_a0:

    csrr t0, mepc  # carrega endereco de retorno (endereco da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no enderecoo de retorno (para retornar a ecall) 
    csrw mepc, t0  # armazena endereco de retorno de volta no mepc

    pula_a0:
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
la t1, clock
sw zero, 0(t1) #set clock
li t0, 0xFFFF0100
li t2, 100
sw t2, 0(t0)

#set motors
li t0, 0xFFFF0018
li t1, 0xFFFF001A
sb zero, 0(t0)
sb zero, 0(t1)  

#set articulacoes
li t0, 0xFFFF001E
li t1, 0xFFFF001D	
li t2, 0xFFFF001C
li t3, 31
li t4, 80
li t5, 78
sb t3, 0(t0)
sb t4, 0(t1)  
sb t5, 0(t2)

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
la sp, stack_pointer #seta o endereço da pilha
# Muda para o Modo de usuário
csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
li t2, ~0x1800 # do registrador mstatus
and t1, t1, t2 # com o valor 00
csrw mstatus, t1
la t0, main # Grava o endereço do rótulo user
csrw mepc, t0 # no registrador mepc
mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP

.align 4
clock: .skip 4
reg_buffer: .skip 32000
stack_pointer:.skip 32000
.align 4
