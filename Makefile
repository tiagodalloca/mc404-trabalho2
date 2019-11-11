#  *************************************************************** 
#  Makefile para geração do software do Uóli
#  
#  Autores: Edson Borin e Antônio Guimarães
#  
#  Data: 2019
#
#  ATENÇÃO: Não modifique este Makefile. A correção do trabalho
#  será realizada utilizando uma cópia não modificada deste Makefile
#  e eventuais modificações podem fazer com que seu código não 
#  funcione com o ferramental de correção.
#
#  ***************************************************************

all: loco.o bico.o soul.o
	riscv32-unknown-elf-ld loco.o bico.o soul.o -g -o uoli.x

loco.o: loco.c api_robot.h
	riscv32-unknown-elf-gcc loco.c -c -g -o loco.o

bico.o: bico.s
	riscv32-unknown-elf-as bico.s -g -o bico.o

soul.o: soul.s
	riscv32-unknown-elf-as soul.s -g -o soul.o

clean:
	rm *.o *.x
