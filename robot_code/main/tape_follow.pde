//Tape Following Function

//Number of Options
#define NUMCHOICES 3

//Available Options
#define DEMO 1
#define SENSOR 2


void tape_follow(){
	while(!stopbutton()){

		clear();
		LCD.setCursor(0,0); LCD.print("Tape-Follow: ");


		switch(menu_choice()){

			case DEMO:
			LCD.setCursor(0,1); LCD.print("Demo");
			if(startbutton()){
			//Applies PID Controller
				tape_follow_demo();
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