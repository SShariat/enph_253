// ---------------------------------------------------------------------------------------------------------- \\
// Motor control functions

//H-Bridge Testing Function
void motor_test(){
	
	//Motor Test Variables (These are the speeds of 2 Motors)
	int speed_1, speed_2;
	
	while(!deselect()){
		speed_1 = 2*(analogRead(6) - 511);
		speed_2 = 2*(analogRead(7) - 511);

		if (speed_1 >1023) {
			speed_1 = 1023;
		} else if ( speed_1 < -1023) {
			speed_1 = -1023;
		}

		if (speed_2 >1023) {
			speed_2 = 1023;
		} else if ( speed_2 < -1023) {
			speed_2 = -1023;
		}

		motor.speed(3,speed_1);
		motor.speed(2,speed_2);

		clear();
		LCD.setCursor(0,0); LCD.print("M1: "); LCD.print(speed_1);
		LCD.setCursor(0,1); LCD.print("M2: "); LCD.print(speed_2);

		delay(50);
	}
	//Added Motor Stop Function
	motor.stop_all();
}