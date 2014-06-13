#include <HardwareSerial.h>
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
  portMode(1, INPUT);
  RCServo0.attach(RCServo0Output);
  RCServo1.attach(RCServo1Output);
  RCServo2.attach(RCServo2Output);
}

void loop() 
{
  int motorSpeed_1 = 0 ;
  int motorSpeed_2 = 0;
  int outputSpeed_1 = 0;
  int outputSpeed_2 = 0;
  int right = 0;
  int left = 0;
  int thresh = 100;
  int k_d = 0;
  int k_p = 0;
  int d = 0;
  int p = 0;
  int error = 0;
  int lasterr = 0;
  int recerr = 0;
  int con = 0;
  int q =0;
  int m=0;
  int c=0;
  int bot_speed = 250;
  /////////////////////////////////////////////////
  // Tape Follower PID
  /////////////////////////////////////////////////

  /*  This program uses the two knob inputs and cycles through the 4 motor outputs, positive and negative.  
   You can see by the timing and brightness of the LED the direction and speed of the motor.
   Knob 6 sets the PWM duty cycle of the DC motor signal
   knob 7 sets the length of time that the motor spends going in each direction for each motor.
   */
	
 while ( !(startbutton()) ) {

    //Read from QRD
    right = analogRead(0);
    left = analogRead(1);
    k_d = knob(6)/10.0;
    k_p = knob (7)/10.0;


    if((left>thresh)&&(right>thresh)) error = 0;
    if((left>thresh)&&(right<thresh)) error = 1;
    if((left<thresh)&&(right>thresh)) error = -1;

    if((left<thresh)&&(right<thresh))
    { 
      if(lasterr>=0) error = 5;
      if(lasterr<0) error = -5;
    }
    if(!(error==lasterr))
    {
      recerr=lasterr;
      q = m;
      m = 1;
    }

    p = k_p*error;
    d = (int)((float)k_d*(float)(error-recerr)/(float)(q+m));
    con = p + d;

    //Print to Screen
    if (c==30)
    {
      LCD.clear();  
      LCD.home() ;
      //LCD.setCursor(0,0); LCD.print("R:");  LCD.print(right);LCD.print(" L:");  LCD.print(left);
      LCD.setCursor(0,0); 
     
      LCD.print("kp: ");  
      LCD.print(k_p); 
      
      LCD.print(" kd:"); 
      LCD.print(k_d); 
      
      LCD.setCursor(0,1); 
      LCD.print("p:"); 
      LCD.print(p); 
      LCD.print(" d:"); 
      LCD.print(d);
      c = 0;
    }

    c = c+1;
    
    m =m+1;
    lasterr = error;

	//Motor Speed Allocation
    motor.speed(1,con+bot_speed);
    motor.speed(3,-con+bot_speed); 
  }
  motor.stop_all() ;
}


