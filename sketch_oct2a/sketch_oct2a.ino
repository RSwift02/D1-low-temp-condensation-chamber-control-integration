#include <OneWire.h>
#include <DallasTemperature.h>
#include <DHT.h>

#define ONE_WIRE_BUS 2
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

#define ONE_WIRE_BUS_W 11
OneWire oneWireW(ONE_WIRE_BUS_W);
DallasTemperature waterSensors(&oneWireW);

#define DHTPIN 3
DHT dht(DHTPIN, DHT22);

#define LPWM 5
#define RPWM 9

const unsigned int STEP_DUTY = 254;         // 恒定 duty 用
const bool RAMP_DUTY = false;               // 恒定模式
const unsigned long RAMP_MS = 120000UL;     // 三角波周期（不使用）
const unsigned long DUTY_PERIOD = 200UL;    // duty 更新速率
const unsigned long DHT_PERIOD = 5000UL;    // DHT22 间隔
const unsigned long SAMPLE_MS = 30000UL;    // 每30s采样，省点日志，也够看趋势

unsigned long nextDuty = 0, nextDht = 0, nextPrint = 0;
float tCav = NAN, lastAmb = NAN, lastWIn = NAN;
unsigned int duty = 0;

void setDrive(unsigned int value) {
  duty = constrain(value, 0, 255);
  analogWrite(LPWM, duty);
  analogWrite(RPWM, 0);
}

unsigned int rampDuty(unsigned long now) {
  unsigned long phase = now % RAMP_MS;
  unsigned long tri = phase < RAMP_MS / 2 ? phase * 2 : (RAMP_MS - phase) * 2;
  return (unsigned int)((tri * 255UL) / RAMP_MS);
}

void setup() {
  Serial.begin(115200);
  pinMode(LPWM, OUTPUT);
  pinMode(RPWM, OUTPUT);
  setDrive(0);
  sensors.begin();
  waterSensors.begin();
  dht.begin();
  Serial.print("#count=");
  Serial.println(sensors.getDeviceCount());
}

void loop() {
  unsigned long now = millis();

  if ((long)(now - nextDuty) >= 0) {
    nextDuty = now + DUTY_PERIOD;
    setDrive(RAMP_DUTY ? rampDuty(now) : STEP_DUTY);
  }

  if ((long)(now - nextDht) >= 0) {
    nextDht = now + DHT_PERIOD;
    float a = dht.readTemperature();
    if (!isnan(a)) lastAmb = a;
  }

  if ((long)(now - nextPrint) >= 0) {
    nextPrint = now + SAMPLE_MS;
    sensors.requestTemperatures();
    waterSensors.requestTemperatures();
    float t = sensors.getTempCByIndex(0);
    float w = waterSensors.getTempCByIndex(0);
    if (t > -55 && t < 125) tCav = t;
    if (w > -55 && w < 125) lastWIn = w;
    if (isnan(tCav)) return;
    Serial.print(millis());
    Serial.print(" duty="); Serial.print(duty);
    Serial.print(" tCav="); Serial.print(tCav, 2);
    if (!isnan(lastWIn)) { Serial.print(" wIn="); Serial.print(lastWIn, 2); }
    if (!isnan(lastAmb)) { Serial.print(" amb="); Serial.print(lastAmb, 2); }
    Serial.println();
  }
}