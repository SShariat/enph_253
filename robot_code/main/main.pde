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