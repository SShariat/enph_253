// ---------------------------------------------------------------------------------------------------------- \\ 
// Time Trials Functions

//
void time_trial_demo(){

	// Alright, here we go.

	// First, we must drive forward, then as soon as we hit an artifact, we pick it up, turn around, and drive home.

	// Loop tape following.

	// If we see an artifact, pick it up, then spin the robot around.

	// Then, as soon as we see the tape disappear, stop the robot.


	// Initialize tape following parameters
	int state     = 0;  // The state of the robot (straight, left, right, or hard left/right)
	int lastState = 0;  // The previous state of the robot.
	int thisState = 0;  // The state which the robot is currently running in (i.e. a plateau)
	int lastTime  = 0;  // The time the robot spent in the last state.
	int thisTime  = 0;  // The time the robot has spent in this state.
	int i 		  = 0;  // i for iterations, because I'm old-school like that.

	int pro       = 0;  // Taking a leaf out of Andre's book, this stands for the proportional function.
	int der       = 0;  // As one might expect, this is the derivative function (no integrals on my watch!)
	int result    = 0;  // The result of our pro and der, this goes to the motors.    

	// Setting up the variables that will be edited
	int K_p 		= EEPROM.read(1)*4;
	int K_d 		= EEPROM.read(2)*4;
	int tape_speed 	= EEPROM.read(3)*4;
	int tape_thresh = EEPROM.read(4)*4;

	//Artifact collection parameters
	int artifacts = 0;
	int height = 16; // angle above ground
	                 
	// This variable ensures that once we detect something, we are committed to the pickup sequence.
	bool servo = false;

	//Artifact Collection Section

	while(!deselect()){

		//Reading QRD Sensors
		int l = analogRead(0); // Left QRD
		int r = analogRead(1); // Right QRD (but you knew that already, you're smart)

		// Both QRDs are on the tape
		if(l > tape_thresh && r > tape_thresh){ 
			state = 0;
		}

		// The left QRD has moved off the tape
		else if(l < tape_thresh && r > tape_thresh){
			state = -1;
		} 

		// The right QRD is now off the tape.
		else if(l > tape_thresh && r < tape_thresh){
			state = 1;
		}

		// Both QRDs are off the tape, and the robot is tilted to the left.
		else if(l < tape_thresh && r < tape_thresh && state < 0){
			state = -5;
		}

		// Both QRDs are off, the robot is tilted to the right.
		else if(l < tape_thresh && r < tape_thresh && state > 0){
			state = 5;
		}
		// Both QRDs are now off the tape, and in this case it means that the tape has ended. Hence, we stop ( or break, since I'm a heavy-handed coder.)
		else if(l < tape_thresh && r < tape_thresh && state == 0){ 
			break;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure.
		if(state != thisState){
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This writes our output to the motors
		motor.speed(3, tape_speed - result);
		motor.speed(2, tape_speed + result);  


		// Every fifty iterations, we check if there's an artifact under our crane and print out some diagnostic text for the tape-following.
		if( i == 50){

			if(analogRead(3) < 80){
				servo = true;
			}

			LCD.clear(); LCD.home(); 

			LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			// Lol, reset the iterations.
			i = 0;
		}


		// Now, if we did see an artifact*, the crane will have to pick it up. Hence, the following loop.
		// (*) alleged artifact may be a person's fingers, some part of the competition surface, or just noise in the circuits.
		if(servo == true){

			// Stops motors, we don't want to move *and* pick stuff up.
			motor.stop_all();

			// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
			// This will traverse slowly, so that the idol doesn't get knocked off.
			for(int pos = height; pos < 100; pos += 1){
				RCServo1.write(pos);
				delay(15);
			} 

			// Horizontal arm, brings the idol into position over the bucket.
			// Again, it travels slowly.
			for(int pos = 0; pos < 150; pos += 1){
				RCServo2.write(pos); 
				delay(10);
			} 

			// Now, we drop off the artifact.
			// Unlike the last two, this is executed quickly, though we do have a delay after the execution, as the artifact may be swinging and may take more than half a second to disengage.
			RCServo0.write(180); delay(1000);

			// Then we return the end to its initial position.
			RCServo0.write(0); delay(500);

			// Next, the arm moves horizontally back to its starting position.
			// This is quick, since we don't have an artifact on the end.
			RCServo2.write(0); delay(500);

			// Finally, the arm is lowered to its proper height.
			// This is quickly done as well.
			RCServo1.write(height);
			delay(500);
		}
		// Then, we iterate the iterations (bwaaaaaaaah), and do some state switching.
		i++;
		thisTime++;
		thisState = state;

	}

	motor.stop_all();
}
