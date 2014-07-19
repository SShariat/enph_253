
ROOT TREE
1. Tape Following
a. Variables
b. Demp
c. Sensor Check

2. IR Following
a. Variables
b. Demp
c. Sensor Check

3. Artifact Collection
a. Variables
b. Demp
c. Sensor Check

4. Run All

TEMPLATE FOR ADDING NEW FUNCTIONS


#define NUM_OF_CONSTANTS
#define case_1 1

void function(){

	while(!deselect()){
		clear();
		LCD.setCursor(0,0); LCD.print("First Text: ");


		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case case_1:
		LCD.setCursor(0,1);LCD.print("Option Name");

		if(confirm()){
			case_function()
		}
		break;
		
		}
	}
}