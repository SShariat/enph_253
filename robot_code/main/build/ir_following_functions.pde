// ---------------------------------------------------------------------------------------------------------- \\
// IR following functions

//Root Tree
void ir_follow_tree(){
	
	//Number of Options
	#define OPTIONS 3
	//TAPE CHILDREN
	#define IR_FOLLOW_VARS 1
	#define IR_FOLLOW_DEMO 2
	#define IR_FOLLOW_SENSOR 3

	while(!deselect()){

		clear();
		print_root("IR-Follow");

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
				while(!deselect()){
					follow_ir(0);
				}
				motor.stop_all();
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

//IR Following Variable Editor
void ir_follow_vars(){
	
	#define NUM_OF_CONSTANTS 3

	#define KP 1
	#define KD 2
	#define SPEED 3

	while(!deselect()){
	
		clear();
		print_root("Var: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case KP:
		//Changing Variable 1
			edit_variable(5, "K_p",1000);
		break;

		case KD:
		//Changing Variable 2
			edit_variable(6, "K_d",1000);
		break;
		
		case SPEED:
		//Changing Variable 3
			edit_variable(7, "Speed",1000);
		break;
		}
		delay(200);
	}
}

//IR Following Demonstration
void ir_follow_demo(){
	int left_low, left_high;
	int right_low, right_high;

	int left, right;

	int pro, der, result;

	int current_error; 
	int last_error = 0;

	int i = 0; 

	int K_p 		= EEPROM.read(5)*4;
	int K_d 		= EEPROM.read(6)*4;
	int tape_speed 	= EEPROM.read(7)*4;

	while(!deselect()){

		left_high 	= analogRead(0);
		left_low 	= analogRead(1);
		right_high 	= analogRead(2);
		right_low 	= analogRead(3);

		//Gain Switching
		/*If Low Gain is Railing
			Switch to High Gain*/
		if((left_high+right_high)>2000){
			left = left_low;
			right = right_low;
		}
		else{
			left = left_high;
			right = right_high;
		}

		current_error = left - right;

		if (current_error > 200 ){
			current_error = 200;
		}

		if (current_error < -200 ){
			current_error = -200;
		}

		pro = K_p*current_error;
		der = (current_error - last_error)*K_d;

		result = pro + der;

		motor.speed(3, tape_speed + result );
		motor.speed(2, tape_speed - result);

		last_error = current_error;

		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(left); LCD.print(" R: "); LCD.print(right);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);

			i = 0;
		}
		i++;
	}
	motor.stop_all();
}

//IR Following Without Motors Running
void ir_follow_sensor(){
	
	// IR Detection Variables
	int left_high;
	int left_low;
	int right_high;
	int right_low;
	
	while(!deselect()){
		left_high= (float)(analogRead(0));
		left_low = (float)(analogRead(1));
		right_high = (float)(analogRead(2));
		right_low = (float)(analogRead(3));
		
		clear();
		LCD.setCursor(0,0);LCD.print("L "); LCD.print("LO:"); LCD.print(left_low); LCD.print("HI:"); LCD.print(left_high);
		LCD.setCursor(0,1);LCD.print("R "); LCD.print("LO:"); LCD.print(right_low); LCD.print("HI:"); LCD.print(right_high);
		
		delay(200);
	}
}

void follow_ir(bool reset){
	//Initializing Variables
		static int left_low, left_high;
		static int right_low, right_high;

		static int left, right;

		static int pro, der, result;

		static int current_error; 
		static int last_error = 0;

		static int i = 0; 

		int ir_K_p 		= EEPROM.read(5)*4;
		int ir_K_d 		= EEPROM.read(6)*4;
		int ir_speed 	= EEPROM.read(7)*4;
	if(reset){
		//Reset Variables
			last_error = 0;
			i = 0;
	}
	else{	
		//IR Following
		left_high 	= analogRead(0);
		left_low 	= analogRead(1);
		right_high 	= analogRead(2);
		right_low 	= analogRead(3);

		//Gain Switching
		/*If Low Gain is Railing
			Switch to High Gain*/
		if((left_high+right_high)>2000){
			left = left_low;
			right = right_low;
		}
		else{
			left = left_high;
			right = right_high;
		}

		current_error = left - right;

		if (current_error > 200 ){
			current_error = 200;
		}

		if (current_error < -200 ){
			current_error = -200;
		}

		pro = ir_K_p*current_error;
		der = (current_error - last_error)*ir_K_d;

		result = pro + der;

		motor.speed(3, ir_speed + result );
		motor.speed(2, ir_speed - result);

		last_error = current_error;

		if( i == 50) {
			LCD.clear();
			LCD.home(); 

			LCD.print("L: "); LCD.print(left); LCD.print(" R: "); LCD.print(right);
			LCD.setCursor(0,1);
			LCD.print("Kp:"); LCD.print(ir_K_p); LCD.print(" Kd:"); LCD.print(ir_K_d);

			i = 0;
		}
		i++;
	}
}

//NOT DONE
//Checks if the Sensors are seeing IR light
bool ir_detected(){
	int left_high = analogRead(0);
	int right_high = analogRead(2);

	if((left_high+right_high)>200){
		return true;
	}
	else
		return false;
}

//NOT DONE
//Checks if the IR Values are higher than a Certain Value
bool ir_thresh(){

}

