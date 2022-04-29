#include <Servo.h>

Servo esc;

void setup()
{                
  Serial.begin(115200); 
  esc.attach(9);    
  esc.writeMicroseconds(1500);
  delay(5000);
}

String input;


void loop()
{
  if (Serial.available())
  {
    input = Serial.readStringUntil('s');
    esc.writeMicroseconds(in.toInt());
    Serial.println(input);
  }
}
