//Libraries
#include <HardwareSerial.h>
#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>
#include <EEPROM.h>

//ROOT TREE

#define ROOT 5

//ROOT CHILDREN
#define TAPE_FOLLOW 1          // Follows tape utilizing PD control.
#define IR_FOLLOW 2            // Follows an IR beacon.
#define ARTIFACT_COLLECTION 3  // Collects artifacts using the robot arm.
#define MOTOR 4                // H-Bridge Test Program that Simultaneously Runs 2 Motors at the same time.
#define RUN_ALL 5              // Runs everything above at once.


//Editor Variables for Parameter Manipulation
int current, new_value = 0;

//Motor Test Variables (These are the speeds of 2 Motors)
int speed_1, speed_2;


// Initializing tape following parameters
int state     = 0;  // The state of the robot (straight, left, right, or hard left/right)
int lastState = 0;  // The previous state of the robot.
int thisState = 0;  // The state which the robot is currently running in (i.e. a plateau)
int lastTime  = 0;  // The time the robot spent in the last state.
int thisTime  = 0;  // The time the robot has spent in this state.
int i 		  = 0;  // i for iterations, because I'm old-school like that.

int pro       = 0;  // Taking a leaf out of Andre's book, this stands for the proportional function.
int der       = 0;  // As one might expect, this is the derivative function (no integrals on my watch!)
int result    = 0;  // The result of our pro and der, this goes to the motors.    

// TINAH-editable tape following variables
int K_p;            // Proportional constant
int K_d;            // Derivative constant
int tape_speed;     // The default speed at which the motors will run.
int tape_thresh;	//// The value at which the program will determine whether the sensors are looking at the ground. 100-300 seem like decent values. Note, we may want to make this a TINAH-editable value for competition day, as the surface may be different than in tests.


  //---------\\
 // Functions \\
//------------ \\


// IR Detection Variables
int left_high;
int left_low;
int right_high;
int right_low;

void setup(){

	// Initializes the motor inputs.
	portMode(0, INPUT);
	portMode(1, INPUT);

	// TODO initialize servomotors.

	// Setting up the variables that will be edited
	K_p = EEPROM.read(1)*4;
	K_d = EEPROM.read(2)*4;
	tape_speed =  EEPROM.read(3)*4;
	tape_thresh = EEPROM.read(4)*4;
}

// ROOT LOOP
void loop(){

	clear();
	//Print Selection Statement and Clears the Screen
	print_root("Select: ");

	switch(menu_choice(ROOT)){

		case TAPE_FOLLOW:
		print_child("Tape-Follow");
		//This Implements the Different Tape Following Options
		if(confirm()){
			tape_follow();
		}
		break;

		case IR_FOLLOW:
		print_child("IR-Follow");
		if(confirm()){
			ir_follow();
		}
		break;

		case ARTIFACT_COLLECTION:
		print_child("Art. Collect");
		if(confirm()){
			incomplete();
		}
		break;

		case MOTOR:
		print_child("Motor");
		if(confirm()){
			motor_test();
		}
		break;

		case RUN_ALL:
		print_child("Run-All");
		if(confirm()){
			incomplete();
		}
		break;

	}
	delay(200);
}

//TAPE Follow Tree Loop
void tape_follow(){
	//TAPE FOLLOW TREE
	#define OPTIONS 3
	//TAPE CHILDREN
	#define TAPE_VARS 1
	#define TAPE_DEMO 2
	#define TAPE_SENSOR 3

	while(!deselect()){

		clear();
		print_root("Tape-Follow");

		switch(menu_choice(OPTIONS)){

			case TAPE_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				tape_follow_vars();
			}
			break;

			case TAPE_DEMO:
			print_child("Run Demo");
			if(confirm()){
				tape_follow_demo();
			}
			break;

			case TAPE_SENSOR:
			print_child("Check Sensors");
			if(confirm()){
				tape_follow_sensor();
			}
			break;
		}
		delay(200);
	}
}

//TAPE FOLLOWING MODULES

// Tape Following Variable Editor
// 1. Select Variable
// 2. Press start to go into edit mode
// 3. Select Value using knob 7 and press stop to save that value
void tape_follow_vars(){

	#define NUM_OF_CONSTANTS 4

	#define KP 1
	#define KD 2
	#define SPEED 3
	#define THRESH 4

	while(!deselect()){
	
	
		clear();
		print_root("Variable: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			current = K_p;
			LCD.print("K_p");
			display_var(K_p);
			if(confirm()){
				while(!deselect()){
					new_value = knob(7);
					display_new_var("K_p");
					if(confirm()){
						current = new_value;
						K_p = new_value;
						EEPROM.write(1,new_value/4);
					}
					delay(200);
				}
			}
		break;

		case KD:
		//Changing Variable 2
			current = K_d;
			LCD.print("K_d");
			display_var(K_d);
			if(confirm()){
				while(!deselect()){
					new_value = knob(7);
					display_new_var("K_d");
					if(confirm()){
						current = new_value;
						K_d = new_value;
						EEPROM.write(2,new_value/4); 
					}
					delay(200);	
				}
			}
		break;
		
		case SPEED:
		//Changing Variable 3
			current = tape_speed;
			LCD.print("Speed");
			display_var(tape_speed);
			if(confirm()){
				while(!deselect()){
					new_value = knob(7);
					display_new_var("Speed");
					if(confirm()){
						current = new_value;
						tape_speed = new_value;
						EEPROM.write(3,new_value/4); 
					}
					delay(200);
				}
			}
		break;

		case THRESH:
		//Changing Variable 4
			current = tape_thresh;
			LCD.print("Thresh");
			display_var(tape_thresh);
			if(confirm()){
				while(!deselect()){
					new_value = knob(7);
					display_new_var("Thresh");
					if(confirm()){
						current = new_value;
						tape_thresh = new_value;
						EEPROM.write(4,new_value/4); 
					}
					delay(200);
				}
			}
		break;


		}
		delay(200);
	}
}

//tape_follow_demo

   //-----------------------\\
  //---TAPE FOLLOWING CODE---\\
 //---------------------------\\

// *explosions* *electric guitar noises*

// Ladies and gentlemen, prepare your butts for a magnificent, fabulous, absolutely stunning piece of code. First written back in the Dark Ages of the robot course, designed for Charles the Robot, this code performed exceptionally well, following tape exactly all the way up the course. And now, without further ado, I present to you the:


// PD Tape Following Program
//Parameters:
//	-threshold
//	-kp
//	-kd
// 	-motorspeed
void tape_follow_demo(){ // 'Demo' doesn't really make sense in this context; just 'tape_follow()' would work fine.
	
	while(!deselect()){

		//Reading QRD Sensors
		int l = analogRead(0); // Left QRD
		int r = analogRead(1); // Right QRD (but you knew that already, you're smart)

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
	}
	motor.stop_all();
}

//Runs QRD Sensor Module
void tape_follow_sensor(){
	while(!deselect()){
		//Read From QRD Sensors
		int l = analogRead(0);
		int r = analogRead(1);

		//Print To Screen QRD Sensors
		clear();
		LCD.setCursor(0,0); LCD.print("L:"); LCD.print(l);
		LCD.setCursor(0,1); LCD.print("R:"); LCD.print(r);
		delay(200);
	}
}

//Motor Functions
void motor_test(){
	while(!deselect()){
		speed_1 = 2*(analogRead(6) - 511);
		speed_2 = 2*(analogRead(7) - 511);

		if (speed_1 >1023) {
			speed_1 = 1023;
		} else if ( speed_1 < -1023) {
			speed_1 = -1023;
		}

		if (speed_2 >1023) {
			speed_2 = 1023;
		} else if ( speed_2 < -1023) {
			speed_2 = -1023;
		}

		motor.speed(3,speed_1);
		motor.speed(2,speed_2);

		clear();
		LCD.setCursor(0,0); LCD.print("M1: "); LCD.print(speed_1);
		LCD.setCursor(0,1); LCD.print("M2: "); LCD.print(speed_2);

		delay(50);
	}
	//Added Motor Stop Function
	motor.stop_all();
}


//IR Functions

//IR Tree
void ir_follow(){
	#define OPTIONS 3
	//TAPE CHILDREN
	#define IR_FOLLOW_VARS 1
	#define IR_FOLLOW_DEMO 2
	#define IR_FOLLOW_SENSOR 3

	while(!deselect()){

		clear();
		print_root("Tape-Follow");

		switch(menu_choice(OPTIONS)){

			case IR_FOLLOW_VARS:
			print_child("Edit Vars.");
			if(confirm()){
				ir_follow_vars();
			}
			break;

			case IR_FOLLOW_DEMO:
			print_child("Run Demo");
			if(confirm()){
				ir_follow_demo();
			}
			break;

			case IR_FOLLOW_SENSOR:
			print_child("Check Sensors");
			if(confirm()){
				ir_follow_sensor();
			}
			break;
		}
		delay(200);
	}
}

void ir_follow_vars(){
	while(!deselect()){

	}
}

void ir_follow_demo(){
	while(!deselect()){

	}
}

void ir_follow_sensor(){
	while(!deselect()){
		left_high= analogRead(0)*5/1024;
		left_low = analogRead(1)*5/1024;
		right_high = analogRead(2)*5/1024;
		right_low = analogRead(3)*5/1024;
		
		clear();
		LCD.setCursor(0,0);LCD.print("L "); LCD.print("LO:"); LCD.print(left_low); LCD.print("HI:"); LCD.print(left_high);
		LCD.setCursor(0,1);LCD.print("R "); LCD.print("LO:"); LCD.print(right_low); LCD.print("HI:"); LCD.print(right_high);
		delay(200);
	}
}

//////////////////////////
//	 Helper FUNCTIONS 	//
//////////////////////////

//Knob 6 Value is converted to menu selection.
int menu_choice(int num_choices){
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	int choice = (1.1*(knob(7) * (num_choices - 1)) / 1024) + 1;
	if(choice>num_choices){
		choice = num_choices;
	}
	return choice;
}

//Clears the LCD Screen on TINAH
void clear(){
	LCD.clear(); 
	LCD.home();
}

//Confirm Selection with a Delay
bool confirm(){
	if(startbutton()){
		delay(300);
		return true;
	}
	else{
		return false;
	}
}

//Deselect Selection with a Delay
bool deselect(){
	if(stopbutton()){
		delay(300);
		return true;
	}
	else{
		return false;
	}
}

//Where ever this function is, it displays the IN PROGRESS Text on TINAH
void incomplete(){
	while(!deselect()){
				clear();
				LCD.setCursor(0,0); LCD.print("In Progress");
				delay(200);
	}
}

//Prints the Value of a Variable when scrolling through list of Possibilities
void display_var(int var){
	LCD.setCursor(0,1); LCD.print("Value: "); LCD.print(var);
}

//Displays editing mode
void display_new_var(char name[]){
	clear();
	LCD.setCursor(0,0); LCD.print(name);
	LCD.setCursor(0,1); LCD.print("C:"); LCD.print(current); LCD.print(" N:"); LCD.print(new_value);
}

void print_root(char name[]){
	
	LCD.setCursor(0,0); LCD.print(name);
}

void print_child(char name[]){

	LCD.setCursor(0,1); LCD.print(name);
}


void edit_variable(){}