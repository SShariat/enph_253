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
   int motorSpeed_1 = 0 ;
   int motorSpeed_2 = 0;
   int outputSpeed_1 = 0;
   int outputSpeed_2 = 0;

	LCD.clear();  LCD.home() ;
       // 16 positions on LCD screen:   1234567890123456
         LCD.setCursor(0,0); LCD.print("M6:");  LCD.print(outputSpeed_1);LCD.print("M7:");  LCD.print(outputSpeed_2);
         LCD.setCursor(0,1); LCD.print("<stop>");
   
/////////////////////////////////////////////////
// DC MOTOR RUN
/////////////////////////////////////////////////

/*  This program uses the two knob inputs and cycles through the 4 motor outputs, positive and negative.  
You can see by the timing and brightness of the LED the direction and speed of the motor.
Knob 6 sets the PWM duty cycle of the DC motor signala
knob 7 sets the length of time that the motor spends going in each direction for each motor.
*/

while ( !(stopbutton()) ) {
      
         motorSpeed_1 = knob(6) ;
         outputSpeed_1 = (motorSpeed_1-512)*2+1;
		 
		 motorSpeed_2 = knob(7) ;
         outputSpeed_2 = (motorSpeed_2-512)*2+1;
         
         LCD.clear();  LCD.home() ;
       // 16 positions on LCD screen:   1234567890123456
         LCD.setCursor(0,0); LCD.print("M6:");  LCD.print(outputSpeed_1);LCD.print("M7:");  LCD.print(outputSpeed_2);
         LCD.setCursor(0,1); LCD.print("<stop>");
			
       motor.speed(1,outputSpeed_1);
       motor.speed(2,outputSpeed_2);
       
       /* motor.speed(i, motorSpeed) ;
        if (stopbutton()) {break;} ;
        delay(knob(7)) ;
        motor.speed(i, -motorSpeed);
        if (stopbutton()) {break;} ;
        delay(knob(7)) ;    
        motor.stop(i) ; */
        delay(200);
	
}

