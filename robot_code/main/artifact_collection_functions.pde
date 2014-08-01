// ---------------------------------------------------------------------------------------------------------- \\
// Artifact collection functions

//Artifact Collection Root
void artifact_collection_tree(){

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
				artifact_collection_demo();
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

//Sets Arm to Appropriate Angles and Stores the artifact ****************INCOMPLETE
void collect_artifact(){

	int start_height = EEPROM.read(8)*4;
	int raise_height = EEPROM.read(9)*4;
	int start_angle = EEPROM.read(10)*4;
	int end_angle =	EEPROM.read(11)*4;

	//Artifact Collect Threshold
	int thresh = EEPROM.read(12)*4;

	motor.stop_all();

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

//Returns Boolean Value if an Artifact is Collected
bool artifact_detected(int thresh){

	if(analogRead(6)<thresh){
		return true;
	}
	else
		return false;
}

//NOT DONE
//Sequence of Servo Commands to pick up the Idol
void collect_idol(){

}