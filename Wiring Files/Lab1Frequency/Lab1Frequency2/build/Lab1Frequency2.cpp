#include <phys253.h>
#include <LiquidCrystal.h>
#include <Servo253.h>

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
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
 int x = digitalRead(0);
 long one = 0;
 long two = 0;
 long d = 0;
 float f = 0;
 float g = 0;
 
 while(!digitalRead(0))
 {}
 while(x == HIGH) {
   x = digitalRead(0);
 }
 one = micros();
 while(x == LOW) {
   x = digitalRead(0);
 }
 two = micros();

 d = two-one;
 g = float(2*d);
 f = float(1000000/g);
 
 LCD.clear(); LCD.home();
 LCD.setCursor(0,0); LCD.print(d);
 LCD.setCursor(0,1); LCD.print(f); 
 delay(200);
}

