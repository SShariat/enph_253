// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

// The current method of detecting an artifact is a QRD attached to the side of the artifact dropper. This has the advantage of being both lighter and more reliable than a physical switch. We use the QRD's crappy range for our own advantage! :D

// Anyhoo, the sensor usually reports values ranging from ~120 to 200-something, then drops to about 40ish when an artifact is collected. As such, I've made the threshold 100. We may want to reduce this at some point in the future, and feel free to make it a variable if you'd like, but it's not crucial for time trials.

void artifact_collect(){

	// This variable ensures that once we detect something, we are committed to the pickup sequence.
	bool servo = false;

	// This code here simply is for debug purposes; it prints out the current value of the QRD so that we know what it's seeing.
	// LCD.clear(); LCD.home();
	// LCD.setCursor(0,0); LCD.print( analogRead(3) );
	// delay(50);


	// Artifact detection 'if' statement.
	if(analogRead(3) < 80) { 
	                          
		// LCD.setCursor(0,1); LCD.print("Object Detected!");
		// delay(50);

		
		servo = true; 

	} else {

		// Just a 'scanning' text block to display on the screen when we don't see anything. It's cool.
		// LCD.setCursor(0,1); LCD.print("Scanning..."); 
		// delay(50);		
	}



	// The following is the series of commands for the arm to pick up an idol, drop it in the bucket, then return to its starting position.

	if(servo == true){

		motor.stop_all();

		// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
		// This will traverse slowly, so that the idol doesn't get knocked off.
		for(int pos = height; pos < 100; pos += 1) {

			RCServo1.write(pos);
			delay(15);

		} 


		// Horizontal arm, brings the idol into position over the bucket.
		// Again, it travels slowly.
		for(int pos = 0; pos < 150; pos += 1) {

			RCServo2.write(pos); 
			delay(10);

		} 


		// Now, we drop off the artifact.
		// Unlike the last two, this is executed quickly.
		RCServo0.write(180); delay(500);

		// Then we return the end to its initial position.
		RCServo0.write(0); delay(500);

		// Next, the arm moves horizontally back to its starting position.
		// This is quick, since we don't have an artifact on the end.
		RCServo2.write(0); delay(500);

		// Finally, the arm is lowered to its proper height.
		// This is quickly done as well.
		RCServo1.write(height);  //return to normal height
		delay(500);

		// Now, we set the 'servo' function to false, and iterate the number of artifacts we've picked up. This number will help us keep track of where we are on the course.
		servo = false;
		artifacts++;
	}
//}
}