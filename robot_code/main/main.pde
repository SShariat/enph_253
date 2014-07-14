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
int  const_values [NUM_CONST] = {1,2,3,0,12};
char const_names  [NUM_CONST][STR_SIZE] =  {"foo", "bar", "bletch", "foofoo", "lol"};

void setup()
{
 
}

void loop()
{
	change_constants(const_values,const_names, NUM_CONST);

	
	init_variables(const_values,const_names, NUM_CONST);
	
	
	go_forward();
	
	
	
}