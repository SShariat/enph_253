//Libraries
	#include <HardwareSerial.h>
	#include <phys253.h>
	#include <LiquidCrystal.h>
	#include <Servo253.h>
	#include <EEPROM.h>

//ROOT TREE
	#define ROOT 5

	//ROOT CHILDREN
	#define TAPE_FOLLOW 1 			// Follows tape utilizing PD control.
	#define IR_FOLLOW 2            	// Follows an IR beacon.
	#define ARTIFACT_COLLECTION 3  	// Collects artifacts using the robot arm.
	#define MOTOR 4                	// H-Bridge Test Program that Simultaneously Runs 2 Motors at the same time.
	#define RUN_ALL 5   		   	// Runs everything above at once.

//Editor Variables for Parameter Manipulation
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

	//Sets the Ending Angle of the Servos
	delay(1000);
	RCServo1.write(180);
	delay(1000);
	RCServo2.write(0);
	delay(1000);
	RCServo2.write(160);
	delay(1000);
	RCServo2.write(20);
	delay(1000);
	RCServo1.write(45);
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
			tape_follow_tree();
		}
		break;

		case IR_FOLLOW:
		print_child("IR-Follow");
		if(confirm()){
			ir_follow_tree();
		}
		break;

		case ARTIFACT_COLLECTION:
		print_child("Art. Collect");
		if(confirm()){
			artifact_collection_tree();
		}
		break;

		case MOTOR:
		print_child("Motor");
		if(confirm()){
			motor_tree();
		}
		break;

		case RUN_ALL:
		print_child("Run-All");
		if(confirm()){
			run_all_tree();
		}
		break;
	}
	delay(200);
}