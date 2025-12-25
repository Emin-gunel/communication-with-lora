#include <SPI.h>
#include <Wire.h>
#include <RadioLib.h>
#include <Adafruit_BME280.h>

// -------- LoRa PINLER --------
#define LORA_CS    17
#define LORA_DIO0  20
#define LORA_RST   21

#define SPI_SCK   18
#define SPI_MISO  16
#define SPI_MOSI  19

// -------- BME280 PINLER --------
#define SDA_PIN 0
#define SCL_PIN 1

SX1278* lora;
Adafruit_BME280 bme;

int packetCounter = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) { delay(10); }
  Serial.println("BME280 + LoRa TX basladi");

  // ---- I2C (BME280) ----
  Wire.setSDA(SDA_PIN);
  Wire.setSCL(SCL_PIN);
  Wire.begin();

  if (!bme.begin(0x76)) {
    Serial.println("BME280 bulunamadi!");
    while (1);
  }
  Serial.println("BME280 OK");

  // ---- SPI (LoRa) ----
  SPI.setSCK(SPI_SCK);
  SPI.setRX(SPI_MISO);
  SPI.setTX(SPI_MOSI);
  SPI.begin();

  lora = new SX1278(new Module(LORA_CS, LORA_DIO0, LORA_RST));

  if (lora->begin(433.0) != RADIOLIB_ERR_NONE) {
    Serial.println("LoRa init hatasi!");
    while (1);
  }

  lora->setSpreadingFactor(7);
  lora->setBandwidth(125.0);
  lora->setCodingRate(5);
  lora->setOutputPower(17);

  Serial.println("LoRa TX hazir");
}

void loop() {
  // ---- SENSOR OKUMA ----
  float temperature = bme.readTemperature();
  float humidity    = bme.readHumidity();
  float pressure    = bme.readPressure() / 100.0;

  // ---- VERI PAKETLEME ----
  String packet =
    "ID:" + String(packetCounter) +
    ";T:" + String(temperature, 1) +
    ";H:" + String(humidity, 1) +
    ";P:" + String(pressure, 1);

  // ---- LoRa GONDER ----
  int state = lora->transmit(packet);

  if (state == RADIOLIB_ERR_NONE) {
    Serial.print("GONDERILDI: ");
    Serial.println(packet);
  } else {
    Serial.println("TX HATASI");
  }

  packetCounter++;
  delay(2000);
}
