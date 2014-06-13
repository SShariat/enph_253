#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
    
    LCD.setCursor(0,0); LCD.print("Hello Zach, push");
    LCD.setCursor(0,1); LCD.print("Start to proceed"); 
    
    while(!startbutton());
}

void loop()
{
    LCD.clear();
    LCD.home();
    LCD.setCursor(0,0); LCD.print("Left Sensor");
    LCD.setCursor(12,0); LCD.print(analogRead(0));
    
    LCD.setCursor(0,1); LCD.print("Right Sensor");
    LCD.setCursor(13,1); LCD.print(analogRead(1));
    
    delay(50);
}
