#include "api_robot.h"

unsigned int const_ascii = 48;
unsigned torque = 1;

void update() {
	torque += torque <= 81 ? 10 : 0;

	set_torque(torque, -1 * torque);

	char* msg = "torque: 00, -00";
	msg[9] = torque % 10 + const_ascii;
	msg[8] = torque / 10 + const_ascii;

	msg[14] = msg[9];
	msg[13] = msg[8];

	puts(msg);
}

void main(){

	//unsigned int update_time = 150;
	//set_time(0);
	//unsigned int time_0 = get_time();
	//unsigned int delta_time = 0;

	puts("puts");

	while(1) { 
		//delta_time = time_0 - get_time();

		//if (delta_time >=  update_time){
			//time_0 = delta_time + time_0;
			//delta_time = 0;
			//update();
		//}
	}
}
