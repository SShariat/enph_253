#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

// How long our variable names must be. Keep them short!
#define STR_SIZE 10

// The number of variables we can define. Needs to be updated should any new ones be added.
#define NUM_CONST 5


// This is the PD control variables' initialization section. These don't change (except for speed and threshold, I'll deal with them later).
#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void artifact_collect();
void init_variables(int values[], char names[][STR_SIZE], int array_size);
void tape_follow();
void three_tape_follow();
int threshold = 100; // The value at which the program will determine whether the sensors are looking at the ground.
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
// int  const_values [NUM_CONST] = {1,2,3,0,12};
// char const_names  [NUM_CONST][STR_SIZE] =  {"threshold", "speed", "const3", "const4", "const5"}; // I've added actual constants, as well as making the others seem a little more...professional.

void setup()
{
	// Servomotor initialization.
	RCServo0.attach(RCServo0Output);
	RCServo1.attach(RCServo1Output);
	RCServo2.attach(RCServo2Output);

	RCServo1.write(0); // initializing the vertical arm's position.

	while(!(startbutton())){
		LCD.clear();
		LCD.home();
		LCD.setCursor(0,0); LCD.print("Press Start.");
		LCD.setCursor(0,1); LCD.print("Don't press Stop");
		delay(50);
		if ( stopbutton() ) {
			while(!(startbutton())){
				LCD.setCursor(0,0); LCD.print("buttsbuttsbuttsbutts");
				LCD.setCursor(0,1); LCD.print("buttsbuttsbuttsbutts");
			}		
		}
	}

	LCD.clear();
}

void loop()
{
	// change_constants(const_values,const_names, NUM_CONST);

	
	// init_variables(const_values,const_names, NUM_CONST);
	
	// Code controlling the moving forward of the robot. May want to simply integrate the PD control into this function and call it something else
	// tape_follow(); 

	// Temporary 'go forward' code, does not follow tape at all.

	// speed = 2*(analogRead(6) - 511);

    // if (speed > 1023) {
    // 	speed = 1023;
    // } else if ( speed < -1023) {
    // 	speed = -1023;
    // }


	// motor.speed(3, speed);
	// motor.speed(2, -speed);

	// speed = knob(6);

	// LCD.clear(); LCD.home();

	// LCD.setCursor(0,0); LCD.print("Rolling at"); 
	// LCD.setCursor(11,0); LCD.print(speed);
	// delay(50);

	artifact_collect();
}
// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

void artifact_collect(){

	// This is very much a Work In Progress, the timings and the angles need to be adjusted. Fortunately, they shouldn't become part of the constants function, as we can simply measure the angles on the robot itself, and use dead reckoning for the times.

	bool servo = false;
	int height = 10; // The initial height of the arm; remember that this is an angle, and divide it by two to get the actual deflection.

	//while( !( stopbutton() ) ) {

		// double angle = 0;
		
		// angle = 180.0*analogRead(7)/1023;  //Dunno what all this is

		// RCServo2.write(angle);

	 //    LCD.clear();
	 //    LCD.home();
	 //    LCD.setCursor(0,0); LCD.print("Servomotor Cntrl");
	 //    LCD.setCursor(0,1); LCD.print(angle);
		// delay(50);
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print( analogRead(0) );
	delay(50);

		if(analogRead(0) < 100) {
			LCD.clear();
			LCD.setCursor(0,1); LCD.print("Object Detected!");
			delay(50);

			servo = true;

		} else {

			LCD.setCursor(0,1); LCD.print("Scanning...");
			delay(50);		
		}

		if(servo == true){

			// RCServo1.write(120); //Vertical arm up
			// delay(1000);

		  for(int pos = height; pos < 100; pos += 1)  // goes from 0 degrees to 180 degrees 
		  {                                  // in steps of 1 degree 
		    RCServo1.write(pos);              // tell servo to go to position in variable 'pos' 
		    delay(15);                       // waits 15ms for the servo to reach the position 
		  } 



			// RCServo2.write(180);
			// delay(1000);


		  // Horizontal arm

		  for(int pos = 0; pos < 180; pos += 1)  // goes from 0 degrees to 180 degrees 
		  {                                  // in steps of 1 degree 
		    RCServo2.write(pos);              // tell servo to go to position in variable 'pos' 
		    delay(10);                       // waits 15ms for the servo to reach the position 
		  } 


			RCServo0.write(180); //drop off the artifact
			delay(1000);

			RCServo0.write(0); // return artifact dropper to default
			delay(500);

			RCServo2.write(0);
			delay(500);

			// for(int pos = 180; pos>=1; pos-=1)     // goes from 180 degrees to 0 degrees 
			//   {                                
			//     RCServo2.write(pos);              // tell servo to go to position in variable 'pos' 
			//     delay(5);                       // waits 15ms for the servo to reach the position 
			//   }

			RCServo1.write(height);  //return to normal height
			delay(500);


			servo = false;
		}
	//}
}
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
// This is the tape following code. It is the same as Charles', with changed constants to make up for the different weight/turning radius.

void tape_follow(){

	int l = analogRead(0); // We're initializing the left and right analog sensors.
	int r = analogRead(1);

	int K_p = analogRead(6);
	int K_d = analogRead(7);

	// The following is Zach's lovely stop function.
	if( stopbutton() ) {
			delay(50); // Pause to make sure the stopbutton wasn't pressed by motor noise. (dunno how that could happen, but okay)

		if( stopbutton() ) {
			motor.speed(3, 0);
			motor.speed(2, 0); 

			while( !startbutton() ) {
				int K_p = analogRead(6);
				int K_d = analogRead(7);

				LCD.clear();
				LCD.home();
				LCD.print("PAUSED");    
				LCD.setCursor(0,1);
				LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

				delay(50);
			}  
		}
	}


	if(l > threshold && r > threshold) {
		state = 0;
	} else if(l < threshold && r > threshold) {
		state = -1;
	} else if(l > threshold && r < threshold) {
		state = 1;
	} else if(1 < threshold && r < threshold && state < 0) {
		state = -5;
	} else if(1 < threshold && r < threshold && state >= 0) {
		state = 5;
	}


	if(state != thisState) {
		lastState = thisState;
		lastTime = thisTime;
		thisTime = 1;
	}

	pro = K_p * state;
	der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

	result = speed + pro + der;

	if(result > 700 - speed){
		result = 700;
	}

	motor.speed(3, speed + result);
	motor.speed(2, speed + result);  

	if( i==50) {
		LCD.clear();
		LCD.home(); 

		LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
		LCD.setCursor(0,1);
		LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

		i = 0;
	}

	i++;
	thisTime++; // This time baby, I'll be, forevvvvvahhhhhhh

	thisState = state;

};
void three_tape_follow() {
	
	int l = analogRead(0); // We're initializing the left, centre, and right analog sensors.
	int c = analogRead(1);
	int r = analogRead(2);

	int K_p = analogRead(6);
	int K_d = analogRead(7);

	// The following is Zach's lovely stop function.
	if( stopbutton() ) {
			delay(50); // Pause to make sure the stopbutton wasn't pressed by motor noise.

		if( stopbutton() ) {
			motor.speed(3, 0);
			motor.speed(2, 0); 

			while( !startbutton() ) {
				int K_p = analogRead(6);
				int K_d = analogRead(7);

				LCD.clear();
				LCD.home();
				LCD.print("PAUSED");    
				LCD.setCursor(0,1);
				LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

				delay(50);
			}  
		}
	}


	if(l > threshold && r > threshold && c > threshold) { // This is when the robot is in the middle of the course.
		state = 0;
	} 
	else if(l < threshold && c > threshold && r > threshold) { // This is when the left sensor is off the tape.
		state = -1;
	}
	else if(l < threshold && c < threshold && r > threshold && state < 0) { // Both the left and centre sensors are off now.
		state = -3;
	} 
	else if(1 < threshold && r < threshold && state < 0) { // All three sensors are off, the robot is to the left of the tape.
		state = -5;
	}
	else if(l > threshold && c > threshold && r < threshold) { // The rightmost sensor is off the tape.
		state = 1;
	}
	else if(l > threshold && c < threshold && r < threshold && state >= 0) { // Both the right and centre sensors have strayed.
		state = 3;
	}
	else if(l < threshold && c < threshold && r < threshold && state >= 0) { // The robot is now wandering to the right of the tape.
		state = 5;
	}


	if(state != thisState) {
		lastState = thisState;
		lastTime = thisTime;
		thisTime = 1;
	}

	pro = K_p * state;
	der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

	result = speed + pro + der;

	if(result > 700 - speed){
		result = 700;
	}

	motor.speed(3, speed - result);
	motor.speed(2, speed + result);  

	if( i==50) {
		LCD.clear();
		LCD.home(); 

		LCD.print("L "); LCD.print(l); LCD.print(" C "); LCD.print(c); LCD.print(" R "); LCD.print(r);
		LCD.setCursor(0,1);
		LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

		i = 0;
	}

	i++;
	thisTime++; // This time baby, I'll be, forevvvvvahhhhhhh

	thisState = state;	

}

