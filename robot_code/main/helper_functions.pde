// ---------------------------------------------------------------------------------------------------------- \\
// Helper Functions

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

//Prints the root name of the tree
void print_root(char name[]){
	
	LCD.setCursor(0,0); LCD.print(name);
}

//Prints the child name of the tree
void print_child(char name[]){

	LCD.setCursor(0,1); LCD.print(name);
}

//Edits a variable and saves it to 
void edit_variable(int addr, char name[],int max_range){
	current = EEPROM.read(addr)*4;
	LCD.print(name);
	display_var(EEPROM.read(addr)*4);
	if(confirm()){
		while(!deselect()){
			//Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
			new_value = (int)(((float)knob(7)/1000.0)*max_range);

			if(new_value > max_range){
				new_value = max_range;
			}

			//new_value = knob(7);
			display_new_var(name);
			if(confirm()){
				EEPROM.write(addr,new_value/4);
				current = new_value;
			}
			delay(200);
		}
	}
}

//This is the Initializer Function that resets the value of all the editable variables to hard coded values
void initialize_vars(){
	/*
	TAPE FOLLOWING
	K_p 		1
	K_d 		2
	tape_speed 	3
	tape_thresh 4

	IR FOLLOWING
	K_p			5
	K_d			6
	ir_speed 	7

	ARTIFACT COLLECTION
	height		8

	RUN ALL
	*/

	EEPROM.write(1,(int)(250/4.0));
	EEPROM.write(2,(int)(25/4.0));
	EEPROM.write(3,(int)(300/4.0));
	EEPROM.write(4,(int)(100/4.0));
	
	EEPROM.write(5,(int)(250/4.0));
	EEPROM.write(6,(int)(25/4.0));
	EEPROM.write(7,(int)(400/4.0));
	
	EEPROM.write(8,(int)(16/4.0));
}