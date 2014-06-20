#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>
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
int const_number = 3;
int const_values [3] = {0,0,0};
char const_names [3][10] = {"speed","kp","kd"};

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
	change_constants(const_names,const_values, const_number);  
}

//Constant Declarations
int var_1 = const_values[0];
int var_2 = const_values[1];
int var_3 = const_values[2];

//DO STUFF BLOCK
}

//Function Declarations
void change_constants(char names[][10],int values, int array_size){
	//Take knob value as Index
	index = (knob(6)/1023)*const_number;
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Testing");
	LCD.setCursor(0,1); LCD.print(index);
	delay(200);
}

