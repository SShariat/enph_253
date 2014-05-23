#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
float amplitudeValue = 0;

void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
    
  LCD.clear();
  LCD.home();
  LCD.setCursor(0,0); LCD.print("Hello World!");
  LCD.setCursor(0,1); LCD.print("Press Start");
  while ( !(startbutton()) ) ;

}

void loop()
{
	
	amplitudeValue = 5.0/( analogRead(1) );
	
	LCD.clear(); LCD.home(); LCD.setCursor(0,0);
	LCD.print('Voltage:');

	LCD.clear(); LCD.home(); LCD.setCursor(0,1);
	LCD.print(amplitudeValue);
        delay(20);
} 

