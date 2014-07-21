#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>
#include <EEPROM.h>

//ROOT TREE
#define ROOT 4
//ROOT CHILDREN
#define TAPE_FOLLOW 1
#define IR_FOLLOW 2
#define ARTIFACT_COLLECTION 3
#define RUN_ALL 4

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void tape_follow();
void tape_follow_vars();
void tape_follow_sensor();
int menu_choice(int num_choices);
void clear();
bool confirm();
bool deselect();
void incomplete();
int current, new_value = 0;

int test_1 = 0;
int k_p = 0;
int k_d = 0;
int motor_speed = 0;


// Parameters List



void setup()
{

}

// ROOT LOOP
void loop(){

	clear();
	//Print Selection Statement and Clears the Screen
	LCD.setCursor(0,0); LCD.print("Select: ");

	switch(menu_choice(ROOT)){

		case TAPE_FOLLOW:
		LCD.setCursor(0,1);LCD.print("Tape-Follow");
		//Tis Implements the Different Tape Following Options
		if(confirm()){
			tape_follow();
		}
		break;

		case IR_FOLLOW:
		LCD.setCursor(0,1);LCD.print("IR-Follow");
		if(confirm()){
			incomplete();
		}
		break;

		case ARTIFACT_COLLECTION:
		LCD.setCursor(0,1);LCD.print("Artifact");
		if(confirm()){
			incomplete();
		}
		break;

		case RUN_ALL:
		LCD.setCursor(0,1);LCD.print("RUN-ALL");
		if(confirm()){
			incomplete();
		}
		break;

	}
	delay(200);
}


//TAPE Follow Tree Loop

void tape_follow(){
	//TAPE FOLLOW TREE
	#define OPTIONS 3
	//TAPE CHILDREN
	#define TAPE_VARS 1
	#define TAPE_DEMO 2
	#define TAPE_SENSOR 3

	while(!deselect()){

		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow:");

		switch(menu_choice(OPTIONS)){

			case TAPE_VARS:
			LCD.setCursor(0,1); LCD.print("Edit Vars");
			if(confirm()){
				clear();
				tape_follow_vars();
				delay(200);
			}
			break;

			case TAPE_DEMO:
			LCD.setCursor(0,1); LCD.print("Run Demo");
			if(confirm()){
				incomplete();
			}
			break;

			case TAPE_SENSOR:
			LCD.setCursor(0,1); LCD.print("Check Sensors");
			if(confirm()){
				incomplete();
			}
			break;
		}
		delay(200);
	}
}

//TAPE FUNCTIONS
void tape_follow_vars(){

	#define NUM_OF_CONSTANTS 1

	#define VAR_1 1

	int current = 0;

	while(!deselect()){
		clear();
		LCD.setCursor(0,0); LCD.print("Variable: ");


		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case VAR_1:
		current = test_1;
		LCD.print("VAR1");
		LCD.setCursor(0,1); LCD.print("Curr: "); LCD.print(test_1);
		if(confirm()){
			while(!deselect()){
				new_value = knob(7);
				clear();
				LCD.setCursor(0,0); LCD.print("VAR1");
				LCD.setCursor(0,1); LCD.print("Cur:"); LCD.print(current); LCD.print(" New:"); LCD.print(new_value);
				delay(200);
			}
			test_1 = new_value; 
		}
		break;
		
		}
		delay(200);

	}

}


//tape_follow_demo
//Runs the PID Tape Following Program
//Parameters:
//	-Threshold
//	-kp
//	-kd
// 	-motorspeed

/*
void tape_follow_demo(){
	
	while(!deselect()){

		//Reading QRD Sensors
		int l = analogRead(0);
		int r = analogRead(1);

		if(l > threshold && r > threshold) {
			state = 0;
		} else if(l < threshold && r > threshold) {
			state = -1;
		} else if(l > threshold && r < threshold) {
			state = 1;
		} else if(1 < threshold && r < threshold && state < 0) {
			state = -5;
		} else if(1 < threshold && r < threshold && state >= 0) {
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

		//Writes Output to Motor
		motor.speed(3, speed - result);
		motor.speed(2, speed + result);  

		if( i==50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}

		i++;
		thisTime++; // This time baby, I'll be, forevvvvvahhhhhhh
		thisState = state;
	}
}
*/

void tape_follow_sensor(){
	while(!deselect()){
		int l = analogRead(0);
		int r = analogRead(1);

		//Print To Screen QRD Sensors
	}
}



//////////////////////////
//	 Helper FUNCTIONS 	//
//////////////////////////

//Knob 6 Value is converted to menu selection.
int menu_choice(int num_choices){
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	int choice = (1.1*(knob(6) * (num_choices - 1)) / 1024) + 1;
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
		delay(500);
		return true;
	}
	else{
		return false;
	}
}

//Deselect Selection with a Delay
bool deselect(){
	if(stopbutton()){
		delay(500);
		return true;
	}
	else{
		return false;
	}
}


void incomplete(){
	while(!deselect()){
				clear();
				LCD.setCursor(0,0); LCD.print("In Progress");
				delay(200);
	}
}

