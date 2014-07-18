#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

//Level Definitions
#define CHOICE0 1
#define CHOICE1 2
#define CHOICE2 3


// Menu Template

void setup()
{

}

void loop(){

		switch(menu_choice()){

		case CHOICE0:
			LCD.setCursor(0,0); LCD.print("Choice 1");
		break;

		case CHOICE1:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,0); LCD.print("Choice 2");
		break;

		case CHOICE2:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,0); LCD.print("Choice 3");
		break;

		clear();
	}

}

//Helper Functions

//Knob 6 Value is converted to menu selection.
//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
int menu_choice(int number_of_choices){
	int choice = (((knob(6) - 0) * (number_of_choices - 1)) / (1024 - 0)) + 1
	return choice;
}


//Clear Screen
void clear(){
	LCD.clear(); LCD.home();
}

