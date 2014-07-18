#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>


#define NUMCHOICES 4

//Available Options
#define TAPEFOLLOW 1
#define IRFOLLOW 2
#define ARTIFACT 3
#define RUNALL 4


// Menu Template

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
int menu_choice();
void clear();
void confirm();
void deselect();
void tape_follow();
void setup()
{

}

//User State Initialization
bool user_state = false;

void loop(){

	clear();
	LCD.setCursor(0,0); LCD.print("Select: ");
	
	switch(menu_choice()){

		case TAPEFOLLOW:
			LCD.setCursor(0,1);LCD.print("Tape-Follow");

			if(startbutton()){
				tape_follow();
			}


		break;

		case IRFOLLOW:
			LCD.setCursor(0,1);LCD.print("IR-Follow");
		break;

		case ARTIFACT:
			LCD.setCursor(0,1);LCD.print("Artifact");
		break;

		case RUNALL:
			LCD.setCursor(0,1);LCD.print("RUN-ALL");
		break;

	}
	delay(200);

}

//Helper Functions

//Knob 6 Value is converted to menu selection.
//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
int menu_choice(){
	int choice = (1.1*(knob(6) * (NUMCHOICES - 1)) / 1024) + 1;
	return choice;
}

//Clear Screen
void clear(){
	LCD.clear(); LCD.home();
}

void confirm(){
	user_state = true;
}

void deselect(){
	user_state = false;
}
//Tape Following Function

//Number of Options
#define NUMCHOICES 3

//Available Options
#define DEMO 1
#define VARS 2
#define SENSOR 3


void tape_follow(){
	

	while(!stopbutton()){
		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow: ");


		switch(menu_choice()){

			case DEMO:
		//if stop button is not pressed
			LCD.setCursor(0,1); LCD.print("Demo");
			break;

			case VARS:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,1); LCD.print("Variables");
			break;

			case SENSOR:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,1); LCD.print("Sensor");
			break;
		}
		delay(200);
	}
}

