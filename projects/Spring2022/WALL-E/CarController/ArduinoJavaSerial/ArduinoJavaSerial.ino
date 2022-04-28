#include <Servo.h>

Servo esc;

void setup()
{                
  Serial.begin(115200); 
  esc.attach(9);    
  esc.writeMicroseconds(1500);
  delay(5000);
}

String in;

void loop()
{
          if (Serial.available())
          {
              in = Serial.readStringUntil('s');
              esc.writeMicroseconds(in.toInt());
              Serial.println(in);
          }
}
