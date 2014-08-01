// ---------------------------------------------------------------------------------------------------------- \\
// Run-All Functions

//Run All Tree
void run_all(){
	
	//TAPE FOLLOW TREE
	#define OPTIONS 1
	//TAPE CHILDREN
	#define FOLLOW_COLLECT 1

	while(!deselect()){

		clear();
		print_root("Run-All");

		switch(menu_choice(OPTIONS)){

			case FOLLOW_COLLECT:
			print_child("State Switcher");
			if(confirm()){
				state_switch();
			}
			break;
		}
		delay(200);
	}
}

// This is combination tape follow and artifact collection system.
void state_switch(){
	//This is the State Picking Code for the Robot
	/*
		switch(STATE)
			case TAPE_FOLLOW:

			break;

			case ARTIFACT_COLLECT:
			
			break;

			case STATE_3:
			break;

			case STATE_4:
			break;

	*/

	while(!deselect()){
	}
}
