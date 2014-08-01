// ---------------------------------------------------------------------------------------------------------- \\
// Artifact collection functions

//Artifact Collection Root
void artifact_collection(){

	//TAPE FOLLOW TREE
	#define OPTIONS 3
	//TAPE CHILDREN
	#define ARTIFACT_VARS 1
	#define ARTIFACT_DEMO 2
	#define SENSOR_CHECK 3

	while(!deselect()){
		clear();
		print_root("Art. Collection");

		switch(menu_choice(OPTIONS)){

			case ARTIFACT_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				artifact_collection_vars();
			}
			break;

			case ARTIFACT_DEMO:
			print_child("Run Demo");
			if(confirm()){
				clear();
				collect_artifact();
			}
			break;

			case SENSOR_CHECK:
			print_child("Sensor Check");
			if(confirm()){
				artifact_sensor_check();
			}
			break;

		}
		delay(200);
	}
}

//Artifact Collection variables****************INCOMPLETE
void artifact_collection_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 5

	#define START_HEIGHT 1
	#define RAISE_HEIGHT 2
	#define START_ANGLE 3
	#define END_ANGLE 4
	#define THRESH 5
		
	while(!deselect()){
	
		clear();
		print_root("Var: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
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

			case THRESH:
				edit_variable(12,"Thresh",1000);
			break;
		}
		
		delay(200);
	}	
}

//Artifact Collection Demonstration
void artifact_collection_demo(){

	// // Artifact counter, currently unused.
	// int artifacts = 0;

	// Angle above ground, 16 seems good for now.
	int height = 16; 
	                 
	// This variable ensures that once we detect something, we are committed to the pickup sequence.
	bool servo = false;

	while(!deselect()){

		//it prints out the current value of the QRD
		clear();
		LCD.setCursor(0,0); LCD.print( analogRead(6) );
		delay(50);


		// Artifact detection 'if' statement. Please note, if this is run concurrent with any sort of time-dependant function, the printing to the screen MUST be commented out; otherwise the delays and time taken will severely mess with the timing (like for the tape following code)
		if(analogRead(6) < 80){
			LCD.setCursor(0,1); LCD.print("Object Detected!");
			delay(50);
			servo = true; 
		} else{
			// Just a 'scanning' text block to display on the screen when we don't see anything. It's cool.
			LCD.setCursor(0,1); LCD.print("Scanning..."); 
			delay(200);		
		}

		// The following is the series of commands for the arm to pick up an idol, drop it in the bucket, then return to its starting position.
		if(servo == true){

			// Stops motors, we currently can't move and pick stuff up.
			motor.stop_all();

			// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
			// This will traverse slowly, so that the idol doesn't get knocked off.
			for(int pos = height; pos < 100; pos += 1){
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

			// Now, we set the 'servo' function to false, and iterate the number of artifacts we've picked up. Again, this number will help us keep track of where we are on the course.
			servo = false;
			// artifacts++;
		}
	}
}

//Returns Boolean Value if an Artifact is Collected
bool artifact_detected(int thresh){

	if(analogRead(6)<thresh){
		return true;
	}
	else
		return false;
}

//Sets Arm to Appropriate Angles and Stores the artifact ****************INCOMPLETE
void collect_artifact(){

	int timer;

	int start_height = EEPROM.read(8)*4;
	int raise_height = EEPROM.read(9)*4;
	int start_angle = EEPROM.read(10)*4;
	int end_angle =	EEPROM.read(11)*4;

	//Artifact Collect Threshold
	int thresh = EEPROM.read(12)*4;

	motor.stop_all();

	//Writing to Stuff
	LCD.setCursor(0,0); LCD.print("Searching...");
		
	while(!artifact_detected(thresh)){
	}
	
	clear();
	LCD.setCursor(0,0); LCD.print("Collecting...");

	// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
	for(int pos = start_height; pos < raise_height; pos += 1){
		RCServo1.write(pos);
		delay(15);
	} 

	// Horizontal arm, brings the idol into position over the bucket.
	// Again, it travels slowly.
	for(int pos = start_angle; pos < end_angle; pos += 1){
		RCServo2.write(pos); 
		delay(10);
	}

	// Now, we drop off the artifact
	// Unlike the last two, this is executed quickly, though we do have a delay after the execution, as the artifact may be swinging and may take more than half a second to disengage.
	RCServo0.write(180);delay(1000);
	// Then we return the end to its initial position.
	RCServo0.write(0);delay(500);
	// Next, the arm moves horizontally back to its starting position.
	// This is quick, since we don't have an artifact on the end.
	RCServo2.write(start_angle);delay(500);
	// Finally, the arm is lowered to its proper height.
	// This is quickly done as well.
	RCServo1.write(start_height);delay(500);
	
	clear();
	LCD.setCursor(0,0); LCD.print("Done");
}

void artifact_sensor_check(){
	int artifact_eye;
	while(!deselect()){
		
		artifact_eye = analogRead(6);

		clear();
		
		LCD.setCursor(0,0); LCD.print("Art.:"); LCD.print(artifact_eye);
		
		delay(200);
	}
}
