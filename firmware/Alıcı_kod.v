#include <SPI.h>
#include <RadioLib.h>

// -------- LoRa PINLER --------
#define LORA_CS    17
#define LORA_DIO0  20
#define LORA_RST   21

// -------- SPI PINLER --------
#define SPI_SCK   18
#define SPI_MISO  16
#define SPI_MOSI  19

SX1278* lora;

void setup() {
  Serial.begin(115200);
  while (!Serial) { delay(10); }
  Serial.println("=== RX KART ===");

  // ---- SPI baslat ----
  SPI.setSCK(SPI_SCK);
  SPI.setRX(SPI_MISO);
  SPI.setTX(SPI_MOSI);
  SPI.begin();
  Serial.println("SPI OK");

  // ---- SX1278 ----
  lora = new SX1278(new Module(LORA_CS, LORA_DIO0, LORA_RST));

  int state = lora->begin(433.0);
  if (state != RADIOLIB_ERR_NONE) {
    Serial.print("LoRa init HATA, kod = ");
    Serial.println(state);
    while (1);
  }

  // ---- TX ile AYNI parametreler ----
  lora->setSpreadingFactor(7);
  lora->setBandwidth(125.0);
  lora->setCodingRate(5);

  Serial.println("RX modunda, paket bekleniyor...");
}

void loop() {
  String incoming;

  int state = lora->receive(incoming);

  if (state == RADIOLIB_ERR_NONE) {
    Serial.print("ALINDI: ");
    Serial.println(incoming);

    Serial.print("RSSI: ");
    Serial.print(lora->getRSSI());
    Serial.print(" dBm | SNR: ");
    Serial.print(lora->getSNR());
    Serial.println(" dB");
    Serial.println("------------------------");
  }
}
