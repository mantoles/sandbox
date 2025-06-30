#define CFG_us915 1

#include <ttn-otta/ttn-otta.ino>

//include

//#include

#define SensorPin A2

int sensorValue = -1;

// Pin mapping – set your pin numbers here. These are for the Dragino shield.

const lmic_pinmap lmic_pins = {

    .nss = 10,

    .rxtx = LMIC_UNUSED_PIN,

    .rst = 9,

    .dio = {2, 6, 7},

};

 / Insert Device EUI here

static const u1_t PROGMEM DEVEUI[8] = ;

void os_getDevEui (u1_t* buf) { memcpy_P(buf, DEVEUI, 8);}

 

// Insert Application EUI here

static const u1_t PROGMEM APPEUI[8] = ;

void os_getArtEui (u1_t* buf) { memcpy_P(buf, APPEUI, 8);}

 

// Insert App Key here

static const u1_t PROGMEM APPKEY[16] = ;

void os_getDevKey (u1_t* buf) {  memcpy_P(buf, APPKEY, 16);}
 const unsigned TX_INTERVAL = 150;

void do_send(osjob_t* j){

    // Check if there is not a current TX/RX job running

    if (LMIC.opmode & OP_TXRXPEND) {

        Serial.println(F("OP_TXRXPEND, not sending"));

    } else {

        // Prepare upstream data transmission at the next possible time.

        sensorValue = analogRead(SensorPin);

        Serial.println("Reading is: ");

        Serial.println(sensorValue);

        // int -> byte array

        byte payload[2];

        payload[0] = lowByte(sensorValue);

        payload[1] = highByte(sensorValue);

        // transmit packet at the next available slot. The parameters are

        // - FPort, the port used to send the packet – port 1

        // - the payload to send

        // - the size of the payload

        // - if we want an acknowledgement (ack), costing 1 downlink message, 0 means we do not want an ack

        LMIC_setTxData2(1, payload, sizeof(payload), 0);

        Serial.println(F("Payload queued"));

    }

}

static osjob_t sendjob;

void onEvent (ev_t ev) {

    switch(ev) {

        case EV_JOINING:

            Serial.println("EV_JOINING");

            break;

        case EV_JOINED:

            Serial.println("EV_JOINED");

            // We will disable link check mode, this is used to periodically verify network connectivity, which we do not need in this tutorial

            LMIC_setLinkCheckMode(0);

            break;

        case EV_JOIN_FAILED:

            Serial.println("EV_JOIN_FAILED");

            break;

        case EV_REJOIN_FAILED:

            Serial.println("EV_REJOIN_FAILED");

            break;

        case EV_TXCOMPLETE:

            Serial.println("EV_TXCOMPLETE");

            // Schedule next transmission

            os_setTimedCallback(&sendjob, os_getTime() + sec2osticks(TX_INTERVAL), do_send);

            break;

         default:

            break;

    }

}

void setup() {

    Serial.begin(9600);

    Serial.println(F("Starting"));

    // Initalizes the LIMIC library,

    os_init();

    // Resets the MAC state – this removes sessions, meaning the device must repeat the join process each time it is started.

    LMIC_reset();

    // Let LMIC compensate for an inaccurate clock

    LMIC_setClockError(MAX_CLOCK_ERROR * 1 / 100);

    // Disable link check validation – this is used to periodically verify network connectivity. Not needed in this tutorial.

    LMIC_setLinkCheckMode(0);

    // Set data rate to Spreading Factor 7 and transmit power to 14 dBi for uplinks

    LMIC_setDrTxpow(DR_SF7, 14);

    // Start job

    do_send(&sendjob);

}

 

void loop() {

    os_runloop_once();

}
