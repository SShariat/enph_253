//Having found out how to play tunes, I decided to make it play Ode To Joy! :D

int speakerPin = 9;
 
int numTones = 10;
int tones[] = {261, 277, 294, 311, 330, 349, 370, 392, 415, 440};
//          mid C    C#   D    D#   E    F    F#   G    G#   A
//              1    2    3    4    5    6    7    8    9   10
 
void setup()
{
  
//  D F D F D' F D' / E D
  
}
 
void loop()
{
  tone(speakerPin, tones[5]);
  delay(500);
  tone(speakerPin, tones[5]) ;
  delay(500);
  tone(speakerPin, tones[6]); 
  delay(500);
  tone(speakerPin, tones[8]) ;
  delay(500);
  tone(speakerPin, tones[8]) ;
  delay(500);
  tone(speakerPin, tones[6]) ;
  delay(500);
  tone(speakerPin, tones[5]) ;
  delay(500);
  tone(speakerPin, tones[3]) ;
  delay(500);
  tone(speakerPin, tones[1]) ;
  delay(500);
  tone(speakerPin, tones[1]) ;
  delay(500);
  tone(speakerPin, tones[3]) ;
  delay(500);
  tone(speakerPin, tones[5]) ;
  delay(500);
  tone(speakerPin, tones[5]) ;
  delay(500);
  tone(speakerPin, tones[3]) ;
  delay(500);
  tone(speakerPin, tones[3]) ;
  delay(500);
  
  
  delay(3000);
  
  
}
