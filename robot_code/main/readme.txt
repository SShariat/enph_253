
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

#define NUM_OF_CHILDREN
#define child_1

void function(){

	while(!deselect()){
		clear();
		LCD.setCursor(0,0); LCD.print("First Text: ");


		switch(menu_choice(NUM_OF_CONSTANTS)){
		
		case child_1:
		LCD.setCursor(0,1);LCD.print("Option Name");

		if(confirm()){
			case_function()
		}
		break;
		
		}
	}
}

//TAPE FOLLOWING EDITTING STEPS
	// Tape Following Variable Editor
	// 1. Select Variable
	// 2. Press start to go into edit mode
	// 3. Select Value using knob 7 and press stop to save that value