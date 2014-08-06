Addresses in memory

	1 K_P for tape following 
	2 K_D for tape following
	3 Speed for tape following
	4 Threshold for tape following
	5 K_P for IR following	
	6 K_D for IR following
	7 Speed for IR following
	8 Starting height of crane arm
	9 Final height of crane arm
	10 Starting angle of crane arm
	11 Final angle of crane arm 
	12 Threshold for artifact detection QRD
	13 Forward speed for brake test
	14 Reverse speed for brake test
	15 Delay for brake test



Analog Pins Being Used
	
	IR Pins
	0 Left-High
	1 Left-Low
	2 Right-High
	3 Right Low

	4 Left QRD
	5 Right QRD
	
	6  Detector QRD



ROOT TREE
1. Tape Follow
	a. Variables
	b. Demo
	c. Sensor Check

2. IR Follow
	a. Variables
	b. Demo
	c. Sensor Check

3. Artifact Collection
	a. Variables(IC)
	b. Demo

4. MOTOR
	a. Motor Test

5. Run All
	a.

6. Time Trial Demo



//Tree Template
void tree_example(){
	
	//NUM OF CHILD
	#define OPTIONS 4
	
	//TAPE CHILDREN
	#define CHILD_1 1
	#define CHILD_2 2
	#define CHILD_3 3
	#define CHILD_4 4

	while(!deselect()){

		clear();
		print_root("ROOT_NAME");

		switch(menu_choice(OPTIONS)){

			case CHILD_1:
			print_child("CHILD_1_NAME");
			if(confirm()){
				function_1();
			}
			break;

			case CHILD_2:
			print_child("CHILD_2_NAME");
			if(confirm()){
				function_2();
			}
			break;

			case CHILD_3:
			print_child("CHILD_3_NAME");
			if(confirm()){
				function_3();
			}
			break;

			case CHILD_4:
			print_child("CHILD_4_NAME");
			if(confirm()){
				function_3();
			}
			break;
		}
		delay(200);
	}
}

//Editting Variables Template
//NOTE: When wanting to add new variables, they MUST be given Unique Addresses. The list of Already Used Addresses can be found at the top of the main.pde.
void example_vars(){
	
	//Number of Variables
	#define NUM_OF_CONSTANTS 4

	#define VAR_1 1
	#define VAR_2 2
	#define VAR_3 3
	#define VAR_4 4

	//edit_variable() is incorrect, need a third parameter.
	while(!deselect()){
	
		clear();
		print_root("Var: ");

		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case VAR_1:
		//Changing Variable 1
			edit_variable(addr_1, "VAR_1_NAME");
		break;

		case VAR_2:
		//Changing Variable 2
			edit_variable(addr_2, "VAR_2_NAME");
		break;
		
		case VAR_3:
		//Changing Variable 3
			edit_variable(addr_3, "VAR_3_NAME");
		break;

		case VAR_4:
		//Changing Variable 4
			edit_variable(addr_4, "VAR_4_NAME");
		break;


		}
		delay(200);
	}	
}

//Variable Initialization
Whenever a block of code wants to use variables stored within the TINAH, an initialization block must be added to the beginning of the code:

int var_1 = EEPROM.read(addr_1)*4;
int var_2 = EEPROM.read(addr_1)*4;
int var_3 = EEPROM.read(addr_2)*4;
int var_4 = EEPROM.read(addr_3)*4;

Please Note: The Factor of *4 is important as the maximum value that can be stored to TINAH iss 256 due to 8-bit limitations.

For now, possible values that can be stored range from 0-1024. Please do not change the factor of 4 as the edit_variable() method takes this into account from a hard coding perspective.