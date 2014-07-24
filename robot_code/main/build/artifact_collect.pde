// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

void artifact_collect(){

	// This is very much a Work In Progress, the timings and the angles need to be adjusted. Fortunately, they shouldn't become part of the constants function, as we can simply measure the angles on the robot itself, and use dead reckoning for the times.

	bool servo = false;
	int height = 10; // The initial height of the arm; remember that this is an angle, and divide it by two to get the actual deflection.

	//while( !( stopbutton() ) ) {

		// double angle = 0;
		
		// angle = 180.0*analogRead(7)/1023;  //Dunno what all this is

		// RCServo2.write(angle);

	 //    LCD.clear();
	 //    LCD.home();
	 //    LCD.setCursor(0,0); LCD.print("Servomotor Cntrl");
	 //    LCD.setCursor(0,1); LCD.print(angle);
		// delay(50);
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print( analogRead(0) );
	delay(50);

		if(analogRead(0) < 100) {
			LCD.clear();
			LCD.setCursor(0,1); LCD.print("Object Detected!");
			delay(50);

			servo = true;

		} else {

			LCD.setCursor(0,1); LCD.print("Scanning...");
			delay(50);		
		}

		if(servo == true){

			// RCServo1.write(120); //Vertical arm up
			// delay(1000);

		  for(int pos = height; pos < 100; pos += 1)  // goes from 0 degrees to 180 degrees 
		  {                                  // in steps of 1 degree 
		    RCServo1.write(pos);              // tell servo to go to position in variable 'pos' 
		    delay(15);                       // waits 15ms for the servo to reach the position 
		  } 



			// RCServo2.write(180);
			// delay(1000);


		  // Horizontal arm

		  for(int pos = 0; pos < 180; pos += 1)  // goes from 0 degrees to 180 degrees 
		  {                                  // in steps of 1 degree 
		    RCServo2.write(pos);              // tell servo to go to position in variable 'pos' 
		    delay(10);                       // waits 15ms for the servo to reach the position 
		  } 


			RCServo0.write(180); //drop off the artifact
			delay(1000);

			RCServo0.write(0); // return artifact dropper to default
			delay(500);

			RCServo2.write(0);
			delay(500);

			// for(int pos = 180; pos>=1; pos-=1)     // goes from 180 degrees to 0 degrees 
			//   {                                
			//     RCServo2.write(pos);              // tell servo to go to position in variable 'pos' 
			//     delay(5);                       // waits 15ms for the servo to reach the position 
			//   }

			RCServo1.write(height);  //return to normal height
			delay(500);


			servo = false;
		}
	//}
}
