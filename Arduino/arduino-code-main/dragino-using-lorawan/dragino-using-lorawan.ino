#include "Arduino_LoRaWAN_Helium.h"
//#include <cstdint>

const char *devEui = "154BB0D8A20D77E9";
const char *appEui = "809BD4C8FCA04290";
const char *appKey = "2837B6D8A953FA09907589FD2B5A40BB";

// Max Payload 53 Bytes for DR 1
const uint8_t payload[] = "Hello, World!";

void setup( void )
{
    Serial.begin(9600);
    
    while (!Serial) { }

    // US Region
    LoRaWAN_Helium.begin(US915);
    //LoRaWAN.begin(US915);
    // Helium SubBand
    //LoRaWAN.setSubBand(2);
    LoRaWAN_Helium.setSubBand(2);
    // Disable Adaptive Data Rate
   // LoRaWAN.setADR(false);
   LoRaWAN_Helium.setADR(false);
    // Set Data Rate 1 - Max Payload 53 Bytes
    //LoRaWAN.setDataRate(1);
    LoRaWAN_Helium.setDataRate(1);
    // Device IDs and Key
    LoRaWAN_Helium.joinOTAA(appEui,appKey,devEui);
    //LoRaWAN.joinOTAA(appEui, appKey, devEui);

    Serial.println("JOIN( )");
}

void loop( void )
{
    //if (LoRaWAN.joined() && !LoRaWAN.busy())

    if (LoRaWAN_Helium.joined() && !LoRaWAN_Helium.busy())
    {
        Serial.print("TRANSMIT( ");
        Serial.print("TimeOnAir: ");
        //Serial.print(LoRaWAN.getTimeOnAir());
        Serialprint(LoRaWAN_Helium.getTimeOnAir());
        Serial.print(", NextTxTime: ");
        //Serial.print(LoRaWAN.getNextTxTime());
        Serial.print(LoRaWAN_Helium.getNextTxTime());
        Serial.print(", MaxPayloadSize: ");
        //Serial.print(LoRaWAN.getMaxPayloadSize());
        Serial.print(LoRaWAN_Helium.getMaxPayLoadSize());
        Serial.print(", DR: ");
        //Serial.print(LoRaWAN.getDataRate());
        Serial.print(LoRaWAN_Helium.getDataRate());
        Serial.print(", TxPower: ");
        //Serial.print(LoRaWAN.getTxPower(), 1);
        Serial.print(LoRaWAN_Helium.getTxPower(), 1);
        Serial.print("dbm, UpLinkCounter: ");
        //Serial.print(LoRaWAN.getUpLinkCounter());
        Serial.print(LoRaWAN_Helium.getUpLinkCounter());
        Serial.print(", DownLinkCounter: ");
        //Serial.print(LoRaWAN.getDownLinkCounter());
        Serial.print(LoRaWAN_Helium.getDownLinkCounter());
        Serial.println(" )");
        // Send Packet
        LoRaWAN_Helium.sendPacket(1,payload, sizeof(payload));
        //LoRaWAN.sendPacket(1, payload, sizeof(payload));
    }

    delay(20000); //20 Seconds
}
