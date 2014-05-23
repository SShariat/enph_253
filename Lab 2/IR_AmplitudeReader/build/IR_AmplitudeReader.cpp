#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
int amplitudeValue = 0;

void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
  
  
  RCServo0.attach(RCServo0Output) ;    // attaching the digital inputs to the RC servo pins on the board.  
  RCServo1.attach(RCServo1Output) ;
  RCServo2.attach(RCServo2Output) ;

}

void loop()
{
	
	amplitudeValue = 5/(analogRead(1));
	
	LCD.clear(); LCD.home(); LCD.setCursor(0,0);
	
	LCD.print(amplitudeValue);
} 

