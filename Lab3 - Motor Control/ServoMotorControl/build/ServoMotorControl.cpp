#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
    
  RCServo2.attach(RCServo2Output);
}

void loop()
{
	double angle = 0;
	
	angle = 180.0*analogRead(6)/1023;

        int theta = angle;

	RCServo2.write(theta)
;

    LCD.clear();
    LCD.home();
    LCD.setCursor(0,0); LCD.print("Servomotor Cntrl");
    LCD.setCursor(0,1); LCD.print(theta);
	delay(50);

}

