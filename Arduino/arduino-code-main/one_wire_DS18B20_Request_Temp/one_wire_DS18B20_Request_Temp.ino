// Sophronis Mantoles
// 08/29/2020
// based on onewire example.  Polls the temperature from the dallas DS18B20 chip and displays on serial port.
// temperature reading is in degrees C 

#include <OneWire.h>
#include <DallasTemperature.h>
 
// Data wire is plugged into pin 2 on the Arduino
#define OneWireBus 2
 
// Setup a oneWire instance to communicate with any OneWire devices 
// (not just Maxim/Dallas temperature ICs)
OneWire oneWire(OneWireBus);
 
// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);
 
void setup(void)
{
  // start serial port
  Serial.begin(9600);
  Serial.println("Dallas Temperature IC Control Library Demo");

  // Start up the library
  sensors.begin();
}
 
 
void loop(void)
{
  // call sensors.requestTemperatures() to issue a global temperature
  // request to all devices on the bus
  //Serial.print(" Requesting temperatures...");
  sensors.requestTemperatures(); // Send the command to get temperatures
  //Serial.println("DONE");

  Serial.print("Temperature in degrees C: ");
  Serial.print(sensors.getTempCByIndex(0)); // Why "byIndex"? 
  Serial.println();
    // You can have more than one IC on the same bus. 
    // 0 refers to the first IC on the wire
    delay(500);
}
