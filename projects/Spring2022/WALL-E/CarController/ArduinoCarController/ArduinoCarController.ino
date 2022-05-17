#include <Servo.h>
#define STOP 1500
#define FORWARD_BRAKE 1000
#define FORWARD_MAX 1850
#define FORWARD_MIN 1580
#define BACKWARD_BRAKE 1570
#define BACKWARD_MAX 1200
#define BACKWARD_MIN 1390
#define ESC_PIN 9
#define ESC_BATTERY_PIN A0
#define RPI_BATTERY_PIN A1
#define STEERING_PIN 8
#define ROTATE_RIGHT_MAX 70
#define ROTATE_ZERO 93
#define ROTATE_LEFT_MAX 120

Servo esc;
Servo steering;

const char delimiter = ':';
const char terminator = 's';
const int mul = 1000;

void setup()
{
  Serial.begin(115200);
  esc.attach(ESC_PIN);
  esc.writeMicroseconds(STOP);
  steering.attach(STEERING_PIN);
  steering.write(ROTATE_ZERO);
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

long toStop = 0;

void loop()
{
  if (Serial.available())
  {
    input = Serial.readStringUntil(terminator);

    int i = 0;
    while (input.length() > 0)
    {
      int index = input.indexOf(delimiter);
      if (index == -1)
      {
        values[i++] = input;
        break;
      }
      else
      {
        values[i++] = input.substring(0, index);
        input = input.substring(index + 1);
      }
    }

    escBatteryLevel = map(analogRead(ESC_BATTERY_PIN), 0, 1024, 0, 100);
    rpiBatteryLevel = map(analogRead(RPI_BATTERY_PIN), 0, 1024, 0, 100);
    Serial.println(String(escBatteryLevel) + "-" + String(rpiBatteryLevel));

    inputSpeed = values[0].toFloat();
    inputAngle = values[1].toFloat();

    if (inputSpeed < 0 && prevSpeed >= 0)
      switchToBackward();

    if (inputSpeed > 0 && inputSpeed <= 1)
      esc.writeMicroseconds(map(inputSpeed * mul, 0, mul, FORWARD_MIN, FORWARD_MAX));
    else if (inputSpeed < 0 && inputSpeed >= -1)
      esc.writeMicroseconds(map(inputSpeed * mul, -mul, 0, BACKWARD_MAX, BACKWARD_MIN));
    else {

      if(prevSpeed > 0) {
        toStop = millis();
        esc.writeMicroseconds(FORWARD_BRAKE);
        delay(40);
      } else if(prevSpeed < 0) {
        toStop = millis();
        esc.writeMicroseconds(BACKWARD_BRAKE);
        delay(40);
      }
      if(millis() - toStop >= 1000) {
        esc.writeMicroseconds(STOP);
      }
    }
      

    if (inputAngle == 0)
      steering.write(ROTATE_ZERO);
    else
      steering.write(map(inputAngle * mul, -mul, mul, ROTATE_LEFT_MAX, ROTATE_RIGHT_MAX));

    prevSpeed = inputSpeed;
    prevAngle = inputAngle;
  }

  if (!Serial)
    esc.writeMicroseconds(STOP);
}

void switchToBackward() {
  esc.writeMicroseconds(STOP);
  delay(40);
  esc.writeMicroseconds(BACKWARD_MIN);
  delay(40);
  esc.writeMicroseconds(STOP);
  delay(40);
  esc.writeMicroseconds(BACKWARD_MIN);
}
