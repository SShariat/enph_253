// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

void artifact_collect(){

	//

	bool servo = false;
	int height = 10; // The initial height of the arm; remember that this is an angle, and divide it by two to get the actual deflection.

	// The current method of detecting an artifact is a QRD attached to the side of the artifact dropper. This has the advantage of being both lighter and more reliable than a physical switch. We use the QRD's crappy range for our own advantage! :D

	// Anyhoo, the sensor usually reports values ranging from ~150 to 300-something, then drops to about 40ish when an artifact is collected. As such, I've made the threshold 100, though it will most likely be tweaked at sometime in the future. Feel free to make it a variable if you'd like, but it's not crucial for the robot, as we'll pick a value and stick with it.

	// This code here simply is a diagnostic; it prints out the current value of the QRD so that we know what it's seeing.
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print( analogRead(0) );
	delay(50);


	if(analogRead(0) < 100) { // Artifact detection 'if' statement.
	                          // 
		LCD.setCursor(0,1); LCD.print("Object Detected!");
		delay(50);

		// Setting this variable to true means we don't have to rely on the QRD constantly being triggered; once we detect something, we are committed to the pickup sequence.
		servo = true; 

	} else {

		LCD.setCursor(0,1); LCD.print("Scanning..."); // Just a 'scanning' text block to display on the screen when we don't see anything. It's cool.
		delay(50);		
	}

	if(servo == true){

		// Vertical 
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