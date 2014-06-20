#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

#define MAX 10
#define SIZE  5

/*
////////////////////////////////////////////////
ROBOT TEMPLATE FILE
- Menu Template
- Constant Declarations
- Function Declarations
- DO STUFF BLOCK
/////////////////////////////////////////////////
*/

//Global Variables
int 		const_number = 3;
int 		const_values [3] = {1,2,3};
char 	const_names [MAX][SIZE];

void setup()
{
 
}

void loop()
{
//Constant Value Selection
LCD.clear(); LCD.home();
LCD.setCursor(0,0); LCD.print("Change Constants");
LCD.setCursor(0,1); LCD.print("Press Start");
while (!(startbutton()));

while(!(stopbutton())){
	change_constants(const_values,const_names, const_number);  
}


//DO STUFF BLOCK
}

//Function Declarations
void change_constants(int values[], char names[][SIZE], int array_size){
	//Take knob value as Index
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	int index =  ((knob(6) * (SIZE-1) ) / 1020 )  ;
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Testing");
	LCD.setCursor(0,1); LCD.print(const_values(index));
	delay(200);
}

