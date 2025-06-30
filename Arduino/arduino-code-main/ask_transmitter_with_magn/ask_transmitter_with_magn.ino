const unsigned long event=5000;
unsigned long previousTime=0;
unsigned long currentTime=0;
#include <RH_ASK.h>
#ifdef RH_HAVE_HARDWARE_SPI
#include <SPI.h> // Not actually used but needed to compile
#endif
int magn =2;
RH_ASK driver(2000, 4, 5, 0); // ESP8266 or ESP32: do not use pin 11 or 2
int val=0;
int x=1;

void setup(){
pinMode(magn, INPUT);
#ifdef RH_HAVE_SERIAL
Serial.begin(9600);	  // Debugging only
#endif
if (!driver.init())
#ifdef RH_HAVE_SERIAL
Serial.println("init failed");
#else
	;
#endif
  for(int i=0;i<3;i++){
  delay(1000);
  Serial.print(".");
  }
  Serial.println("callibration done");
}


void loop()
{ 
 if(digitalRead(magn)==0){
  val=1;
   if (val==1 && x==1){
    const char *msg = "alarm";
    driver.send((uint8_t *)msg, strlen(msg));
    driver.waitPacketSent();
    delay(200);
    currentTime=micros();
    x=0;
    val=0;
    }
 }

 
 if (currentTime - previousTime >= event){
  x=1;  
  previousTime=currentTime;
  Serial.println("RESET");
  }
  
}
  

//trasistor gia trofodosia
//rampos check sleep mode arduino 
      
