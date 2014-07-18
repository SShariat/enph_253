#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>


//TODO LIST

//	-Add Delay to Bush Buttons so that it only registers 1 press
//


#define NUMCHOICES 4

//Available Options
#define TAPEFOLLOW 1
#define IRFOLLOW 2
#define ARTIFACT 3
#define RUNALL 4


// Menu Template

void setup()
{

}

//User State Initialization

void loop(){

	clear();
	LCD.setCursor(0,0); LCD.print("Select: ");
	
	switch(menu_choice()){

		case TAPEFOLLOW:
		LCD.setCursor(0,1);LCD.print("Tape-Follow");
			//Tis Implements the Different Tape Following Options
		if(startbutton()){
			tape_follow();
		}
		break;

		case IRFOLLOW:
		LCD.setCursor(0,1);LCD.print("IR-Follow");
		if(startbutton()){
			
		}
		break;

		case ARTIFACT:
		LCD.setCursor(0,1);LCD.print("Artifact");
		if(startbutton()){
			
		}
		break;

		case RUNALL:
		LCD.setCursor(0,1);LCD.print("RUN-ALL");
		if(startbutton()){
			
		}
		break;

	}
	delay(200);
}


////////////////////
/*Helper Functions*/
////////////////////


//Knob 6 Value is converted to menu selection.
//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
int menu_choice(){
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	int choice = (1.1*(knob(6) * (NUMCHOICES - 1)) / 1024) + 1;
	if(choice>NUMCHOICES){
		choice = NUMCHOICES;
	}
	return choice;
}

//Clears the LCD Screen on TINAH
void clear(){
	LCD.clear(); 
	LCD.home();
}

