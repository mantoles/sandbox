// REV A SVM 08/17/2021
// Program to send a command of "C" to close relays on a relay board or "O" to open the relays 
// Close pulls the IO lines low.  So the circuit will be used as a sink for the relay coil.  
// Open pulls the IO lines High.
// the arduino acknowledges the status of the relays with a 13 character word  
// History
// 08/17/2021 Initial version open and close all channels at the same time


void setup()

{


  // For comunicating with the serial port on at 19200 baud rate

  Serial.begin(19200);
  // set digital pins 2 to 9 to outputs
  pinMode(2, OUTPUT);    // sets the digital pin 2 as output 
  pinMode(3, OUTPUT);    // sets the digital pin 3 as output 
  pinMode(4, OUTPUT);    // sets the digital pin 4 as output 
  pinMode(5, OUTPUT);    // sets the digital pin 5 as output 
  pinMode(6, OUTPUT);    // sets the digital pin 6 as output 
  pinMode(7, OUTPUT);    // sets the digital pin 7 as output 
  pinMode(8, OUTPUT);    // sets the digital pin 8 as output 
  pinMode(9, OUTPUT);    // sets the digital pin 9 as output 
  
}

// This starts the main program - a loop that looks for the letter "R" from the serial connection.
// If a "O"== 79 is received the Arduino will reply with opening relays else if "C" == 67 is received it will close the relays.


void loop()
  {
  // int val = 0;
  if (Serial.available() >0)
     {
    int val = Serial.read();
    
    if (val==79) // 79 is equal to "O"
       {
        for (int i = 2 ; i < 10; i++)
        { 
         digitalWrite(i, HIGH);
         delayMicroseconds(10); //microseconds
        }
        delay(50); // wait 50 ms
        Serial.println("Relays-->Open");
       }
       else if (val == 67) //67 is equal to "C"
       {
        for (int i = 2 ; i < 10; i++)
        { 
         digitalWrite(i, LOW);
         delayMicroseconds(10); //microseconds
        }
        delay(50); // wait 50 ms
        Serial.println("Relays->Closed");
       }
      } // end of if serial is available

  }

// end of program
