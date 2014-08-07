// ---------------------------------------------------------------------------------------------------------- \\
// Run-All Functions

//Run All Tree
void run_all_tree(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 4
	//TAPE CHILDREN
	#define FULL_RUN 1
	#define VARS_EDIT 2
	#define CHECK_SENSOR 3
	#define COLLECT_ONE	4

	while(!deselect()){

		clear();
		print_root("Run-All");

		switch(menu_choice(OPTIONS)){

			case FULL_RUN:
			print_child("Full Run");
			if(confirm()){
				full_run();
			}
			break;

			case VARS_EDIT:
			print_child("Edit Vars.");
			if(confirm()){
				run_all_vars();
			}
			break;

			case CHECK_SENSOR:
			print_child("Check sensors");
			if(confirm()){
				run_all_sensors();
			}

			case COLLECT_ONE:
			print_child("Get One");
			if(confirm()){
				collect_one();
			}
		}
		delay(200);
	}
}

void run_all_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 9

	#define KP 1
	#define KD 2
	#define SPEED 3
	#define THRESH_TAPE 4
	#define START_HEIGHT 5
	#define RAISE_HEIGHT 6
	#define START_ANGLE 7
	#define END_ANGLE 8
	#define THRESH_ART 9

	while(!deselect()){
	
		clear();
		print_root("Var: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			edit_variable(1, "K_p",1000);
		break;

		case KD:
		//Changing Variable 2
			edit_variable(2, "K_d",1000);
		break;
		
		case SPEED:
		//Changing Variable 3
			edit_variable(3, "Speed",1000);
		break;

		case THRESH_TAPE:
		//Changing Variable 4
			edit_variable(4, "Tape thresh",1000);
		break;

		case START_HEIGHT:
		//Changing Variable 1
			edit_variable(8, "Start H",180);
		break;

		case RAISE_HEIGHT:
		//Changing Variable 1
			edit_variable(9,"Raise H",180);
		break;

		case START_ANGLE:
		//Changing Variable 1
			edit_variable(10,"Start A",180);
		break;

		case END_ANGLE:
		//Changing Variable 1
			edit_variable(11,"End A",180);
		break;

		case THRESH_ART:
			edit_variable(12,"Art. thresh",1000);
		break;

		}
		delay(200);
	}	
}

void full_run(){

	//Different Robot States
	#define FOLLOW_TAPE 	1
	#define COLLECT_ART 	2
	#define FOLLOW_IR 		3
	#define COLLECT_IDOL	4
	#define ROTATE_ROBOT 	5
	#define TURN_LEFT		6

	//Initializing Starting State
	int robot_state = FOLLOW_TAPE;
	clear();
	
	while(!deselect()){

		switch(robot_state){
			case FOLLOW_TAPE:
				if(artifact_detected(150)){
					full_stop();
					robot_state = COLLECT_ART;
				}
				else if(ir_detected(50)){
					robot_state = FOLLOW_IR;
				}
				else{
					follow_tape(false);
				}
			break;

			case COLLECT_ART:
				collect_artifact();
				robot_state = FOLLOW_TAPE; 
			break;

			case FOLLOW_IR:
				if(artifact_detected(150)){
					full_stop();
					robot_state = COLLECT_IDOL;
				}
				else if(white_detected()){
					robot_state = TURN_LEFT;
				}
				else{
					follow_ir(false);
				}
			break;

			case COLLECT_IDOL:
				collect_idol();
				robot_state = ROTATE_ROBOT;
			break;

			case ROTATE_ROBOT:
				if(ir_detected(50)){
					follow_ir(true);
					robot_state = FOLLOW_IR;
				}
				else{
					rotate_bot(250);
				}
			break;

			case TURN_LEFT:
				if(tape_detected(100)){
					full_stop();
					robot_state = FOLLOW_TAPE;
				}
				else
					turn_left();
			break;
		}
	}
	motor.stop_all();
}

//Runs all sensor checks, using the sensor checks from the "home" functions
//could use some way to differentiate the sensors, rather than just L and R
void run_all_sensors(){

	#define NUM_OF_OPTIONS 4
	//SENSOR CHLDREN
	#define QRD_SENSOR 1
	#define LR_QRD_SENSORS 2
	#define IR_SENSORS_LOW 3
	#define IR_SENSORS_HIGH 4

	while(!deselect()){
			int artifact_thresh = EEPROM.read(12)*4;
			int tape_thresh = EEPROM.read(4)*4;


		clear();
		//print_root("Select sensor:");
		
		switch(menu_choice(NUM_OF_OPTIONS)){

			case QRD_SENSOR:
				int artifact_eye;
				artifact_eye = analogRead(6);
			
				print_root("Idol sensed?");
				if(artifact_eye < artifact_thresh){
					LCD.print(" Yes");
				}
				else{
					LCD.print(" No");
				}
				LCD.setCursor(0,1); LCD.print("Sensor: "); LCD.print(artifact_eye);

			break;

			case LR_QRD_SENSORS:
				int l;
				int r;
				l = analogRead(4);
				r = analogRead(5);

				print_root("Tape sensed?");
				if(l > tape_thresh && r > tape_thresh){
					LCD.print(" Yes");
				}
				else{
					LCD.print(" No");
				}
				LCD.setCursor(0,1); LCD.print("L:"); LCD.print(l); LCD.print("  R:"); LCD.print(r);
			break;

			case IR_SENSORS_LOW:
				int left_low;
				int right_low;
				left_low = (float)(analogRead(1));
				right_low = (float)(analogRead(3));
				
				print_root("IR sensors low");	
				LCD.setCursor(0,1);LCD.print("L:"); LCD.print(left_low); LCD.print("  R:"); LCD.print(right_low);
			break;

			case IR_SENSORS_HIGH:
				int left_high;
				int right_high;
				left_high = (float)(analogRead(0));
				right_high = (float)(analogRead(2));
				
				print_root("IR sensors high");	
				LCD.setCursor(0,1);LCD.print("L:"); LCD.print(left_high); LCD.print("  R:"); LCD.print(right_high);
			break;
		}
		delay(200);
	}
}

void collect_one(){

	//Different Robot States
	#define FOLLOW_TAPE 	1
	#define COLLECT_ART 	2
	#define ROTATE_ROBOT 	3
	
	int state = FOLLOW_TAPE;  
	
	while(!deselect()){
		switch (state){
			case FOLLOW_TAPE:
				if(artifact_detected(150)){
					full_stop();
					state = COLLECT_ART;
				}
				else
					follow_tape(0);
			break;

			case COLLECT_ART:
				collect_artifact();
				state = ROTATE_ROBOT;
				rotate_bot(250);
				delay(200);
			break;

			case ROTATE_ROBOT:
				if(tape_detected(100)){
					full_stop();
					follow_tape(1);
					state = FOLLOW_TAPE;
				}
			break;
		} 
	}
	motor.stop_all();
}