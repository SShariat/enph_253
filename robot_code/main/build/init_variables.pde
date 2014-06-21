void init_variables(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Initialize constants?");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while (!(startbutton()));


};
