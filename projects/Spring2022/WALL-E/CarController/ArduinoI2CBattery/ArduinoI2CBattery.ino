#include <Wire.h>
#define ESC_BATTERY_PIN A0
#define RPI_BATTERY_PIN A1

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
  escBatteryLevel = map(analogRead(ESC_BATTERY_PIN), 0, 370, 0, 100);
  rpiBatteryLevel = map(analogRead(RPI_BATTERY_PIN), 0, 520, 0, 100);
  out = String(escBatteryLevel) + "-" + String(rpiBatteryLevel);
}

void requestEvent() {
  Wire.write(out.c_str());
}
