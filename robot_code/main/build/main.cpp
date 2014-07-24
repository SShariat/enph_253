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
int tape_thresh = 100; // The value at which the program will determine whether the sensors are looking at the ground.
int tape_speed = 450;     // The default speed at which the motors will run.

int state = 0;       // The state of the robot (straight, left, right, or hard left/right)
int lastState = 0;   // The previous state of the robot.
int thisState = 0;   // The state which the robot is currently running in (i.e. a plateau)
int lastTime = 0;    // The time the robot spent in the last state.
int thisTime = 0;    // The time the robot has spent in this state.
int i = 0;           // i for iterations, because I'm old-school like that.

int pro = 0;         // Taking a leaf out of Andre's book, this stands for the proportional function.
int der = 0;         // As one might expect, this is the derivative function (no integrals on my watch!)
int result = 0;      // The result, or sum of the two above functions.

int artifacts = 0;
int height = 16; // angle above ground


/*
//////////////////////////////////////////////// I dunno what all this stuff is, I'll leave it alone.
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

	// initializing the vertical arm's position. It contains the same variable I created for the collection code itself.
	RCServo1.write(height); 

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
	// tape_follow(); 

	int speed = analogRead(6);

	motor.speed(3, speed);
	motor.speed(2, speed);  

	artifact_collect();
}
// The artifact collection code. This detects an artifact impact, picks it up, swings the arm over the bucket, drops it off, then returns to its default state.

// Now, the expected setup will be that the robotic arm has some way of detecting the increase in weight an artifact will add to the arm. This then will prompt it to lift the object, rotate the base, rotate the servo on the end of the arm, then return all servos to their default position. Pretty simple code, actually.

// The current method of detecting an artifact is a QRD attached to the side of the artifact dropper. This has the advantage of being both lighter and more reliable than a physical switch. We use the QRD's crappy range for our own advantage! :D

// Anyhoo, the sensor usually reports values ranging from ~120 to 200-something, then drops to about 40ish when an artifact is collected. As such, I've made the threshold 100. We may want to reduce this at some point in the future, and feel free to make it a variable if you'd like, but it's not crucial for time trials.

void artifact_collect(){

	// This variable ensures that once we detect something, we are committed to the pickup sequence.
	bool servo = false;

	// This code here simply is for debug purposes; it prints out the current value of the QRD so that we know what it's seeing.
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print( analogRead(2) );
	delay(50);


	// Artifact detection 'if' statement.
	if(analogRead(2) < 80) { 
	                          
		LCD.setCursor(0,1); LCD.print("Object Detected!");
		delay(50);

		
		servo = true; 

	} else {

		// Just a 'scanning' text block to display on the screen when we don't see anything. It's cool.
		LCD.setCursor(0,1); LCD.print("Scanning..."); 
		delay(50);		
	}



	// The following is the series of commands for the arm to pick up an idol, drop it in the bucket, then return to its starting position.

	if(servo == true){

		motor.stop_all();

		// Vertical arm, this executes first, raising up to an approximate 50 degree angle.
		// This will traverse slowly, so that the idol doesn't get knocked off.
		for(int pos = height; pos < 100; pos += 1) {

			RCServo1.write(pos);
			delay(15);

		} 


		// Horizontal arm, brings the idol into position over the bucket.
		// Again, it travels slowly.
		for(int pos = 0; pos < 150; pos += 1) {

			RCServo2.write(pos); 
			delay(10);

		} 


		// Now, we drop off the artifact.
		// Unlike the last two, this is executed quickly.
		RCServo0.write(180); delay(1000);

		// Then we return the end to its initial position.
		RCServo0.write(0); delay(500);

		// Next, the arm moves horizontally back to its starting position.
		// This is quick, since we don't have an artifact on the end.
		RCServo2.write(0); delay(500);

		// Finally, the arm is lowered to its proper height.
		// This is quickly done as well.
		RCServo1.write(height);  //return to normal height
		delay(500);

		// Now, we set the 'servo' function to false, and iterate the number of artifacts we've picked up. This number will help us keep track of where we are on the course.
		servo = false;
		artifacts++;
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




		if(l > tape_thresh && r > tape_thresh) { // Both QRDs are on the tape
			state = 0;
		} else if(l < tape_thresh && r > tape_thresh) { // The left QRD has moved off the tape.
			state = -1;
		} else if(l > tape_thresh && r < tape_thresh) { // The right QRD is now off the tape.
			state = 1;
		} else if(l < tape_thresh && r < tape_thresh && state < 0) { // Both QRDs are off the tape, and the robot is tilted to the left.
			state = -5;
		} else if(l < tape_thresh && r < tape_thresh && state > 0) { // Both QRDs are off, the robot is tilted to the right.
			state = 5;
		} else if(l < tape_thresh && r < tape_thresh && state == 0) { // Both QRDs are now off the tape, but the code 
			state = 0;
		}


		// To be honest, I'm not 100% sure of what this does. Something important, I'm sure.
		if(state != thisState) {
			lastState = thisState;
			lastTime = thisTime;
			thisTime = 1;
		}

		// This is our P/D part; defining our (pro)portional and (der)ivative control
		pro = K_p * state;
		der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));

		// They're then added together with the robot's speed to produce our output.
		result = pro + der;

		// This 700 is only here because that was the maximum speed Charles could go without damage. I've removed it for now.
		// if(result > 700 - tape_speed){
		// 	result = 700;
		// }

		// This writes our output to the motors
		motor.speed(3, (1) * (tape_speed - result) );
		motor.speed(2, tape_speed + result);  


		// Simply a diagnostic function; prints out what each sensor is seeing, as well as the current K-values, every 50 iterations.
		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}

		i++;
		thisTime++;
		thisState = state;

};

