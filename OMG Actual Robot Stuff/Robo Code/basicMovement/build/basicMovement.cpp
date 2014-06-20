#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file



#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
void setup()
{
  portMode(0, INPUT) ; // Initializing the motor inputs.
  portMode(1, INPUT) ;
  
    LCD.setCursor(0,0); LCD.print("Wazzuuuup? Let's");
    LCD.setCursor(0,1); LCD.print("start roving!");
    delay(50);
       
    while( !(startbutton()) ); // Our loop.
}

void loop()
{    
  // The pause function.
  if( stopbutton() ){
    delay(50); // Pause to make sure the stopbutton wasn't pressed by motor noise
    
    if( stopbutton() ){
      motor.speed(3, 0);
      motor.speed(2, 0); 
         
      while( !startbutton() ){
        
        LCD.clear();
        LCD.home();
        LCD.print("PAUSED");
        
        delay(50);
      }  
    }
  }
  
  int speed = analogRead(6);
  int turn = 2*(analogRead(7)-511);
	
  if (turn > 1023) {
    turn = 1023;
  } else if ( turn < -1023) {
    turn = -1023;
  }
  
  motor.speed(3, -speed - turn);
  motor.speed(2, -speed + turn);
  
  LCD.clear(); LCD.home();
  LCD.setCursor(0,0); LCD.print("Speed: "); LCD.print(speed);
  LCD.setCursor(0,1); LCD.print("Turning: "); LCD.print(turn);
  delay(50);
}

