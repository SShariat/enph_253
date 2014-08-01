// ---------------------------------------------------------------------------------------------------------- \\
// Run-All Functions

//Run All Tree
void run_all_tree(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 2
	//TAPE CHILDREN
	#define ART_STOP_COLLECT 1
	#define VARS_EDIT 2

	while(!deselect()){

		clear();
		print_root("Run-All");

		switch(menu_choice(OPTIONS)){

			case ART_STOP_COLLECT:
			print_child("Art+Stop Coll.");
			if(confirm()){
				art_stop_collect();
			}
			break;

			case VARS_EDIT:
			print_child("Edit Vars.");
			if(confirm()){
				run_all_vars();
			}
			break;
		}
		delay(200);
	}
}

void art_stop_collect(){
	// Initializing Tape Following Parameters
		int state       = 0;  // The state of the robot (straight, left, right, or hard left/right)
		int lastState   = 0;  // The previous state of the robot.
		int thisState   = 0;  // The state which the robot is currently running in.
		int lastTime    = 0;  // The time the robot spent in the last state.
		int thisTime    = 0;  // The time the robot has spent in this state.
		int i 		    = 0;  // i for iterations

		int pro         = 0;  // Proportional Function
		int der         = 0;  // Derivative Function
		int result      = 0;  // Result of Proportional and Derivative   

		// Setting up the variables that will be edited
		int K_p 		= EEPROM.read(1)*4;
		int K_d 		= EEPROM.read(2)*4;
		int tape_speed 	= EEPROM.read(3)*4;
		int tape_thresh = EEPROM.read(4)*4;

		int thresh = EEPROM.read(12)*4;
	while(!deselect()){
		if(artifact_detected(thresh)){
			collect_artifact();
		}
		//Tape Following Code
		else{
			//Reading QRD Sensors
			int l = analogRead(4); // Left QRD
			int r = analogRead(5); // Right QRD (but you knew that already, you're smart)

			if(l > tape_thresh && r > tape_thresh) { // Both QRDs are on the tape
				state = 0;
			} else if(l < tape_thresh && r > tape_thresh){ // The left QRD has moved off the tape.
				state = -1;
			} else if(l > tape_thresh && r < tape_thresh){ // The right QRD is now off the tape.
				state = 1;
			} else if(l < tape_thresh && r < tape_thresh && state < 0) { // Both QRDs are off the tape, and the robot is tilted to the left.
				state = -5;
			} else if(l < tape_thresh && r < tape_thresh && state > 0) { // Both QRDs are off, the robot is tilted to the right.
				state = 5;
			} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the robot was last straight on. This indicates that we somehow lifted both up at the same time (top of the hill), and so we continue straight ahead. Courtesy of Andre Marziali.
				state = 0;
			}

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
	}
	motor.stop_all();
}

void run_all_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 9

	#define KP 1
	#define KD 2
	#define SPEED 3
	#define THRESH_TAPE 4
	#define START_HEIGHT 5
	#define RAISE_HEIGHT 6
	#define START_ANGLE 7
	#define END_ANGLE 8
	#define THRESH_ART 9

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

		case THRESH_TAPE:
		//Changing Variable 4
			edit_variable(4, "Thresh",1000);
		break;

		case START_HEIGHT:
		//Changing Variable 1
			edit_variable(8, "Start H",180);
		break;

		case RAISE_HEIGHT:
		//Changing Variable 1
			edit_variable(9,"Raise H",180);
		break;

		case START_ANGLE:
		//Changing Variable 1
			edit_variable(10,"Start A",180);
		break;

		case END_ANGLE:
		//Changing Variable 1
			edit_variable(11,"End A",180);
		break;

		case THRESH_ART:
			edit_variable(12,"Thresh",1000);
		break;

		}
		delay(200);
	}	
}

void full_run(){

	//Different Robot States
	#define FOLLOW_TAPE 	1
	#define COLLECT_ART 	2
	#define FOLLOW_IR 		3
	#define COLLECT_IDOL	4
	#define ROTATE_ROBOT 	5

	//Initializing Starting State
	int robot_state = FOLLOW_TAPE;

	// Initializing tape following parameters
		int state       = 0;  // The state of the robot (straight, left, right, or hard left/right)
		int lastState   = 0;  // The previous state of the robot.
		int thisState   = 0;  // The state which the robot is currently running in (i.e. a plateau)
		int lastTime    = 0;  // The time the robot spent in the last state.
		int thisTime    = 0;  // The time the robot has spent in this state.
		int i 		    = 0;  // i for iterations, because I'm old-school like that.

		int pro         = 0;  // Taking a leaf out of Andre's book, this stands for the proportional function.
		int der         = 0;  // As one might expect, this is the derivative function (no integrals on my watch!)
		int result      = 0;  // The result of our pro and der, this goes to the motors.    

		// Setting up the variables that will be edited
		int K_p 		= EEPROM.read(1)*4;
		int K_d 		= EEPROM.read(2)*4;
		int tape_speed 	= EEPROM.read(3)*4;
		int tape_thresh = EEPROM.read(4)*4;

	while(!deselect()){
		switch(robot_state){
			case FOLLOW_TAPE:
				if(artifact_detected(80)){
					robot_state = COLLECT_ART;
				}
				else if(ir_detected()){
					robot_state = FOLLOW_IR;
				}
				else{
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
			break;

			case COLLECT_ART:
				collect_artifact();
				robot_state = FOLLOW_TAPE; 
			break;

			case FOLLOW_IR:
				if(ir_thresh()){
					robot_state = COLLECT_IDOL;
				}
				else if(tape_detected()){
					robot_state = FOLLOW_TAPE;
				}
				else{
					//Follow IR
				}
			break;

			case COLLECT_IDOL:
				collect_idol();
				robot_state = ROTATE_ROBOT;
			break;

			case ROTATE_ROBOT:
				if(ir_detected()){
					robot_state = FOLLOW_IR;
				}
				else{
					//Rotate Robot
				}
			break;
		}
	}
	motor.stop_all();
}