// REV A SVM 08/29/2020
// Program to read the dallas semiconductor DS18S20 sensor output
// and output the temperature once the character "R" is received on the serial port
// History
// 08/29/2020 Initial version based on open source code 

#include <OneWire.h>
#include <DallasTemperature.h>

// Setup a oneWire instance to communicate with any OneWire devices (Data lines are connected on pins 2

OneWire ds_1(2);

// Pass oneWire reference to Dallas Temperature.

DallasTemperature sensor_1(&ds_1);

void setup()

{

  // set the data rate for the SoftwareSerial port

  // For minicom testing

  //Serial.begin(115200);

  // For comunicating with the serial port on at 19200 baud rate

  Serial.begin(19200);
}

// This starts the main program - a loop that looks for the letter "R" from the serial connection.
// If a "R" is received the Arduino will reply with the current temperature.


void loop()
    {

  // int val = 0;

  if (Serial.available() >0)
     {
    int val = Serial.read();
    
    if (val==82) // 82 is equal to "R"
       {
    //getting the voltage reading from the temperature sensor
    DallasTemperature sensor_1(&ds_1);
    sensor_1.begin();
    delay(50); // 50 ms delay
    sensor_1.requestTemperatures(); // Send the command to get temperatures
    delay(100);        // pauses for 100 milliseconds
    // This last line mimics the ascii output of a met station
    Serial.print("0R0,Dm=0#,Sm=0.0#,Ta=");Serial.print(sensor_1.getTempCByIndex(0),1); Serial.println("C,Ua=0.0P,Pa=1.000B,Rc=1.00M,Hc=1.0M");
       }
    } // end of if serial is available

  }

// end of program
