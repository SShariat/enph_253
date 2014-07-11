#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

// How long our variable names must be. Keep them short!
#define STR_SIZE 10

// The number of variables we can define. Needs to be updated should any new ones be added.
#define NUM_CONST 5

/*
//////////////////////////////////////////////// I dunno what all this stuff it, I'll leave it alone.
ROBOT TEMPLATE FILE
- Menu Template

- DO STUFF BLOCK
/////////////////////////////////////////////////
*/

// Initialize Arrays
// This gives our constants values, then assigns them names.
#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void artifact_collect();
void change_constants(int values[], char names[][STR_SIZE], int array_size);
void go_forward();
void init_variables(int values[], char names[][STR_SIZE], int array_size);
int  const_values [NUM_CONST] = {1,2,3,0,12};
char const_names  [NUM_CONST][STR_SIZE] =  {"foo", "bar", "bletch", "foofoo", "lol"};

void setup()
{
	// Servomotor initialization.
	RCServo0.attach(RCServo0Output);
	RCServo1.attach(RCServo1Output);
	RCServo2.attach(RCServo2Output);
}

void loop()
{
	// These dudes are commented out for now; I'm just worried about getting the servos to work.

	 change_constants(const_values,const_names, NUM_CONST);

	 init_variables(const_values,const_names, NUM_CONST);
	
	// Code controlling the moving forward of the robot. May want to simply integrate the PD control into this function and call it something else
	// go_forward(); 


	// Artifact detection and collection code.
	artifact_collect();
}
// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

void artifact_collect(){

	// This is very much a Work In Progress, the timings and the angles need to be adjusted. Fortunately, they shouldn't become part of the constants function, as we can simply measure the angles on the robot itself, and use dead reckoning for the times.

	bool servo = false;

	while(!(stopbutton())){

		// double angle = 0;
		
		// angle = 180.0*analogRead(7)/1023;

		// RCServo2.write(angle);

	 //    LCD.clear();
	 //    LCD.home();
	 //    LCD.setCursor(0,0); LCD.print("Servomotor Cntrl");
	 //    LCD.setCursor(0,1); LCD.print(angle);
		// delay(50);

		LCD.clear();
		LCD.home();
		LCD.setCursor(0,0); LCD.print("Switch Pressed?");

		if(digitalRead(10) == 1) {

			LCD.setCursor(0,1); LCD.print("ye");
			delay(50);

			servo = true;

		} else {

			LCD.setCursor(0,1); LCD.print("no");
			delay(50);		
		}

		if(servo == true){

			RCServo2.write(90);
			delay(1000);

			RCServo1.write(30);
			delay(1000);

			RCServo0.write(180);
			delay(3000);

			RCServo0.write(0);
			delay(500);
			RCServo1.write(0);
			delay(500);
			RCServo2.write(0);
			delay(500);

			servo = false;
		}
	}
};
void change_constants(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Change Constants");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while(!(startbutton()));
	
	while(!(stopbutton())){
	
	//Take knob value as Index
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	
	//Print the Name and Associated Value of the Constant Name to the Screen
	int index =  ((knob(6) * (NUM_CONST-1) ) / 1000 )  ;
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Name: "); LCD.print(names[index]);
	LCD.setCursor(0,1); LCD.print("Value: ");LCD.print(values[index]);
	
	//This is the Editing Block. While you are holding the Start Button you are editing the current constant that you are at.
	while(startbutton()){
		int new_value = knob(6);
		values[index] = new_value;		
		LCD.clear(); LCD.home();
		LCD.setCursor(0,0); LCD.print("Name: "); LCD.print(names[index]);
		LCD.setCursor(0,1); LCD.print("Value: ");LCD.print(values[index]);
		delay(200);
	}
		
	delay(200);
	}
}
// This runs the go forward script where the motor speed of the robot is simply set
// to go forward. I will include the PD code in here as well, then rename the code.
// For now, 'go_forward' suffices.

void go_forward(){

};
/*
int  const_values [NUM_CONST] = {1,2,3,0,12};
char const_names  [NUM_CONST][STR_SIZE] =  {"foo", "bar", "bletch", "foofoo", "lol"};
*/


void init_variables(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Init-Constants");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while (!(startbutton()));

//	initialization template, for now you have to make sure the names match up so that it is not confusing when you code	
//	int ___ = value[]; 
	int foo 	= values[0];
	int bar 	= values[1];
	int bletch 	= values[2];
	int foofoo 	= values[3];
	int lol 	= values[4];
}

