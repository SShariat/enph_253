void change_constants(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Change Constants");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while(!(startbutton()));
	
	while(!(stopbutton())){
	
	//Take knob value as Index
	//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
	
	//Print the Name and Associated Value of the Constant Name to the Screen
	int index =  ((knob(6) * (NUM_CONST-1) ) / 1000 )  ;
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Name: "); LCD.print(names[index]);
	LCD.setCursor(0,1); LCD.print("Value: ");LCD.print(values[index]);
	

	while(startbutton()){
		int new_value = knob(6);
		values[index] = new_value;		
		LCD.clear(); LCD.home();
		LCD.setCursor(0,0); LCD.print("Name: "); LCD.print(names[index]);
		LCD.setCursor(0,1); LCD.print("Value: ");LCD.print(values[index]);
		delay(200);
	}
		
	delay(200);
	}
}
