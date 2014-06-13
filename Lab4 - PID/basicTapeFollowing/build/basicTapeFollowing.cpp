#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

#include "WProgram.h"
#include <HardwareSerial.h>
void setup();
void loop();
int threshold = 200;
int speed = 500;

int state = 0;
int lastState = 0;
int thisState = 0;
int lastTime = 0;
int thisTime = 0;
int i = 0;

int pro = 0;
int der = 0;
int result = 0;




void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
  
    LCD.setCursor(0,0); LCD.print("Cool radically");
    LCD.setCursor(0,1); LCD.print("awesome program!!!");
    delay(50);
       
    while( !(startbutton()) );
}

void loop()
{
  int l = analogRead(0);
  int r = analogRead(1);
  
  int K_p = analogRead(6);
  int K_d = analogRead(7);
  

    if(l > threshold && r > threshold){
      state = 0;
    } else if(l < threshold && r > threshold){
      state = -1;
    } else if(l > threshold && r < threshold){
      state = 1;
    } else if(1 < threshold && r < threshold && state < 0) {
      state = -5;
    } else if(1 < threshold && r < threshold && state >= 0) {
      state = 5;
    }
  
  
  if(state != thisState){
    lastState = thisState;
    lastTime = thisTime;
    thisTime = 1;
  }
  
  pro = K_p * state;
  der = (int)((float)K_d * (float)(state-lastState) / (float)(thisTime + lastTime));
  
  result = speed + pro + der;
    
//  if(result > 700 - speed){
//    result = 700;
//  } else if(result < 0){
//    result = 0;
//  }
  
  motor.speed(3, speed - result);
  motor.speed(2, speed + result);  
  
  if( i==50) {
    LCD.clear();
    LCD.home(); 
    
    LCD.print("L: "); LCD.print(l); LCD.print(" R: "); LCD.print(r);
    LCD.setCursor(0,1);
    LCD.print("Kp:"); LCD.print(K_p); LCD.print(" Kd:"); LCD.print(K_d);
    
    i = 0;
  }
  
  i++;
  thisTime++;
  
  thisState = state;
}

