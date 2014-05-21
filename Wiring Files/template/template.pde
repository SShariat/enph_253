#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

void setup() 
{
  portMode(0, INPUT);
  portMode(1, INPUT);
  RCServo0.attach(RCServo0Output);
  RCServo1.attach(RCServo1Output);
  RCServo2.attach(RCServo2Output);
}
  
  void loop() 
{
  LCD.setCursor(0,0); LCD.print("Hello World!");
  //prints a lovely message
  
  int x = portRead(0);
  
  LCD.clear(); //resets the LCD board for the switchy switchy 'if' program.
  LCD.setCursor(0,0);
  
  if (x == HIGH ) {
    LCD.print("The magical "); LCD.println("switch is open");
  }    
  else {
    LCD.print("The magical "); LCD.println("switch is closed");
  }


}

