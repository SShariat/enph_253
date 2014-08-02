// ---------------------------------------------------------------------------------------------------------- \\
// Tape Following Tree


//Root Tape Following
void tape_follow_tree(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 4
	//TAPE CHILDREN
	#define TAPE_VARS 1
	#define TAPE_DEMO 2
	#define ANALOG_PID 3
	#define TAPE_SENSOR 4

	while(!deselect()){

		clear();
		print_root("Tape-Follow");

		switch(menu_choice(OPTIONS)){

			case TAPE_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				tape_follow_vars();
			}
			break;

			case TAPE_DEMO:
			print_child("Run Demo");
			if(confirm()){
				while(!deselect()){
					follow_tape();
				}
				motor.stop_all();
			}
			break;

			case ANALOG_PID:
			print_child("Analog PID");
			if(confirm()){
				analog_pid();
			}
			break;

			case TAPE_SENSOR:
			print_child("Check Sensors");
			if(confirm()){
				tape_follow_sensor();
			}
			break;
		}
		delay(200);
	}
}

//Tape-Following Variable Editor
void tape_follow_vars(){

	#define NUM_OF_CONSTANTS 4

	#define KP 1
	#define KD 2
	#define SPEED 3
	#define THRESH 4

	while(!deselect()){
	
		clear();
		print_root("Var: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			edit_variable(1, "K_p",1000);
		break;

		case KD:
		//Changing Variable 2
			edit_variable(2, "K_d",1000);
		break;
		
		case SPEED:
		//Changing Variable 3
			edit_variable(3, "Speed",1000);
		break;

		case THRESH:
		//Changing Variable 4
			edit_variable(4, "Thresh",1000);
		break;


		}
		delay(200);
	}
}

//Runs PID Demonstration
void tape_follow_demo(){

	// Initializing tape following parameters
		int state;			  // The state of the robot (straight, left, right, or hard left/right)
		int lastState   = 0;  // The previous state of the robot.
		int thisState   = 0;  // The state which the robot is currently running in (i.e. a plateau)
		int lastTime    = 0;  // The time the robot spent in the last state.
		int thisTime    = 0;  // The time the robot has spent in this state.
		int i 		    = 0;  // i for iterations, because I'm old-school like that.

		int pro;  			  // Taking a leaf out of Andre's book, this stands for the proportional function.
		int der;  			  // As one might expect, this is the derivative function (no integrals on my watch!)
		int result;  		  // The result of our pro and der, this goes to the motors.    

		// Setting up the variables that will be edited
		int K_p 		= EEPROM.read(1)*4;
		int K_d 		= EEPROM.read(2)*4;
		int tape_speed 	= EEPROM.read(3)*4;
		int tape_thresh = EEPROM.read(4)*4;

	while(!deselect()){
	//Follow Tape
		//Reading QRD Sensors
		int l = analogRead(4); // Left QRD
		int r = analogRead(5); // Right QRD (but you knew that already, you're smart)

		if(l > tape_thresh && r > tape_thresh) { // Both QRDs are on the tape
			state = 0;
		} else if(l < tape_thresh && r > tape_thresh) { // The left QRD has moved off the tape.
			state = -1;
		} else if(l > tape_thresh && r < tape_thresh) { // The right QRD is now off the tape.
			state = 1;
		} else if(l < tape_thresh && r < tape_thresh && state < 0) { // Both QRDs are off the tape, and the robot is tilted to the left.
			state = -5;
		} else if(l < tape_thresh && r < tape_thresh && state > 0) { // Both QRDs are off, the robot is tilted to the right.
			state = 5;
		} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the robot was last straight on. This indicates that we somehow lifted both up at the same time (top of the hill), and so we continue straight ahead. Courtesy of Andre Marziali.
			state = 0;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure. I think it is to do with the whole 'remembering' thing. Ironic.
		if(state != thisState) {
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// Big ol' note: in our case, the 'state' variables are the error from the centre, just renamed so we understand better. Not everyone can be Andre Marziali!

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This writes our output to the motors
		// Motor 3 = Right
		// Motor 2 = Left
		motor.speed(3, tape_speed + result);
		motor.speed(2, tape_speed - result);  


		// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations. This can be removed if there is not enough space on the LCD screen.
		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}
		i++;

		thisTime++;
		thisState = state;
	}
	motor.stop_all();
}

//Runs Analog PID Demonstration
void analog_pid(){
	int left, right;

	int pro, der, result;

	int current_error; 
	int last_error = 0;

	int i = 0; 

	int K_p 		= EEPROM.read(1)*4;
	int K_d 		= EEPROM.read(2)*4;
	int tape_speed 	= EEPROM.read(3)*4;

	while(!deselect()){
		//Read from QRDs
		left = analogRead(0);
		right = analogRead(1);

		current_error = left - right;

		if (current_error > 300 ){
			current_error = 300;
		}

		pro = K_p*current_error;
		der = (current_error - last_error)*K_d;

		result = pro + der;

		motor.speed(3, tape_speed - result );
		motor.speed(2, tape_speed + result);

		last_error = current_error;

		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.setCursor(0,0); LCD.print("L:"); LCD.print(left); LCD.print(" R:"); LCD.print(right);
			LCD.setCursor(0,1);	LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}
		i++;
	}
	motor.stop_all();
}

//Runs QRD Sensor Module
void tape_follow_sensor(){
	int l;
	int r;

	while(!deselect()){
		//Read From QRD Sensors
		l = analogRead(4);
		r = analogRead(5);

		//Print To Screen QRD Sensors
		clear();
		
		LCD.setCursor(0,0); LCD.print("L:"); LCD.print(l);
		LCD.setCursor(0,1); LCD.print("R:"); LCD.print(r);
		delay(200);
	}
}

//NOT DONE
//Checks to see if the QRDs see t
bool tape_detected(){

}


void follow_tape(){

	// Initializing tape following parameters
	static	int state;			  // The state of the robot (straight, left, right, or hard left/right)
	static	int lastState   = 0;  // The previous state of the robot.
	static	int thisState   = 0;  // The state which the robot is currently running in (i.e. a plateau)
	static	int lastTime    = 0;  // The time the robot spent in the last state.
	static	int thisTime    = 0;  // The time the robot has spent in this state.
	static	int i 		    = 0;  // i for iterations, because I'm old-school like that.

	static	int pro;  			  // Taking a leaf out of Andre's book, this stands for the proportional function.
	static	int der;  			  // As one might expect, this is the derivative function (no integrals on my watch!)
	static	int result;  		  // The result of our pro and der, this goes to the motors.    

		// Setting up the variables that will be edited
	static	int tape_K_p 	= EEPROM.read(1)*4;
	static	int tape_K_d 	= EEPROM.read(2)*4;
	static	int tape_speed 	= EEPROM.read(3)*4;
	static	int tape_thresh = EEPROM.read(4)*4;

	
	//Follow Tape
	//Reading QRD Sensors
	int l = analogRead(4); // Left QRD
	int r = analogRead(5); // Right QRD (but you knew that already, you're smart)

	if(l > tape_thresh && r > tape_thresh) { // Both QRDs are on the tape
		state = 0;
	} else if(l < tape_thresh && r > tape_thresh) { // The left QRD has moved off the tape.
		state = -1;
	} else if(l > tape_thresh && r < tape_thresh) { // The right QRD is now off the tape.
		state = 1;
	} else if(l < tape_thresh && r < tape_thresh && state < 0) { // Both QRDs are off the tape, and the robot is tilted to the left.
		state = -5;
	} else if(l < tape_thresh && r < tape_thresh && state > 0) { // Both QRDs are off, the robot is tilted to the right.
		state = 5;
	} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the robot was last straight on. This indicates that we somehow lifted both up at the same time (top of the hill), and so we continue straight ahead. Courtesy of Andre Marziali.
		state = 0;
	}


	// To be honest, I'm not 100% sure of what this does. Something important, I'm sure. I think it is to do with the whole 'remembering' thing. Ironic.
	if(state != thisState) {
		lastState = thisState;
		lastTime = thisTime;
		thisTime = 1;
	}

	// Big ol' note: in our case, the 'state' variables are the error from the centre, just renamed so we understand better. Not everyone can be Andre Marziali!

	// This is our P/D part; defining our (pro)portional and (der)ivative control
	pro = tape_K_p * state;
	der = (int)((float)tape_K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

	// They're then added together with the robot's speed to produce our output.
	result = pro + der;

	// This writes our output to the motors
	// Motor 3 = Left
	// Motor 2 = Right
	motor.speed(2, tape_speed + result);
	motor.speed(3, tape_speed - result);  


	// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations. This can be removed if there is not enough space on the LCD screen.
	if( i == 50) {
		LCD.clear();
		LCD.home(); 

		LCD.setCursor(0,0);	LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
		LCD.setCursor(0,1); LCD.print("Kp:"); LCD.print(tape_K_p); LCD.print(" Kd:"); LCD.print(tape_K_d);

		i = 0;
	}
	i++;

	thisTime++;
	thisState = state;
}

