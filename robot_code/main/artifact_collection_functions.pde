// ---------------------------------------------------------------------------------------------------------- \\
// Artifact collection functions

//Artifact Collection Root
void artifact_collection_tree(){

	//TAPE FOLLOW TREE
	#define OPTIONS 4
	//TAPE CHILDREN
	#define ARTIFACT_VARS 1
	#define ARTIFACT_COLL 2
	#define IDOL_COLL 3
	#define CRANE_TEST 4

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

			case ARTIFACT_COLL:
			print_child("Collect Art.");
			if(confirm()){
				clear();
				collect_artifact();
			}
			break;

			case IDOL_COLL:
			print_child("Collect Idol");
			if(confirm()){
				clear();
				collect_idol();
			}
			break;

			case CRANE_TEST:
			print_child("Crane Test");
			if(confirm()){
				crane_test();
			}
			break;

		}
		delay(200);
	}
}

//Artifact Collection variables
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

//Sets Arm to Appropriate Angles and Stores the artifact
void collect_artifact(){
	clear();
	LCD.setCursor(0,1); LCD.print("Coll. Art...");

	int start_height = 45;
	int raise_height = 110;
	int start_angle = 20;
	int end_angle =	160;

	//Artifact Collect Threshold
	int thresh = EEPROM.read(12)*4;

	motor.speed(2, -100);
	motor.speed(3, -100); 
	motor.speed(2, 100);
	motor.speed(3, 100); 

	// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
	for(int pos = start_height; pos <= raise_height; pos++){
		RCServo1.write(pos);
		delay(15);
	} 

	// Horizontal arm, brings the idol into position over the bucket.
	// Again, it travels slowly.
	for(int pos = start_angle; pos <= end_angle; pos++){
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
}

//Sequence of Servo Commands to pick up the Idol
void collect_idol(){
	clear();
	LCD.setCursor(0,1); LCD.print("Coll. Idol...");

	int start_height = 50;
	int raise_height = 110;
	int start_angle = 20;
	int end_angle =	160;

	//Artifact Collect Threshold
	int thresh = EEPROM.read(12)*4;

	motor.stop_all();

	// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
	for(int pos = start_height; pos <= raise_height; pos++){
		RCServo1.write(pos);
		delay(15);
	} 

	// Horizontal arm, brings the idol into position over the bucket.
	// Again, it travels slowly.
	for(int pos = start_angle; pos <= end_angle; pos++){
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
}

void crane_test(){
	int hor;
	int ver;

	while(!deselect()){

		hor = (int)(((float)knob(6)/1000.0)*180);
		ver = (int)(((float)knob(7)/1000.0)*180);

		if(hor > 180){
			hor = 180;
		}

		if(ver > 180){
			ver = 180;
		}

		clear();
		LCD.setCursor(0,0);LCD.print("Hor: "); LCD.print(hor);
		LCD.setCursor(0,1);LCD.print("Ver: "); LCD.print(ver);

		RCServo1.write(ver);
		RCServo2.write(hor);

	delay(200);
	}
}