//Tape Following Function

//Number of Options
#define NUMCHOICES 3

//Available Options
#define VARS 1
#define DEMO 2
#define SENSOR 3


void tape_follow(){
	while(!stopbutton()){

		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow: ");


		switch(menu_choice()){

			case VARS:
			LCD.setCursor(0,1); LCD.print("Variables");
			if(startbutton()){
			//Insert Variable Changing Method
		}
			break;

			case DEMO:
			LCD.setCursor(0,1); LCD.print("Demo");
			if(startbutton()){
			//Insert Demo Function
		}
			break;

			case SENSOR:
			LCD.setCursor(0,1); LCD.print("Sensor");
			if(startbutton()){
			//Insert Sensor Function
		}
			break;
		}
		delay(200);
	}
}