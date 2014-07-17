#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

// How long our variable names must be. Keep them short!
#define STR_SIZE 10

// The number of variables we can define. Needs to be updated should any new ones be added.
#define NUM_CONST 5


// This is the PD control variables' initialization section. These don't change (except for speed and threshold, I'll deal with them later).
int threshold = 200; // The value at which the program will determine whether the sensors are looking at the ground.
int speed = 450;     // The default speed at which the motors will run.

int state = 0;       // The state of the robot (straight, left, right, or hard left/right)
int lastState = 0;   // The previous state of the robot.
int thisState = 0;   // The state which the robot is currently running in (i.e. a plateau)
int lastTime = 0;    // The time the robot spent in the last state.
int thisTime = 0;    // The time the robot has spent in this state.
int i = 0;           // i for iterations, because I'm old-school like that.

int pro = 0;         // Taking a leaf out of Andre's book, this stands for the proportional function.
int der = 0;         // As one might expect, this is the derivative function (no integrals on my watch!)
int result = 0;      // The result, or sum of the two above functions.


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
char const_names  [NUM_CONST][STR_SIZE] =  {"threshold", "speed", "const3", "const4", "const5"}; // I've added actual constants, as well as making the others seem a little more...professional.

void setup()
{
	// Servomotor initialization.
	RCServo0.attach(RCServo0Output);
	RCServo1.attach(RCServo1Output);
	RCServo2.attach(RCServo2Output);

	RCServo1.write(160);

	while(!(startbutton())){
		LCD.clear();
		LCD.home();
		LCD.setCursor(0,0); LCD.print("Howdy!");
		LCD.setCursor(0,1); LCD.print("Press Start!");
		delay(50);
	}

	LCD.clear();
}

void loop()
{
	// These dudes are commented out for now; I'm just worried about getting the servos to work.

	// change_constants(const_values,const_names, NUM_CONST);

	// init_variables(const_values,const_names, NUM_CONST);
	
	// Code controlling the moving forward of the robot. May want to simply integrate the PD control into this function and call it something else
	//tape_follow; 

	// Artifact detection and collection code.
	

	// Temporary 'go forward' code, does not follow tape at all.
	motor.speed(3, speed);
	motor.speed(2, speed);

	speed = knob(6);

	LCD.setCursor(0,0); LCD.print("Rolling at"); 
	LCD.setCursor(11,0); LCD.print(speed);
	delay(50);

	artifact_collect();

	LCD.clear();
	LCD.home();
}