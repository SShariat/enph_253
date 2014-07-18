#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

//Level Definitions
#define NUMCHOICES 3
#define CHOICE1 1
#define CHOICE2 2
#define CHOICE3 3


// Menu Template

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
int menu_choice(int number_of_choices);
void clear();
void setup()
{

}

void loop(){

	clear();
	//print knob(6) value
	LCD.setCursor(0,1); LCD.print(knob(6));
	switch(menu_choice(NUMCHOICES)){

		case CHOICE1:
			LCD.setCursor(0,0); LCD.print("Choice 1");
		break;

		case CHOICE2:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,0); LCD.print("Choice 2");
		break;

		case CHOICE3:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,0); LCD.print("Choice 3");
		break;

	}
	delay(200);

}

//Helper Functions

//Knob 6 Value is converted to menu selection.
//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
int menu_choice(int number_of_choices){
	int choice = (1.1*(knob(6) * (3 - 1)) / 1024) + 1;
	return choice;
}


//Clear Screen
void clear(){
	LCD.clear(); LCD.home();
}


