//Libraries
	#include <HardwareSerial.h>
	#include <phys253.h>
	#include <LiquidCrystal.h>
	#include <Servo253.h>
	#include <EEPROM.h>

//Memory Addresses Currently Being Used(Do not Write to Already Being Used Ad)
/*
	TAPE FOLLOWING
	K_p 		1
	K_d 		2
	tape_speed 	3
	tape_thresh 4

	IR FOLLOWING
	K_p			5
	K_d			6
	ir_speed 	7

	ARTIFACT COLLECTION
	height		8

	RUN ALL

	*/

//ROOT TREE
	#define ROOT 7

	//ROOT CHILDREN
	#define TAPE_FOLLOW 1 			// Follows tape utilizing PD control.
	#define IR_FOLLOW 2            	// Follows an IR beacon.
	#define ARTIFACT_COLLECTION 3  	// Collects artifacts using the robot arm.
	#define MOTOR 4                	// H-Bridge Test Program that Simultaneously Runs 2 Motors at the same time.
	#define RUN_ALL 5   		   	// Runs everything above at once.
	#define TT_DEMO 6              	// The demonstration function for time trials day.
	#define INITIALIZE 7			// Reset the Variable Values to Hard Coded Versions

//Editor Variables for Parameter Manipulation
#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void artifact_collection();
void artifact_collection_vars();
void artifact_collection_demo();
bool artifact_detected();
void collect_artifact();
int menu_choice(int num_choices);
void clear();
bool confirm();
bool deselect();
void incomplete();
void display_var(int var);
void display_new_var(char name[]);
void print_root(char name[]);
void print_child(char name[]);
void edit_variable(int addr, char name[],int max_range);
void initialize_vars();
void ir_follow();
void ir_follow_vars();
void ir_follow_demo();
void ir_follow_sensor();
void motor_test();
void run_all();
void run_all_tape_collect();
void tape_follow();
void tape_follow_vars();
void tape_follow_demo();
void analog_pid();
void tape_follow_sensor();
void time_trial_demo();
int current, new_value;

// ---------------------------------------------------------------------------------------------------------- \\
// Setup function

void setup(){

	// Initializes the motor inputs.
	portMode(0, INPUT);
	portMode(1, INPUT);

	// Servomotor initialization.
	RCServo0.attach(RCServo0Output);
	RCServo1.attach(RCServo1Output);
	RCServo2.attach(RCServo2Output);
}

// ---------------------------------------------------------------------------------------------------------- \\
// Root Loop function

//Main Loop Function
void loop(){

	clear();
	//Print Selection Statement and Clears the Screen
	print_root("Select: ");

	switch(menu_choice(ROOT)){

		case TAPE_FOLLOW:
		print_child("Tape-Follow");
		//This Implements the Different Tape Following Options
		if(confirm()){
			tape_follow();
		}
		break;

		case IR_FOLLOW:
		print_child("IR-Follow");
		if(confirm()){
			ir_follow();
		}
		break;

		case ARTIFACT_COLLECTION:
		print_child("Art. Collect");
		if(confirm()){
			artifact_collection();
		}
		break;

		case MOTOR:
		print_child("Motor");
		if(confirm()){
			motor_test();
		}
		break;

		case RUN_ALL:
		print_child("Run-All");
		if(confirm()){
			run_all();
		}
		break;

		case TT_DEMO:
		print_child("Time Trial Demo");
		if(confirm()){
			time_trial_demo();
		}
		break;

		case INITIALIZE:
		print_child("Reset Vars?");
		if(confirm()){
			clear();
			initialize_vars();
			LCD.setCursor(0,0);LCD.print("Saved");
			delay(500);
			clear();
		}	
		break;
	}
	delay(200);
}
// ---------------------------------------------------------------------------------------------------------- \\
// Artifact collection functions

//Artifact Collection Root
void artifact_collection(){

	//TAPE FOLLOW TREE
	#define OPTIONS 2
	//TAPE CHILDREN
	#define ARTIFACT_VARS 1
	#define ARTIFACT_DEMO 2

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

		}
		delay(200);
	}
}

//Artifact Collection variables****************INCOMPLETE
void artifact_collection_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 1

	#define HEIGHT 1

	while(!deselect()){
	
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case HEIGHT:
		//Changing Variable 1
			edit_variable(8, "HEIGHT",180);
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
bool artifact_detected(){
	if(analogRead(6)>80){
		return true;
	}
	else
		return false;
}

//Sets Arm to Appropriate Angles and Stores the artifact ****************INCOMPLETE
void collect_artifact(){

	int height = EEPROM.read(8)*4;

	motor.stop_all();

	LCD.setCursor(0,0); LCD.print("Searching...");
	while(!artifact_detected()){
	}

	clear();
	LCD.setCursor(0,0); LCD.print("Collecting...");

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
	
	clear();
	LCD.setCursor(0,0); LCD.print("Done");
}
// ---------------------------------------------------------------------------------------------------------- \\
// Helper Functions

//Knob 6 Value is converted to menu selection.
int menu_choice(int num_choices){
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	int choice = (1.1*(knob(7) * (num_choices - 1)) / 1024) + 1;
	if(choice>num_choices){
		choice = num_choices;
	}
	return choice;
}

//Clears the LCD Screen on TINAH
void clear(){
	LCD.clear(); 
	LCD.home();
}

//Confirm Selection with a Delay
bool confirm(){
	if(startbutton()){
		delay(300);
		return true;
	}
	else{
		return false;
	}
}

//Deselect Selection with a Delay
bool deselect(){
	if(stopbutton()){
		delay(300);
		return true;
	}
	else{
		return false;
	}
}

//Where ever this function is, it displays the IN PROGRESS Text on TINAH
void incomplete(){
	while(!deselect()){
				clear();
				LCD.setCursor(0,0); LCD.print("In Progress");
				delay(200);
	}
}

//Prints the Value of a Variable when scrolling through list of Possibilities
void display_var(int var){

	LCD.setCursor(0,1); LCD.print("Value: "); LCD.print(var);
}

//Displays editing mode
void display_new_var(char name[]){
	clear();
	LCD.setCursor(0,0); LCD.print(name);
	LCD.setCursor(0,1); LCD.print("C:"); LCD.print(current); LCD.print(" N:"); LCD.print(new_value);
}

//Prints the root name of the tree
void print_root(char name[]){
	
	LCD.setCursor(0,0); LCD.print(name);
}

//Prints the child name of the tree
void print_child(char name[]){

	LCD.setCursor(0,1); LCD.print(name);
}

//Edits a variable and saves it to 
void edit_variable(int addr, char name[],int max_range){
	current = EEPROM.read(addr)*4;
	LCD.print(name);
	display_var(EEPROM.read(addr)*4);
	if(confirm()){
		while(!deselect()){
			//Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
			new_value = (int)(((float)knob(7)/1000.0)*max_range);

			if(new_value > max_range){
				new_value = max_range;
			}

			//new_value = knob(7);
			display_new_var(name);
			if(confirm()){
				EEPROM.write(addr,new_value/4);
				current = new_value;
			}
			delay(200);
		}
	}
}

//This is the Initializer Function that resets the value of all the editable variables to hard coded values
void initialize_vars(){
	/*
	TAPE FOLLOWING
	K_p 		1
	K_d 		2
	tape_speed 	3
	tape_thresh 4

	IR FOLLOWING
	K_p			5
	K_d			6
	ir_speed 	7

	ARTIFACT COLLECTION
	height		8

	RUN ALL
	*/

	EEPROM.write(1,(int)(250/4.0));
	EEPROM.write(2,(int)(25/4.0));
	EEPROM.write(3,(int)(300/4.0));
	EEPROM.write(4,(int)(100/4.0));
	
	EEPROM.write(5,(int)(250/4.0));
	EEPROM.write(6,(int)(25/4.0));
	EEPROM.write(7,(int)(400/4.0));
	
	EEPROM.write(8,(int)(16/4.0));
}
// ---------------------------------------------------------------------------------------------------------- \\
// IR following functions

//Root Tree
void ir_follow(){
	//Number of Options
	#define OPTIONS 3
	//TAPE CHILDREN
	#define IR_FOLLOW_VARS 1
	#define IR_FOLLOW_DEMO 2
	#define IR_FOLLOW_SENSOR 3

	while(!deselect()){

		clear();
		print_root("IR-Follow");

		switch(menu_choice(OPTIONS)){

			case IR_FOLLOW_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				ir_follow_vars();
			}
			break;

			case IR_FOLLOW_DEMO:
			print_child("Run Demo");
			if(confirm()){
				ir_follow_demo();
			}
			break;

			case IR_FOLLOW_SENSOR:
			print_child("Check Sensors");
			if(confirm()){
				ir_follow_sensor();
			}
			break;

		}
		delay(200);
	}
}

//IR Following Variable Editor
void ir_follow_vars(){
	
	#define NUM_OF_CONSTANTS 3

	#define KP 1
	#define KD 2
	#define SPEED 3

	while(!deselect()){
	
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			edit_variable(5, "K_p",1000);
		break;

		case KD:
		//Changing Variable 2
			edit_variable(6, "K_d",1000);
		break;
		
		case SPEED:
		//Changing Variable 3
			edit_variable(7, "Speed",1000);
		break;
		}
		delay(200);
	}
}

//IR Following Demonstration
void ir_follow_demo(){
	int left_low, left_high;
	int right_low, right_high;

	int left, right;

	int pro, der, result;

	int current_error; 
	int last_error = 0;

	int i = 0; 

	int K_p 		= EEPROM.read(5)*4;
	int K_d 		= EEPROM.read(6)*4;
	int tape_speed 	= EEPROM.read(7)*4;

	while(!deselect()){

		left_high 	= analogRead(0);
		left_low 	= analogRead(1);
		right_high 	= analogRead(2);
		right_low 	= analogRead(3);

		//Gain Switching
		/*If Low Gain is Railing
			Switch to High Gain*/
		if((left_high+right_high)>2000){
			left = left_low;
			right = right_low;
		}
		else{
			left = left_high;
			right = right_high;
		}

		current_error = left - right;

		if (current_error > 200 ){
			current_error = 200;
		}

		if (current_error < -200 ){
			current_error = -200;
		}

		pro = K_p*current_error;
		der = (current_error - last_error)*K_d;

		result = pro + der;

		motor.speed(3, tape_speed + result );
		motor.speed(2, tape_speed - result);

		last_error = current_error;

		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(left); LCD.print(" R: "); LCD.print(right);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}
		i++;
	}
	motor.stop_all();
}

//IR Following Without Motors Running
void ir_follow_sensor(){
	
	// IR Detection Variables
	int left_high;
	int left_low;
	int right_high;
	int right_low;
	
	while(!deselect()){
		left_high= (float)(analogRead(0));
		left_low = (float)(analogRead(1));
		right_high = (float)(analogRead(2));
		right_low = (float)(analogRead(3));
		
		clear();
		LCD.setCursor(0,0);LCD.print("L "); LCD.print("LO:"); LCD.print(left_low); LCD.print("HI:"); LCD.print(left_high);
		LCD.setCursor(0,1);LCD.print("R "); LCD.print("LO:"); LCD.print(right_low); LCD.print("HI:"); LCD.print(right_high);
		
		delay(200);
	}
}
// ---------------------------------------------------------------------------------------------------------- \\
// Motor control functions

//H-Bridge Testing Function
void motor_test(){
	
	//Motor Test Variables (These are the speeds of 2 Motors)
	int speed_1, speed_2;
	
	while(!deselect()){
		speed_1 = 2*(analogRead(6) - 511);
		speed_2 = 2*(analogRead(7) - 511);

		if (speed_1 >1023) {
			speed_1 = 1023;
		} else if ( speed_1 < -1023) {
			speed_1 = -1023;
		}

		if (speed_2 >1023) {
			speed_2 = 1023;
		} else if ( speed_2 < -1023) {
			speed_2 = -1023;
		}

		motor.speed(3,speed_1);
		motor.speed(2,speed_2);

		clear();
		LCD.setCursor(0,0); LCD.print("M1: "); LCD.print(speed_1);
		LCD.setCursor(0,1); LCD.print("M2: "); LCD.print(speed_2);

		delay(50);
	}
	//Added Motor Stop Function
	motor.stop_all();
}
// ---------------------------------------------------------------------------------------------------------- \\
// Run-All Functions

//Run All Tree
void run_all(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 1
	//TAPE CHILDREN
	#define FOLLOW_COLLECT 1

	while(!deselect()){

		clear();
		print_root("Run-All");

		switch(menu_choice(OPTIONS)){

			case FOLLOW_COLLECT:
			print_child("Fol.+Coll.");
			if(confirm()){
				run_all_tape_collect();
			}
			break;
		}
		delay(200);
	}
}

// This is combination tape follow and artifact collection system.
void run_all_tape_collect(){
	// Initializing tape following parameters
	int state       = 0;  // The state of the robot (straight, left, right, or hard left/right)
	int lastState   = 0;  // The previous state of the robot.
	int thisState   = 0;  // The state which the robot is currently running in (i.e. a plateau)
	int lastTime    = 0;  // The time the robot spent in the last state.
	int thisTime    = 0;  // The time the robot has spent in this state.
	int i 		    = 0;  // i for iterations, because I'm old-school like that.

	int pro         = 0;  // Taking a leaf out of Andre's book, this stands for the proportional function.
	int der         = 0;  // As one might expect, this is the derivative function (no integrals on my watch!)
	int result      = 0;  // The result of our pro and der, this goes to the motors.    

	// Setting up the variables that will be edited
	int K_p 		= EEPROM.read(1)*4;
	int K_d 		= EEPROM.read(2)*4;
	int tape_speed 	= EEPROM.read(3)*4;
	int tape_thresh = EEPROM.read(4)*4;

	while(!deselect()){

		//Reading QRD Sensors
		int l = analogRead(0); // Left QRD
		int r = analogRead(1); // Right QRD (but you knew that already, you're smart)

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
		} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the robot was last straight on. This indicates that we somehow lifted both up at the same time (top of the hill), and so we continue straight ahead. Courtesy of Andre Marziali.
			state = 0;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure. I think it is to do with the whole 'remembering' thing. Ironic.
		if(state != thisState) {
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// Big ol' note: in our case, the 'state' variables are the error from the centre, just renamed so we understand better. Not everyone can be Andre Marziali!

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This writes our output to the motors
		motor.speed(3, tape_speed - result );
		motor.speed(2, tape_speed + result);  


		// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations. This can be removed if there is not enough space on the LCD screen.
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

		if(artifact_detected()){
			clear();
			collect_artifact();
		}
	}
	motor.stop_all();
}
// ---------------------------------------------------------------------------------------------------------- \\
// Tape Following Tree

//Root Tape Following
void tape_follow(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 4
	//TAPE CHILDREN
	#define TAPE_VARS 1
	#define TAPE_DEMO 2
	#define ANALOG_PID 3
	#define TAPE_SENSOR 4

	while(!deselect()){

		clear();
		print_root("Tape-Follow");

		switch(menu_choice(OPTIONS)){

			case TAPE_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				tape_follow_vars();
			}
			break;

			case TAPE_DEMO:
			print_child("Run Demo");
			if(confirm()){
				tape_follow_demo();
			}
			break;

			case ANALOG_PID:
			print_child("Analog PID");
			if(confirm()){
				analog_pid();
			}
			break;

			case TAPE_SENSOR:
			print_child("Check Sensors");
			if(confirm()){
				tape_follow_sensor();
			}
			break;
		}
		delay(200);
	}
}

//Tape-Following Variable Editor
void tape_follow_vars(){

	#define NUM_OF_CONSTANTS 4

	#define KP 1
	#define KD 2
	#define SPEED 3
	#define THRESH 4

	while(!deselect()){
	
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			edit_variable(1, "K_p",1000);
		break;

		case KD:
		//Changing Variable 2
			edit_variable(2, "K_d",1000);
		break;
		
		case SPEED:
		//Changing Variable 3
			edit_variable(3, "Speed",1000);
		break;

		case THRESH:
		//Changing Variable 4
			edit_variable(4, "Thresh",1000);
		break;


		}
		delay(200);
	}
}

//Runs PID Demonstration
void tape_follow_demo(){

	// Initializing tape following parameters
	int state       = 0;  // The state of the robot (straight, left, right, or hard left/right)
	int lastState   = 0;  // The previous state of the robot.
	int thisState   = 0;  // The state which the robot is currently running in (i.e. a plateau)
	int lastTime    = 0;  // The time the robot spent in the last state.
	int thisTime    = 0;  // The time the robot has spent in this state.
	int i 		    = 0;  // i for iterations, because I'm old-school like that.

	int pro         = 0;  // Taking a leaf out of Andre's book, this stands for the proportional function.
	int der         = 0;  // As one might expect, this is the derivative function (no integrals on my watch!)
	int result      = 0;  // The result of our pro and der, this goes to the motors.    

	// Setting up the variables that will be edited
	int K_p 		= EEPROM.read(1)*4;
	int K_d 		= EEPROM.read(2)*4;
	int tape_speed 	= EEPROM.read(3)*4;
	int tape_thresh = EEPROM.read(4)*4;

	while(!deselect()){

		//Reading QRD Sensors
		int l = analogRead(4); // Left QRD
		int r = analogRead(5); // Right QRD (but you knew that already, you're smart)

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
		} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the robot was last straight on. This indicates that we somehow lifted both up at the same time (top of the hill), and so we continue straight ahead. Courtesy of Andre Marziali.
			state = 0;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure. I think it is to do with the whole 'remembering' thing. Ironic.
		if(state != thisState) {
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// Big ol' note: in our case, the 'state' variables are the error from the centre, just renamed so we understand better. Not everyone can be Andre Marziali!

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This writes our output to the motors
		// Motor 3 = Right
		// Motor 2 = Left
		motor.speed(3, tape_speed + result);
		motor.speed(2, tape_speed - result);  


		// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations. This can be removed if there is not enough space on the LCD screen.
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
	}
	motor.stop_all();
}

//Runs Analog PID Demonstration
void analog_pid(){
	int left, right;

	int pro, der, result;

	int current_error; 
	int last_error = 0;

	int i = 0; 

	int K_p 		= EEPROM.read(1)*4;
	int K_d 		= EEPROM.read(2)*4;
	int tape_speed 	= EEPROM.read(3)*4;

	while(!deselect()){
		//Read from QRDs
		left = analogRead(0);
		right = analogRead(1);

		current_error = left - right;

		if (current_error > 300 ){
			current_error = 300;
		}

		pro = K_p*current_error;
		der = (current_error - last_error)*K_d;

		result = pro + der;

		motor.speed(3, tape_speed - result );
		motor.speed(2, tape_speed + result);

		last_error = current_error;

		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.setCursor(0,0); LCD.print("L:"); LCD.print(left); LCD.print(" R:"); LCD.print(right);
			LCD.setCursor(0,1);	LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}
		i++;
	}
	motor.stop_all();
}

//Runs QRD Sensor Module
void tape_follow_sensor(){
	while(!deselect()){
		//Read From QRD Sensors
		int l = analogRead(4);
		int r = analogRead(5);

		//Print To Screen QRD Sensors
		clear();
		LCD.setCursor(0,0); LCD.print("L:"); LCD.print(l);
		LCD.setCursor(0,1); LCD.print("R:"); LCD.print(r);
		delay(200);
	}
}
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

