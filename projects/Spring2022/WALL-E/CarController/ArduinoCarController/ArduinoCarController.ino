#include <Servo.h>
#define STOP 1500
#define FORWARD_MAX 1650
#define FORWARD_MIN 1580
#define BACKWARD_MAX 1300
#define BACKWARD_MIN 1390
#define ESC_PIN 9
#define ESC_BATTERY_PIN A0
#define RPI_BATTERY_PIN A1

Servo esc;

const char delimiter = ":";
const char terminator = 's';
const int mul = 1000;

void setup()
{
  Serial.begin(115200);
  esc.attach(ESC_PIN);
  esc.writeMicroseconds(STOP);
  delay(5000);
}

String input;
char* temp;
String values[2];
float prevSpeed = 0;
float prevAngle = 0;
float inputSpeed = 0;
float inputAngle = 0;
int escBatteryLevel = 0;
int rpiBatteryLevel = 0;

void loop()
{
  if (Serial.available())
  {
    input = Serial.readStringUntil(terminator);

    temp = strtok(input.c_str(), delimiter);
    for (int i = 0; temp != NULL; i++) {
      values[i] = temp;
      temp = strtok(NULL, delimiter);
    }
    escBatteryLevel = map(analogRead(ESC_BATTERY_PIN), 0, 1024, 0, 100);
    rpiBatteryLevel = map(analogRead(RPI_BATTERY_PIN), 0, 1024, 0, 100);
    Serial.println(String(escBatteryLevel) + "-" + String(rpiBatteryLevel));

    inputSpeed = values[0].toFloat();
    inputAngle = values[1].toFloat();

    if (inputSpeed < 0 && prevSpeed >= 0)
      switchToBackward();

    int t = 0;
    if(inputSpeed > 0 && inputSpeed <= 1) {
      t = map(inputSpeed * mul, 0, mul, FORWARD_MIN, FORWARD_MAX);
      esc.writeMicroseconds(t);
    } else if (inputSpeed < 0 && inputSpeed >= -1) {
      t = map(inputSpeed * mul, -mul, 0, BACKWARD_MIN, BACKWARD_MAX);
      esc.writeMicroseconds(t);
    } else {
      t = STOP;
      esc.writeMicroseconds(STOP);
    }

    //todo for servo
    
    prevSpeed = inputSpeed;
    prevAngle = inputAngle;
  }

  if(!Serial)
    esc.writeMicroseconds(STOP);
}

void switchToBackward() {
  esc.writeMicroseconds(STOP);
  delay(40);
  esc.writeMicroseconds(BACKWARD_MIN);
  delay(40);
  esc.writeMicroseconds(STOP);
}

double mapf(double val, double in_min, double in_max, double out_min, double out_max) {
    return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
