//Tape Following Function

//Number of Options
#define NUMCHOICES 3

//Available Options
#define DEMO 1
#define VARS 2
#define SENSOR 3


void tape_follow(){
	

	while(!stopbutton()){
		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow: ");


		switch(menu_choice()){

			case DEMO:
		//if stop button is not pressed
			LCD.setCursor(0,1); LCD.print("Demo");
			break;

			case VARS:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,1); LCD.print("Variables");
			break;

			case SENSOR:
			// if back button is not pressed
			//TODO tape_follow();
			LCD.setCursor(0,1); LCD.print("Sensor");
			break;
		}
		delay(200);
	}
}
