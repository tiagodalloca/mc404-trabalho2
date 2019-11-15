# Funções de tratamento de interrupções #
ih_coordenadas:
    # Carrega 0 em 0xFFFF0004
    li t0, 0xFFFF0004
    li t3, 0
    sw t3, 0(t0)
    li t3, 1    
    loop:
        lw t1, 0(t0) 
        # Se o valor em READY_PORT for 1, faz a leitura 
        beq t3, t1, le
        j loop
    le:
        li t0, 0xFFFF0004
        lw a0, 0(t0)

        ret 




# Funções do programa principal #
compara_strings:
    # Recebe o endereço de duas strings em a0 e a1
    # Retorna 1 se forem iguais, 0 se diferentes
    li t0, 0
    while_iguais:
        lb t1, 0(a0)
        lb t2, 0(a1)
        bne t1, t2, diff         # Se os caracteres forem diferentes, salta
        # Se forem iguais:
        li t3, 0
        beq t1, t3, eq           # Se ambos chegaram em '\0', são iguais
        # Caso contrário:
        addi a0, a0, 1
        addi a1, a1, 1
        j while_iguais

    diff:
        li a0, 0
        ret
    eq:
        li a0, 1
        ret




anda:
    # Recebe distância em a0
    # Move o robô 
    mv a1, a0
    li a0, 1
    li a7, 2100
    ecall
    ret

gira:
    # Recebe grau em a0
    # Rotaciona o robô
    mv a1, a0
    li a0, 2
    li a7, 2100
    ecall
    ret   

muda_torque:
    # Recebe torque dos dois motores em a0
    # Altera o torque do robô
    mv a1, a0
    mv a2, a1
    li a0, 3
    li a7, 2100
    ecall
    ret


###### Tratador de interrupções e syscalls ######
int_handler:

    salva_contexto:

        csrrw s11, mscratch, s11 
        sw a0, 0(s11)    
        sw a1, 4(s11) 
        sw a2, 8(s11)    
        sw a3, 12(s11)    
        sw a4, 16(s11)    
        sw a5, 20(s11)    
        sw a6, 24(s11)    
        sw a7, 28(s11)    
        sw s0, 32(s11)    
        sw s1, 36(s11)
        sw s2, 40(s11)    
        sw s3, 44(s11)    
        sw s4, 48(s11)    
        sw s5, 52(s11)    
        sw s6, 56(s11)    
        sw s7, 60(s11)    
        sw s8, 64(s11)    
        sw s9, 68(s11)    
        sw s10, 72(s11)  
        sw t0, 76(s11)
        sw t1, 80(s11)
        sw t2, 84(s11)
        sw t3, 88(s11)
        sw t4, 92(s11)
        sw t5, 96(s11)
        sw t6, 100(s11)
        sw ra, 104(s11)    
        sw sp, 108(s11)
        sw gp, 112(s11)
        sw tp, 116(s11)        

    # Verifica qual syscall foi chamada:
    li t0, 2104
    beq a7, t0, syscall2104
    # Se a syscall for 2104, salta; Se não, continua:

    syscall2100:
        # Se a0=1, salta
        li t0, 1
        beq a0, t0, a0_1
        # Se a0=2, salta
        li t0, 2
        beq a0, t0, a0_2
        # Se a0=3, salta
        li t0, 3
        beq a0, t0, a0_3
        # Se não for nenhum dos parâmetros permitidos, restaura o contexto
        j fim_mov

        a0_1:
            # Encontra as coordenadas iniciais do robô e armazena a tripla em a0
            jal ih_coordenadas
            # Obtem x:
            slli t6, a0, 12 # "remove" bits de rotacao
            srli t6, t6, 22 #
            mv s0, t6       # Armazena x0 em s0
            # Obtem z:
            slli t6, a0, 22 # "remove" bits de rotacao e de x
            srli t6, t6, 22 #
            mv s1, t6       # Armazena z0 em s1

            # Registrador a1 possui a distância
            mv s3, a1       # Move-a para s3

            torque_anda:
            # Define o torque como 13 N.dm nos dois motores
            li a0, 13
            li a1, 13
            li t0, 0xFFFF0004
            # Carrega em t6 o valor do torque no motor esquerdo e o desloca 16 bits à direita
            slli t6, a0, 16 
            # Acrescenta o valor do torque do motor direito
            add t6, t6, a0
            sw t6, 0(t0)

            # Enquando não andou a distância:
            while_not_distance:
                mul s4, s3, s3          # s4 <- [distância a percorrer]^2
                # Encontra a posicao atual:

                jal ih_coordenadas
                mv t5, a0
                # Obtem x:
                slli t6, a0, 12 # "remove" bits de rotacao
                srli t6, t6, 22 #
                mv a0, t6       # Armazena x em a0
                mv a1, s0       # Move x0 para a1
                # Obtem z:
                slli t6, t5, 22 # "remove" bits de rotacao e de x
                srli t6, t6, 22 #
                mv a2, t6       # Armazena z em a2
                mv a3, s1       # Move z0 para a3

                # Calcula a distância do ponto de partida   
                distanciaquad:
                #  x em a0, x0 em a1, z em a2, z0 em a3
                sub t0, a0, a1  # t0 <- x-x0
                sub t1, a2, a3  # t1 <- z-z0
                mul t0, t0, t0  # t0 <- (x-x0)^2
                mul t1, t1, t1  # t1 <- (z-z0)^2
                add a0, t0, t1  # a0 <- (x-x0)^2 + (z-z0)^2 = d^2

                # Verifica se a distância percorrida é maior que a desejada:
                verifica:
                bgeu a0, s4, fim_mov 
                j while_not_distance

        a0_2:
            # Encontra as coordenadas iniciais do robô e armazena a tripla em a0
            jal ih_coordenadas
            #Obtem rot:
            srli t6, a0, 20
            mv s0, t6       # Armazena angulo atual em s0 

            # Registrador a1 possui o "ângulo final"
            mv s3, a1       # Move-o para s3
            bge s3, s0, gira_esq    # if [angulo final]>=[angulo atual] then [gira para a esquerda] else [gira para a direita]

            gira_dir:
                # Define o torque como 5 N.dm no motor da esquerda e -5 N.dm no da direita
                li a0, 5
                li a1, -5
                li t0, 0xFFFF0008
                # Carrega em t6 o valor do torque no motor esquerdo e o desloca 16 bits à direita
                slli t6, a0, 16 
                # Acrescenta o valor do torque do motor direito
                add t6, t0
                sw t6, 0(t0)

                while_not_angleR:
                    jal ih_coordenadas
                    #Obtem rot:
                    srli t6, a0, 20   
                    # if [atual] > [final] then [continua no loop] else [jump]
                    bgt t6, s3, while_not_angleR
                    j fim_mov

                gira_esq:
                # Define o torque como -5 N.dm no motor da esquerda e 5 N.dm no da direita
                li a0, -5
                li a1, 5
                li t0, 0xFFFF0008
                # Carrega em t6 o valor do torque no motor esquerdo e o desloca 16 bits à direita
                slli t6, a0, 16 
                # Acrescenta o valor do torque do motor direito
                add t6, t6, a1
       
                sw t6, 0(t0)

                while_not_angleL:
                    jal ih_coordenadas
                    #Obtem rot:
                    srli t6, a0, 20   
                    # if [atual] < [final] then [continua no loop] else jump
                    blt t6, s3, while_not_angleL
                    j fim_mov

        fim_mov:
            # Define o torque como 0 N.dm nos dois motores
            li a0, 0
            li a1, 0
            zera_torque:
            li t0, 0xFFFF0008
            # Carrega em t6 o valor do torque no motor esquerdo e o desloca 16 bits à direita
            slli t6, a0, 16 
            # Acrescenta o valor do torque do motor direito
            add t6, t6, a1
            
            sw t6, 0(t0)
            # Para o movimento
            # Restaura a0
            lw a0, 0(s11)
            j restaura

        a0_3:
            # Muda o torque do robô
            mv a0, a1
            mv a1, a2
            li t0, 0xFFFF0004
            # Carrega em t6 o valor do torque no motor esquerdo e o desloca 16 bits à direita
            slli t6, a0, 16 
            # Acrescenta o valor do torque do motor direito
            add t6, t6, a1
           
            sw t6, 0(t0)
            j restaura
        # Fim do tratamento da syscall 2104     

            
    syscall2104:
        jal ih_coordenadas
        # a0 é o valor de retorno e, portanto, não é restaurado
        # Fim do tratamento da syscall 2104      

    restaura:
        csrr t0, mepc  # carrega endereco de retorno (endereco da instrução que invocou a syscall)
        addi t0, t0, 4 # soma 4 no enderecoo de retorno (para retornar a ecall) 
        csrw mepc, t0  # armazena endereco de retorno de volta no mepc

        lw tp, 116(s11)   
        lw gp, 112(s11)     
        lw sp, 108(s11)
        lw ra, 104(s11)
        lw t6, 100(s11)
        lw t5, 96(s11)
        lw t4, 92(s11)
        lw t3, 88(s11)
        lw t2, 84(s11)
        lw t1, 80(s11)
        lw t0, 76(s11)
        lw s10, 72(s11)
        lw s9, 68(s11)
        lw s8, 64(s11)
        lw s7, 60(s11)
        lw s6, 56(s11)
        lw s5, 52(s11)
        lw s4, 48(s11)
        lw s3, 44(s11)
        lw s2, 40(s11)
        lw s1, 36(s11)
        lw s0, 32(s11)
        lw a7, 28(s11)
        lw a6, 24(s11)
        lw a5, 20(s11)
        lw a4, 16(s11)
        lw a3, 12(s11)
        lw a2, 8(s11)
        lw a1, 4(s11)
        

        csrrw s11, mscratch, s11 
        # Fim do tratamento das syscalls 2100 e 2104
    
    end_inthandler:
        mret           # Recuperar o restante do contexto (pc <- mepc)
        


################ Programa ######################

.globl _start
_start:

    la t0, int_handler  # Carregar o endereÃ§o da rotina que tratarÃ¡ as interrupÃ§Ãµes
    csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar o
                        # vetor de interrupÃ§Ãµes.

    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 7 (MPIE)
    ori t1, t1, 0x80 
    csrw mstatus, t1
    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 
    or t1, t1, t2
    csrw mie, t1
    # Ajusta o mscratch
    la t1, registradores # Coloca o endereço do buffer para salvar
    csrw mscratch, t1 # registradores em mscratch
    # Muda para o Modo de usuário
    csrr t1, mstatus # Seta os bits 11 e 12  de mstatus com 0
    li t2, ~0x1800 
    csrw mstatus, t1
    la t0, main # Grava o endereço do rótulo main em mepc
    csrw mepc, t0 
    mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP

.align 4
# Programa principal #
main:
    # Verifica se a entrada foi Amarelo
    la a0, destino
    la a1, amarelo
    jal compara_strings
    bne a0, zero, ponto_amarelo
    # Verifica se a entrada foi Azul
    la a0, destino
    la a1, azul
    jal compara_strings
    bne a0, zero, ponto_azul
    # Verifica se a entrada foi Verde
    la a0, destino
    la a1, verde
    jal compara_strings
    bne a0, zero, ponto_verde
    # Verifica se a entrada foi Amarelo
    la a0, destino
    la a1, vermelho
    jal compara_strings
    bne a0, zero, ponto_vermelho
    # Verifica se a entrada foi Rosa
    la a0, destino
    la a1, rosa
    jal compara_strings
    bne a0, zero, ponto_rosa

    ponto_amarelo: 
        # Rotaciona para 270°
        li a0, 270
        jal gira
        # Anda 27 dm
        li a0, 27
        jal anda
        # Rotaciona para 180°
        li a0, 180
        jal gira
        # Anda 38 dm
        li a0, 38
        jal anda
        # Rotaciona para 90°
        li a0, 90
        jal gira
        # Anda 2 dm
        li a0, 2
        jal anda        

        #Robô está no ponto amarelo
        j loop_infinito


    ponto_azul: 
        # "Corrige" o ângulo para 180°
        li a0, 180
        jal gira
        # Anda 30 dm
        li a0, 30
        jal anda
        # Rotaciona para 135°
        li a0, 135
        jal gira
        # Anda 2 dm
        li a0, 2
        jal anda
        # Rotaciona para 92°
        li a0, 92
        jal gira
        # Anda 27 dm
        li a0, 27
        jal anda

        #Robô está no ponto azul
        j loop_infinito

    ponto_verde:
        # "Corrige" o ângulo para 180°
        li a0, 180
        jal gira
        # Anda 10 dm
        li a0, 10
        jal anda
        # Rotaciona para 300°
        li a0, 300
        jal gira
        # Anda 38 dm
        li a0, 38
        jal anda
        # Rotaciona para 270°
        li a0, 270
        jal gira
        # Anda 10 dm
        li a0, 10
        jal anda
        # Rotaciona para 180°
        li a0, 180
        jal gira
        # Muda o torque para -5 N.dm
        li a0, -5
        jal muda_torque

        #Robô está no ponto verde
        j loop_infinito

    ponto_vermelho:
        # Rotaciona para 298°
        li a0, 298
        jal gira
        # Anda 22 dm
        li a0, 22
        jal anda
        # Rotaciona para 90°
        li a0, 90
        jal gira
        # Anda 20 dm
        li a0, 20
        jal anda
        # Anda 15 dm
        li a0, 15
        jal anda        
        # Rotaciona para 0°
        li a0, 0
        jal gira
        # Anda 7 dm
        li a0, 7
        jal anda
        # Rotaciona para 280°
        li a0, 280
        jal gira
        # Anda 8 dm
        li a0, 8
        jal anda

        #Robô está no ponto vermelho
        j loop_infinito

    ponto_rosa:
        # Rotaciona para 300°
        li a0, 300
        jal gira
        # Anda 21 dm
        li a0, 21
        jal anda
        # Rotaciona para 90°
        li a0, 90
        jal gira
        # Anda 20 dm
        li a0, 20
        jal anda
        # Anda 15 dm
        li a0, 15
        jal anda        
        # Rotaciona para 87°
        li a0, 87
        jal gira
        # Anda 14 dm
        li a0, 14
        jal anda
        # Rotaciona para 130°
        li a0, 130
        jal gira
        # Anda 4 dm
        li a0, 3
        jal anda
        # Rotaciona para 170°
        li a0, 170      
        jal gira
        # Anda 3 dm
        li a0, 3
        jal anda
        # Rotaciona para 130°
        li a0, 130
        jal gira
        # Anda 10 dm
        li a0, 10
        jal anda
        # Rotaciona para 175°
        li a0, 175
        jal gira
        # Anda 20 dm
        li a0, 20
        jal anda

        #Robô está no ponto rosa
        j loop_infinito

loop_infinito: 
  j loop_infinito
  

reg_buffer: .skip 4
registradores:  .skip 136

destino: .asciz "Azul"

amarelo: .asciz "Amarelo"
azul: .asciz "Azul"
verde: .asciz "Verde"
vermelho: .asciz "Vermelho"
rosa: .asciz "Rosa"
