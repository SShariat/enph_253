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
 LCD.clear();
 long count = 0;
 int x = 0;
 
 x = digitalRead(0);\
 long start = millis();
 
 while( millis()-start < 1000) {
   if( x != digitalRead(0) ){
     count++;
     x = digitalRead(0);
   }
 }
 
 LCD.print(count/2);
 // serial.print(count);
 delay(200);
}
