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
