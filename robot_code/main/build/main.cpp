#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

#define STR_SIZE 10
#define NUM_CONST 5

/*
////////////////////////////////////////////////
ROBOT TEMPLATE FILE
- Menu Template
- Constant Declarations
- Function Declarations
- DO STUFF BLOCK
/////////////////////////////////////////////////
*/

//Initialize Arrays
#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void change_constants(int values[], char names[][STR_SIZE], int array_size);
void init_variables(int values[], char names[][STR_SIZE], int array_size);
int  const_values [NUM_CONST] = {1,2,3,0,12};
char const_names  [NUM_CONST][STR_SIZE] =  {"foo", "bar", "bletch", "foofoo", "lol"};

void setup()
{
 
}

void loop()
{
	change_constants(const_values,const_names, NUM_CONST);

	
	init_variables(const_values,const_names, NUM_CONST);
	//DO STUFF BLOCK
}
void change_constants(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Change Constants");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while (!(startbutton()));
	
	while(!(stopbutton())){
	
	//Take knob value as Index
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	
	//Print the Name and Associated Value of the Constant Name to the Screen
	int index =  ((knob(6) * (NUM_CONST-1) ) / 1000 )  ;
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Name: "); LCD.print(names[index]);
	LCD.setCursor(0,1); LCD.print("Value: ");LCD.print(values[index]);
	

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
void init_variables(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Initialize constants?");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while (!(startbutton()));


};

