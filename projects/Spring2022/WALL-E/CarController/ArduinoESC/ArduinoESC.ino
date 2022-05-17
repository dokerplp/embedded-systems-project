#include <Servo.h>
#define STOP 1500
#define FORWARD_MAX 1650
#define FORWARD_MIN 1580
#define BACKWARD_MAX 1300
#define BACKWARD_MIN 1390

int value = 0;

Servo esc; 

void setup() {

  esc.attach(9);   
  Serial.begin(9600);   
  esc.writeMicroseconds(STOP);
  delay(5000);
}

void loop() {

  esc.writeMicroseconds(value);
  if(Serial.available()) 
    value = Serial.parseInt();    // Parse an Integer from Serial


  // for(int i = FORWARD_MIN; i <= FORWARD_MAX; i++)
  // {
  //   esc.writeMicroseconds(i);
  //   delay(300);
  //   Serial.println(i);
  // }
  // esc.writeMicroseconds(STOP);
  // for(int i = FORWARD_MAX; i >= FORWARD_MIN; i--)
  // {
  //   esc.writeMicroseconds(i);
  //   delay(300);
  //   Serial.println(i);
  // }
  // esc.writeMicroseconds(STOP);
  // delay(40);
  // esc.writeMicroseconds(BACKWARD_MIN);
  // delay(40);
  // esc.writeMicroseconds(STOP);
  // delay(40);
  // for(int i = BACKWARD_MIN; i >= BACKWARD_MAX; i--)
  // {
  //   esc.writeMicroseconds(i);
  //   delay(300);
  //   Serial.println(i);
  // }
  // esc.writeMicroseconds(STOP);
  // for(int i = BACKWARD_MAX; i <= BACKWARD_MIN; i++)
  // {
  //   esc.writeMicroseconds(i);
  //   delay(300);
  //   Serial.println(i);
  // }
  // esc.writeMicroseconds(STOP);
}
