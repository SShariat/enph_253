// ---------------------------------------------------------------------------------------------------------- \\
// Motor control functions

//H-Bridge Testing Function
//Tree Template
void motor_tree(){
	
	//NUM OF CHILD
	#define OPTIONS 4
	
	//TAPE CHILDREN
	#define MOTOR_TEST 1
	#define BRAKE_TEST 2
	#define ROTATE_TEST 3
	#define EDIT_VARS 4

	while(!deselect()){

		clear();
		print_root("Motor options:");

		switch(menu_choice(OPTIONS)){

			case MOTOR_TEST: 
			print_child("Motor Test");
			if(confirm()){
				motor_test();
			}
			break;

			case BRAKE_TEST:
			print_child("Brake Test");
			if(confirm()){
				brake_test();
			}
			break;

			case ROTATE_TEST:
			print_child("Rotate Test");
			if(confirm()){
				rotate_test();
			}
			break;

			case EDIT_VARS:
			print_child("Edit variables");
			if(confirm()){
				motor_vars();
			}
			break;
		}
		delay(200);
	}
}

void motor_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 4

	#define FORWARD_SPEED 1
	#define REVERSE_SPEED 2
	#define DELAY_DURATION 3
	#define ROTATE_SPEED 4
	

	//edit_variable() is incorrect, need a third parameter.
	while(!deselect()){
	
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case FORWARD_SPEED:
		//Changing Variable 1
			edit_variable(13, "Stall speed", 1000);
		break;

		case REVERSE_SPEED:
		//Changing Variable 2
			edit_variable(14, "Reverse speed", 1000);
		break;
		
		case DELAY_DURATION:
		//Changing Variable 3
			edit_variable(15, "Time to delay", 1000);
		break;

		case ROTATE_SPEED:
		//Changing Variable 4
			edit_variable(16, "Rot. Speed", 1000);
		break;

		}
		delay(200);
	}	
}

void brake_test(){
	int forward = EEPROM.read(3)*4;

	while(!deselect()){
		if(confirm()){
			//get up to speed
			motor.speed(2,forward);
			motor.speed(3,forward);
			delay(1500);

			//test brakes
			full_stop();
		}
	}
	motor.stop_all();
}

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

void full_stop(){
	int stall = EEPROM.read(13)*4;
	int reverse = EEPROM.read(14)*4;
	int delay_period = EEPROM.read(15)*4;

	motor.speed(2, -reverse);
	motor.speed(3, -reverse); 
	delay(delay_period);
	motor.speed(2, stall);
	motor.speed(3, stall); 
}

void rotate_test(){
	int speed = EEPROM.read(16)*4;
	while(!deselect()){
		rotate_bot(speed);
	}
	motor.stop_all();
}

void turn_left(){
	// This writes our output to the motors
		// Motor 3 = Left
		// Motor 2 = Right
	motor.speed(2, 350);
	motor.speed(3, 250);  
}

bool white_detected(){
	int tape_thresh = EEPROM.read(4)*4;

	if(analogRead(4) < tape_thresh && analogRead(5) < tape_thresh)
		return true;
	else
		return false;
}
