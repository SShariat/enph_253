#include <HardwareSerial.h>
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
   int variable = LOW ;                // setting up a few temporary variables 
   int value, value2, i, pinNumber ;
   int portCounter = 0 ;
   int motorSpeed = 0 ;
   int outputSpeed = 0;
  
/////////////////////////////////////////////////
// DC MOTOR TEST
/////////////////////////////////////////////////

/*  This program uses the two knob inputs and cycles through the 4 motor outputs, positive and negative.  
You can see by the timing and brightness of the LED the direction and speed of the motor.
Knob 6 sets the PWM duty cycle of the DC motor signal
knob 7 sets the length of time that the motor spends going in each direction for each motor.
*/

while ( !(stopbutton()) ) {
      
         motorSpeed = knob(6) ;
         outputSpeed = (motorSpeed-512)*2+1;
         
         LCD.clear();  LCD.home() ;
       // 16 positions on LCD screen:   1234567890123456
         LCD.setCursor(0,0); LCD.print("DC Motor: ");  LCD.print(outputSpeed) ;
         LCD.setCursor(0,1); LCD.print("<stop>");
			
       /* motor.speed(i, motorSpeed) ;
        if (stopbutton()) {break;} ;
        delay(knob(7)) ;
        motor.speed(i, -motorSpeed);
        if (stopbutton()) {break;} ;
        delay(knob(7)) ;    
        motor.stop(i) ; */
        delay(300);
	
        motor.speed(1,outputSpeed);	
       // RCServo1.write(motorSpeed/5.6);
		
		
      
  }
   motor.stop_all() ;
}

