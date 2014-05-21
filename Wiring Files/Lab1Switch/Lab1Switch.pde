#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>


void setup() 
{
  portMode(0, INPUT);
  
  LCD.clear();
  LCD.home();
  LCD.setCursor(0,0); LCD.print("Hello World!");
  LCD.setCursor(0,1); LCD.print("Press Start");
  while ( !(startbutton()) ) ;
}

void loop() 
{
  int x = LOW;
  x = digitalRead(0);
  
  LCD.clear(); LCD.home(); LCD.setCursor(0,0);
        
  if (x == HIGH) {
    LCD.print("No reflection ");
    LCD.setCursor(0,1); LCD.print("detected");
  }    
  else if (x== LOW) {
    LCD.print("Reflection ");
    LCD.setCursor(0,1); LCD.print("detected!");
  }
  else {
    LCD.print("WTF did you do?");
  }
  
  delay(100);
}
