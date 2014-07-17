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
    
  
}

void loop()
{
	int speed = 0;
	
	speed = 2*(analogRead(6) - 511);
	
        if (speed >1023) {
         speed = 1023;
        } else if ( speed < -1023) {
          speed = -1023;
        }
  
  motor.speed(1,speed);
  motor.speed(2,speed);
  motor.speed(3,speed);


    LCD.clear();
    LCD.home();
    LCD.setCursor(0,0); LCD.print("Motor Program");
    LCD.setCursor(0,1); LCD.print(speed);
	delay(50);

}

