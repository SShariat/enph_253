#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>


//ROOT TREE
#define ROOT 4
//ROOT CHILDREN
#define TAPE_FOLLOW 1
#define IR_FOLLOW 2
#define ARTIFACT 3
#define RUNALL 4


//TAPE FOLLOW TREe
#define TAPE 3
//TAPE CHILDREN
#define TAPE_VARS 1
#define TAPE_DEMO 2
#define TAPE_SENSOR 3



#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void tape_follow();
int menu_choice(int num_choices);
void clear();
bool confirm();
bool deselect();
void setup()
{

}

//User State Initialization
// Root Loop
void loop(){

	//Print Selection Statement and Clears the Screen
	clear();
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
			while(!stopbutton()){
				LCD.setCursor(0,0); LCD.print("FOLLOWINGIR");
			}
		}
		break;

		case ARTIFACT:
		LCD.setCursor(0,1);LCD.print("Artifact");
		if(confirm()){
			while(!stopbutton()){
				LCD.setCursor(0,0); LCD.print("COLLARTIFACT");
			}
		}
		break;

		case RUNALL:
		LCD.setCursor(0,1);LCD.print("RUN-ALL");
		if(confirm()){
			while(!stopbutton()){
				LCD.setCursor(0,0); LCD.print("RUNNINGALL");
			}
		}
		break;

	}
	delay(200);
}


//TAPE Follow Tree Loop
void tape_follow(){

	while(!deselect()){

		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow: ");

		switch(menu_choice(TAPE)){

			case TAPE_VARS:
			LCD.setCursor(0,1); LCD.print("Demo");
			if(confirm()){
				while(!deselect()){
				LCD.setCursor(0,0); LCD.print("DEMOING");
				}
			}
			break;

			case TAPE_DEMO:
			LCD.setCursor(0,1); LCD.print("Sensor");
			if(confirm()){
			//Insert Sensor Function
		}
			break;

			case TAPE_SENSOR:
			if(confirm()){
			//Insert Sensor Function
		}
			break;
		}
		delay(200);
	}
}

////////////////////
/*Helper Functions*/
////////////////////

//Knob 6 Value is converted to menu selection.
//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
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


bool confirm(){
	if(startbutton()){
		delay(500);
		return true;
	}
	else{
		return false;
	}
}

bool deselect(){
	if(stopbutton()){
		delay(500);
		return true;
	}
	else{
		return false;
	}
}



