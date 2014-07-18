void three_tape_follow() {
	
	int l = analogRead(0); // We're initializing the left, centre, and right analog sensors.
	int c = analogRead(1);
	int r = analogRead(2);

	int K_p = analogRead(6);
	int K_d = analogRead(7);

	// The following is Zach's lovely stop function.
	if( stopbutton() ) {
			delay(50); // Pause to make sure the stopbutton wasn't pressed by motor noise.

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


	if(l > threshold && r > threshold && c > threshold) { // This is when the robot is in the middle of the course.
		state = 0;
	} 
	else if(l < threshold && c > threshold && r > threshold) { // This is when the left sensor is off the tape.
		state = -1;
	}
	else if(l < threshold && c < threshold && r > threshold && state < 0) { // Both the left and centre sensors are off now.
		state = -3;
	} 
	else if(1 < threshold && r < threshold && state < 0) { // All three sensors are off, the robot is to the left of the tape.
		state = -5;
	}
	else if(l > threshold && c > threshold && r < threshold) { // The rightmost sensor is off the tape.
		state = 1;
	}
	else if(l > threshold && c < threshold && r < threshold && state >= 0) { // Both the right and centre sensors have strayed.
		state = 3;
	}
	else if(l < threshold && c < threshold && r < threshold && state >= 0) { // The robot is now wandering to the right of the tape.
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

	motor.speed(3, speed - result);
	motor.speed(2, speed + result);  

	if( i==50) {
		LCD.clear();
		LCD.home(); 

		LCD.print("L "); LCD.print(l); LCD.print(" C "); LCD.print(c); LCD.print(" R "); LCD.print(r);
		LCD.setCursor(0,1);
		LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

		i = 0;
	}

	i++;
	thisTime++; // This time baby, I'll be, forevvvvvahhhhhhh

	thisState = state;	

}
