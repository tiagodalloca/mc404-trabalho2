.align 4

int_handler:
  ###### Tratador de interrupções e syscalls ######
  
  # <= Implemente o tratamento da sua syscall aqui 
  
  csrr t0, mepc  # carrega endereÃ§o de retorno (endereço da instrução que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
  csrw mepc, t0  # armazena endereÃ§o de retorno de volta no mepc
  mret           # Recuperar o restante do contexto (pc <- mepc)
  


.globl _start
_start:

  la t0, int_handler  # Carregar o endereço da rotina que tratarão as interrupuções
  csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar o
                      # vetor de interrupções
  
  # ... 
  
  ecall               # Exemplo de chamada de sistema

  # ...

loop_infinito: 
  j loop_infinito
  
