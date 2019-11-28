#include "api_robot.h"

unsigned int const_ascii = 48;
unsigned torque = 1;

void update() {
	torque += torque <= 100 ? 1 : 0;

	set_torque(torque, -1 * torque);

	char* msg = "torque: 00, -00";
	msg[9] = torque % 10 + const_ascii;
	msg[8] = torque / 10 + const_ascii;

	msg[14] = msg[9];
	msg[13] = msg[8];

	puts(msg);
}

void converte_uint_string(unsigned int ui, char* s) {
	s[0] = ui % 10000 + const_ascii;
	s[1] = ui % 1000 + const_ascii;
	s[2] = ui % 100 + const_ascii;
	s[3] = ui % 10 + const_ascii;
}

void main(){
	unsigned int update_time = 90;
	set_time(0);
	unsigned int time_0 = get_time();
	unsigned int delta_time = 0;

	puts("merda. ");
	puts("puts ");
	puts("esqueci minha senha. ");

	while(1) { 
		delta_time = get_time() - time_0;

		if (delta_time >= update_time){
			time_0 = delta_time + time_0;
			delta_time = 0;
			update();

			// puts("puts ");
		}

		// char* s = "0000";
		// unsigned int time = get_time();
		// converte_uint_string(time, s);

		// puts(s);
	}
}
