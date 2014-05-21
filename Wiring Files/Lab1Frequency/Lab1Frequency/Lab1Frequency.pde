#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

void setup() 
{
    portMode(0, INPUT);
  
    LCD.clear();
    LCD.home();
    LCD.setCursor(0,0); LCD.print("Wave Frequency");
    LCD.setCursor(0,1); LCD.print("Press Start");
    while ( !(startbutton()) ) ;
}

void loop() 
{
 long one = 0;
 long two = 0;
 long a = 0;
 long b = 0;
 long f = 0;
 
 a = digitalRead(0);
 delay(1);
 b = digitalRead(0);
 
 if( (a != b) && (one == 0)) {
   one = millis();
 }
 if( (a != b) && (one != 0)) {
   two = millis();
 }
 
 if( (one != 0) && (two != 0) ) {
   f = 1/(2*(two - one));
 }
 
 LCD.clear(); LCD.home();
 LCD.setCursor(0,0); LCD.print(f);
 delay(20);
 
}
