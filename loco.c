#include "api_robot.h"

unsigned int const_ascii = 48;
unsigned torque = 1;

void update(int i) {
	// i é o número de updates

	// A função é insuficiente porque não tivemos tempo o
	// suficiente por diversos motivos. 
	// Com mais tempo, funfaria.
	if (i % 10 == 0)
		set_torque(30, -30);

	if (i % 20 == 0)
		set_torque(-30, 30);

	if (i < 3)
		set_torque(30, -30);
	else if (i / 100 <= 0) {
		set_torque(20, 20);
	}
	else {
		set_torque(30, 30);
	}
}

void converte_uint_string(unsigned int ui, char* s) {
	s[0] = ui / 10000 + const_ascii;
	s[1] = ui / 1000 + const_ascii;
	s[2] = ui / 100 + const_ascii;
	s[3] = ui / 10 + const_ascii;
}

void main(){
	unsigned int update_time = 90;
	set_time(0);
	unsigned int time_0 = get_time();
	unsigned int delta_time = 0;

	puts("Iniciando procedimento de busca. Bzzz Blip Blop.\n");

	int i = 0;

	while(1) { 
		delta_time = get_time() - time_0;

		// A cada no mínimo 90ms (que serão na verdade 100ms)
		// chama a função de update. Essa função será responsável
		// por avaliar a posição do Uóli e corrigir o posicionamento.
		if (delta_time >= update_time){
			time_0 = delta_time + time_0;
			delta_time = 0;
			i++;
			update(i);
		}
	}
}
