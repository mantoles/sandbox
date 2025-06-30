#include <SPI.h>
#include <MFRC522.h>//rc522 module for readind cards
#include <RH_ASK.h> //radiohead library for the 433mhz modules
#include <SPI.h> // Not actually used but needed to compile
RH_ASK driver(2000, 3, 4, 0); // ESP8266 or ESP32: do not use pin 11 or 2, to 3 = receiver, 4= trasmiter alla en exw trasmiter, its on the other thingy
 
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.

  int systemArm =0;
  int a;
  unsigned long False_Inputs_Time;
  unsigned long Intruder_Time;
  unsigned long Start_Time;
  unsigned long Stop_Time;
  int FalseInputs=0;
  int state = LOW;             // by default, no motion detected
  int val = 0;
  int sensor = 2; // Gia interrupt balto sto pin 2


void setup() 
{
  //False_Inputs_Time=millis;
  //Intruder_Time=millis;
  pinMode(sensor, INPUT); 
  FalseInputs=0 ;
  systemArm=0;  
  Serial.begin(9600);   // Initiate a serial communication
  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522
  attachInterrupt(digitalPinToInterrupt(sensor),ISR_sensor,CHANGE); //elenkse ean mporeis na to valeis sto main loop gia an energopoiite ama theleis je oi opote thelei jino
  Serial.println("Approximate your card to the reader...");  // antikatastase to me grammi kodika gia na anapsei led (digitalWrite(prprld,HIGH );)
  if (!driver.init())
         Serial.println("init failed");
}
void loop() 
{
  
  if ( ! mfrc522.PICC_IsNewCardPresent()) 
  {
    return;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) 
  {
    return;
    
  }
  //Show UID on serial monitor
  Serial.print("UID tag :");
  String content= "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) 
  {
     Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
     Serial.print(mfrc522.uid.uidByte[i], HEX);
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  
  Serial.println();
  
  content.toUpperCase();
  delay(1000);
  Serial.print("Message : "); 
  Serial.println("Ready to read"); // blink once every min
  Serial.println();
  if (content.substring(1) == "17 55 B8 21") //change here the UID of the card/cards that you want to give access
  //dokimase dame na valeis to NUL gia na deis ean prepei na kamneis oti theleis gia na mi perimeneis na diabasei i karta kati 
  {
    Serial.println("Authorized access");// turn on green led for 1 sec
    FalseInputs=1;
 if (systemArm==1)
   systemArm=0;
  else 
   systemArm=1;    
  
    Serial.println(systemArm);
  }
 else   {
    Serial.println(" Access denied");  // blink  oses fores egine lathos FalseInputs 
    Serial.println();
    Serial.print("False inputs=");
    Serial.println(FalseInputs);
    FalseInputs++;
    if (FalseInputs >= 3)
      Serial.println("Wrong inputs more than 3 alarmed sound"); //blink everything!!!!!!!!!!
  }
  if (systemArm==1){
   Serial.println ("Sensor is Online");
   Serial.println();
   Serial.println("!System is armed!");}
    else 
      Serial.println("Place Master card to arm system");


      //receiver testing if working
    uint8_t buf[RH_ASK_MAX_MESSAGE_LEN];
    uint8_t buflen = sizeof(buf);

    if (driver.recv(buf, &buflen)) // Non-blocking
    {
  int i;


  driver.printBuffer("Got:", buf, buflen);
  String rcv;

  for (i=0; i < buflen; i++){
  rcv+=(char)buf[i]; //metatropi apo HEX se grammata
  }
  Serial.println(rcv); //xrisipomoia tin gia na kaneis meta ton elexo gia to ti tha gini me tin while()
  Serial.println("02"); //just for testing
  }
}

void ISR_sensor (){

 val = digitalRead(sensor);   // read sensor value
 if (systemArm==1){
  if (val == HIGH) {           // check if the sensor is HIGH
    delay(100);                // delay 100 milliseconds 
  
    if (state == LOW) {
      Serial.print("Motion detected!"); 
      
      state = HIGH;       // update variable state to HIGH
    }
  } 
  else {
    
      delay(200);             // delay 200 milliseconds 
      
      if (state == HIGH){
        Serial.println("Motion stopped!");
        state = LOW;       // update variable state to LOW
    }
  }
}}
 //dame tora, ena baleis ta sensors na steloun diaforetiko kwdiko gia eneropoihsi dld, 1-10 gia to oti en ok
 //i mana otan energopoihte ena blepei ton ena kai ena kserei oti exei tade sensors on, px paradeigma arithmos 11-100 o sensor einai on kai connected
 //enw arithmos 101-200 exei problima
 //arithmos 201-300 low bat???? enks an tha ta baloume mesa, ena deiksei 
 //ena dokimazei na blepei posoi stelnoun kai na akouei , apla kapos ena ta grapseis gia na men steloun oyloi taftoxrona.. i bale ti mana na blepei enks re malaka kame oti theleis
 //episis katebase RADIOHEAD libraries. done
