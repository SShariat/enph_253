//Libraries
#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>
#include <EEPROM.h>

//ROOT TREE

#define ROOT 5

//ROOT CHILDREN
#define TAPE_FOLLOW 1
#define IR_FOLLOW 2
#define ARTIFACT_COLLECTION 3
#define MOTOR 4
#define RUN_ALL 5


//Editor Variables for Parameter Manipulation
int current, new_value = 0;
int speed_1, speed_2;


//Parameters that will be Edited During Testing
int test_1;
int test_2;

void setup(){
	// Initializing the motor inputs.
	portMode(0, INPUT);
	portMode(1, INPUT);

	//Variables that will be Edited
	test_1 = EEPROM.read(1)*4;
	test_2 = EEPROM.read(2)*4;
}

// ROOT LOOP
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
			incomplete();
		}
		break;

		case ARTIFACT_COLLECTION:
		print_child("Art. Collect");
		if(confirm()){
			incomplete();
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
				incomplete();
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

//TAPE FOLLOWING MODULES

// Tape Following Variable Editor
// 1. Select Variable
// 2. Press start to go into edit mode
// 3. Select Value using knob 7 and press stop to save that value
void tape_follow_vars(){

	#define NUM_OF_CONSTANTS 2

	#define VAR1 1
	#define VAR2 2

	while(!deselect()){
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case VAR1:
		//Changing Variable 1
			current = test_1;
			LCD.print("VAR1");
			display_var(test_1);
			if(confirm()){
				while(!deselect()){
					new_value = knob(7);
					display_new_var("VAR1");
				delay(200);
				}
				test_1 = new_value;
				EEPROM.write(1,new_value/4); 
			}
		break;

		case VAR2:
		//Changing Variable 2
			current = test_2;
			//LCD.setCursor(0,1);LCD.print("MOTOR");
			LCD.print("VAR2");
			display_var(test_2);
			if(confirm()){
				while(!deselect()){
					new_value = -knob(7);
					display_new_var("VAR2");
				delay(200);
				}
				test_2 = new_value;
				EEPROM.write(2,new_value/4); 
			}
		break;


		}
		delay(200);
	}
}

/*
//tape_follow_demo
//Runs the PID Tape Following Program
//Parameters:
//	-threshold
//	-kp
//	-kd
// 	-motorspeed
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
		thisTime++;
		thisState = state;
	}
}
*/

//Runs QRD Sensor Module
void tape_follow_sensor(){
	while(!deselect()){
		//Read From QRD Sensors
		int l = analogRead(0);
		int r = analogRead(1);

		//Print To Screen QRD Sensors
		clear();
		LCD.setCursor(0,0); LCD.print("L:"); LCD.print(l);
		LCD.setCursor(0,1); LCD.print("R:"); LCD.print(r);
		delay(200);
	}
}

//Motor Functions
void motor_test(){
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

void print_root(char name[]){
	
	LCD.setCursor(0,0); LCD.print(name);
}

void print_child(char name[]){

	LCD.setCursor(0,1); LCD.print(name);
}