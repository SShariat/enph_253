// This is the tape following code. It is the same as Charles', with changed constants to make up for the different weight/turning radius.

void tape_follow(){

	int l = analogRead(0); // We're initializing the left and right analog sensors.
	int r = analogRead(1);

	int K_p = analogRead(6);
	int K_d = analogRead(7);

	// The following is Zach's lovely stop function.
	if( stopbutton() ) {
			delay(50); // Pause to make sure the stopbutton wasn't pressed by motor noise. (dunno how that could happen, but okay)

		if( stopbutton() ) {
			motor.speed(3, 0);
			motor.speed(2, 0); 

			while( !startbutton() ) {
				int K_p = analogRead(6);
				int K_d = analogRead(7);

				LCD.clear();
				LCD.home();
				LCD.print("PAUSED");    
				LCD.setCursor(0,1);
				LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

				delay(50);
			}  
		}
	}




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
		} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the code 
			state = 0;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure.
		if(state != thisState) {
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This 700 is only here because that was the maximum speed Charles could go without damage. I've removed it for now.
		// if(result > 700 - tape_speed){
		// 	result = 700;
		// }

		// This writes our output to the motors
		motor.speed(3, (1) * (tape_speed - result) );
		motor.speed(2, tape_speed + result);  


		// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations.
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

};
