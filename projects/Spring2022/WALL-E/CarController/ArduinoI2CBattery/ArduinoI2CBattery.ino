#include <Wire.h>
#define ESC_BATTERY_PIN A1
#define RPI_BATTERY_PIN A0

void setup() {
  pinMode(ESC_BATTERY_PIN, INPUT);
  pinMode(RPI_BATTERY_PIN, INPUT);
  Wire.begin(8);
  digitalWrite(SDA, 0);
  digitalWrite(SCL, 0);
  Wire.onRequest(requestEvent);
}

int escBatteryLevel = 0;
int rpiBatteryLevel = 0;
String out = "";

void loop() {
  escBatteryLevel = constrain(map(analogRead(ESC_BATTERY_PIN), 288, 325, 0, 100), 0, 100);
  rpiBatteryLevel = constrain(map(analogRead(RPI_BATTERY_PIN), 215, 325, 0, 100), 0, 100);
  out = String(abs(escBatteryLevel)) + "-" + String(abs(rpiBatteryLevel));
}

void requestEvent() {
  Wire.write(out.c_str());
}
