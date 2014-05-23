#include <phys253.h>          //   ***** from 253 template file
#include <LiquidCrystal.h>    //   ***** from 253 template file
#include <Servo253.h>         //   ***** from 253 template file

float sensorValue = 0;
float amplitudeValue = 0;

void setup()
{
  portMode(0, INPUT) ;      //   ***** from 253 template file
  portMode(1, INPUT) ;      //   ***** from 253 template file
  
  Serial.begin(9600);
    
  LCD.clear();
  LCD.home();
  LCD.setCursor(0,0); LCD.print("Hello World!");
  LCD.setCursor(0,1); LCD.print("Press Start");
  while ( !(startbutton()) ) ;

}

void loop()
{
	sensorValue = analogRead(1);

	amplitudeValue = (sensorValue * (5.0)/( 1023 ));
	
	LCD.clear(); LCD.home(); LCD.setCursor(0,0);
	LCD.print("Voltage:");

	LCD.setCursor(0,1);
	LCD.print( amplitudeValue );
        delay(100);
        
        Serial.println( amplitudeValue );
        
} 
