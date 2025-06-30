#include <SPI.h>
#include <LoRa.h>
#include <OneWire.h>
#include <DallasTemperature.h>
 
// Data wire is plugged into pin 2 on the Arduino
#define OneWireBus 2
 
// Setup a oneWire instance to communicate with any OneWire devices 
// (not just Maxim/Dallas temperature ICs)
OneWire oneWire(OneWireBus);
 
// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

void setup() {
 Serial.begin(9600);
 while (!Serial);
 Serial.println("LoRa Sender Test");
 // start sensor readings
 sensors.begin();
 // Initalize the LoRa radio on the shield.
 // NB: Replace the operating frequency of your shield here.
 // 915E6 for North America, 868E6 for Europe, 433E6 for Asia
 if (!LoRa.begin(915E6)) {
 Serial.println("Starting LoRa failed!");
 while (1);
 }
}
void loop() {

  Serial.print("Temperature in degrees C: ");
  Serial.print(sensors.getTempCByIndex(0)); // Why "byIndex"? 
  Serial.println();

 // Transmit the LoRa packet
 LoRa.beginPacket();
 LoRa.print(sensors.getTempCByIndex(0));
 LoRa.endPacket();
 delay(3000);
}


////#include <SPI.h>
////void setup() {
//// Serial.begin(9600);
//// while (!Serial);
//// Serial.println("LoRa Sender Test");
////}
////void loop() {
//// Serial.println("Hello.");
//// delay(30000);
////}
//#include <SPI.h>
//#include <LoRa.h>
//void setup() {
// Serial.begin(9600);
// while (!Serial);
// Serial.println("LoRa Receiver Test");
// // Replace the operating frequency of your shield here.
// // 915E6 for North America, 868E6 for Europe, 433E6 for Asia
// if (!LoRa.begin(915E6)) {
// Serial.println("Starting LoRa failed!");
// while (1);
// }
//}
//void loop() {
//Serial.println("Hello.");
//delay(3000);
//            }
