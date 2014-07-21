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


	if(l > threshold && r > threshold) {
		state = 0;
	} else if(l < threshold && r > threshold) {
		state = -1;
	} else if(l > threshold && r < threshold) {
		state = 1;
	} else if(1 < threshold && r < threshold && state < 0) {
		state = -5;
	} else if(1 < threshold && r < threshold && state >= 0) {
		state = 5;
	}


	if(state != thisState) {
		lastState = thisState;
		lastTime = thisTime;
		thisTime = 1;
	}

	pro = K_p * state;
	der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

	result = speed + pro + der;

	if(result > 700 - speed){
		result = 700;
	}

	motor.speed(3, speed + result);
	motor.speed(2, speed + result);  

	if( i==50) {
		LCD.clear();
		LCD.home(); 

		LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
		LCD.setCursor(0,1);
		LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

		i = 0;
	}

	i++;
	thisTime++; // This time baby, I'll be, forevvvvvahhhhhhh

	thisState = state;

};