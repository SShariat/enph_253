// ---------------------------------------------------------------------------------------------------------- \\
// Run-All Functions

//Run All Tree
void run_all(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 1
	//TAPE CHILDREN
	#define FOLLOW_COLLECT 1

	while(!deselect()){

		clear();
		print_root("Run-All");

		switch(menu_choice(OPTIONS)){

			case FOLLOW_COLLECT:
			print_child("Fol.+Coll.");
			if(confirm()){
				run_all_tape_collect();
			}
			break;
		}
		delay(200);
	}
}

// This is combination tape follow and artifact collection system.
void run_all_tape_collect(){
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

		//Reading QRD Sensors
		int l = analogRead(0); // Left QRD
		int r = analogRead(1); // Right QRD (but you knew that already, you're smart)

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
		motor.speed(3, tape_speed - result );
		motor.speed(2, tape_speed + result);  


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

		if(artifact_detected()){
			clear();
			collect_artifact();
		}
	}
	motor.stop_all();
}