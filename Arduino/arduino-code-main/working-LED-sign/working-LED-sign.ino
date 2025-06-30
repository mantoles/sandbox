#define VERSION “0.03”

#include <Adafruit_NeoPixel.h>
#include <fontALL.h> // Use the TVout fonts for this test.
#include <LEDSign.h>

// If defined, this will print out the banner text to the Serial console.

//#define DEBUG

/*—————————————————————————*/
// CONFIGURATION
/*—————————————————————————*/
// Adafruit NeoPixel library configuration.
#define PIN 3

// LED strip configuration.
// Example: 7 1m 60-LED strips (similar to BetaBrite 80×7 display).
#define LEDSTRIPS 1
#define LEDSPERSTRIP 256
#define LEDSPERROW 32

// Example: 2 1m 60-LED strips, spiraled with 20 per row. (6 rows).
//#define LEDSTRIPS 2
//#define LEDSPERSTRIP 60
//#define LEDSPERROW 20

// LED strip layout.
// Where is LED 0? TOPLEFT, TOPRIGHT, BOTTOMLEFT, or BOTTOMRIGHT
#define LAYOUTSTART TOPLEFT

// If the strips run one direction, then reverse for the next row,
// use ZIGZAG, else use STRAIGHT.
#define LAYOUTMODE STRAIGHT

int SCROLLSPEED = 100; // 100ms (1000=1 second)

// If defined, a strip.setBrightness(x) will be done. I use this so more
// LEDs can be powered off an Arduino supply if they are all very dim/low
// power. You should be using a proper power supply, however!
#define LEDBRIGHTNESS 30

// Specify which font to use. (These examples are for the TVout fonts.)
const unsigned char *font = font4x6;
//const unsigned char *font = font6x8;
//const unsigned char *font = font8x8; // Blank row on top. Bad font.
//const unsigned char *font = font8x8ext;

// Set these defines to match the font data, or, if using the TVout
// fonts, these values can be read from the first three bytes of
// the file (and FONTDATAOFFSET is set to skip those first three
// bytes).
#define FONTWIDTH (pgm_read_byte_near(&font[0]))
#define FONTHEIGHT (pgm_read_byte_near(&font[1]))
#define FONTSTARTCHAR (pgm_read_byte_near(&font[2]))
#define FONTDATAOFFSET 3

/*—————————————————————————*/
// Definitions
/*—————————————————————————*/
// These defines are calculated.
#define LEDS (LEDSPERSTRIP*LEDSTRIPS)
#define ROWS (LEDS/LEDSPERROW)

// Longest message we can display.
#define MAXMSGLEN 80

// Parameter 1 = number of pixels in strip
// Parameter 2 = Arduino pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
// NEO_KHZ800 800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
// NEO_KHZ400 400 KHz (classic ‘v1’ (not v2) FLORA pixels, WS2811 drivers)
// NEO_GRB Pixels are wired for GRB bitstream (most NeoPixel products)
// NEO_RGB Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(LEDS, PIN, NEO_GRB + NEO_KHZ800);

// IMPORTANT: To reduce NeoPixel burnout risk, add 1000 uF capacitor across
// pixel power leads, add 300 – 500 Ohm resistor on first pixel’s data input
// and minimize distance between Arduino and first pixel. Avoid connecting
// on a live circuit…if you must, connect GND first.

/*—————————————————————————*/
// For the Adafruit LPN8806/NeoPixel libraries, three bytes of RAM are
// used for each pixel. This crashes the Arduino, so we could easily do a
// simple sanity check before initializing things… To do this, we’d
// need to make the “strip” a global (which is is) and initialize it after
// the check (if the check was successful).
#if (LEDS*3>2000)
#error USING UP OVER 2000 BYTES OF RAM!
#endif

/*—————————————————————————*/
// A debug Serial.print()/Serial.println() macro.
//#if defined(DEBUG)
//#define DEBUG_PRINT(…) Serial.print(__VA_ARGS__)
//#define DEBUG_PRINTLN(…) Serial.println(__VA_ARGS__)
//#else // If not debugging, it will not be included.
//#define DEBUG_PRINT(…)
//#define DEBUG_PRINTLN(…)
//#endif
/*—————————————————————————*/
// FUNCTIONS
/*—————————————————————————*/
String incomingByte;
int Red1;
int Grn1;
int Blu1;
char message[MAXMSGLEN];
uint8_t msgLen;

void setup()
{
#if defined(LEDBRIGHTNESS)
strip.setBrightness(LEDBRIGHTNESS);
#endif
Serial.begin(9600);

Serial.print(F(“LEDSign “));
Serial.print(VERSION);
Serial.println(F(” by Allen C. Huffman (alsplace@pobox.com)”));
DEBUG_PRINTLN(F(“DEBUG MODE”));

Serial.print(F(“Total LEDs : “));
Serial.println(LEDS);

Serial.print(F(“LEDs per row : “));
Serial.println(LEDSPERROW);

Serial.print(F(“Rows : “));
Serial.println(ROWS);

Serial.print(F(“Free memory : “));
Serial.println(freeRam());
Serial.println(“Enter message \”|\” Then colour R,G,B,(Scroll Speed in Milliseconds): “);
Serial.flush();
// Start up the LED strip
strip.begin();

// Update the strip, to start they are all ‘off’
strip.show();
} // end of setup()

void loop() {
// send data only when you receive data:
if (Serial.available() > 2) {
for( int i = 0; i 0)
{
uint8_t fontWidth, fontHeight, fontStartChar;
uint8_t letter, fontByte, fontBit;
uint8_t letterOffset;
uint8_t row, col;
uint8_t offset;
char ch;
uint8_t layoutStart, layoutMode;
uint8_t colDir, rowDir;
uint8_t colOffset, rowOffset;

layoutStart = LAYOUTSTART;
layoutMode = LAYOUTMODE;

// If LED 0 starts at the bottom, we need to invert the rows when we
// display the message.
if (layoutStart==TOPLEFT || layoutStart==TOPRIGHT)
{
rowDir = DOWN;
}
else
{
rowDir = UP;
}

// If we start from the right side, we will be going backwards.
if (layoutStart==TOPLEFT || layoutStart==BOTTOMLEFT)
{
colDir = RIGHT;
}
else
{
colDir = LEFT;
}

fontWidth = FONTWIDTH;
fontHeight = FONTHEIGHT;
fontStartChar = FONTSTARTCHAR;

//Serial.print(F(“Font size : “));
//Serial.print(fontWidth);
//Serial.print(F(“x”));
//Serial.println(fontHeight);
//Serial.flush();

// Loop through each letter in the message.
for (letter=0; letter<msgLen; letter++)
{
// Scroll fontWidth pixels for each letter.
for (offset=0; offset<fontWidth; offset++)
// If you comment out the above for loop, and then just set offset
// to 0, the sign will scroll a character at a time.
//offset = 0;
{
// Loop through each row…
for (row=0; row<ROWS && row<fontHeight ; row++)
{
letterOffset = 0;
fontBit = offset;

// If going down (starting at top), we will use the loop row,
// else we will calculate a row that goes backwards.
if (rowDir==DOWN)
{
rowOffset = row;
}
else
{
rowOffset = (fontHeight<ROWS ? fontHeight : ROWS)-1-row;
}

// Now loop through each pixel in the row (column).
for (col=0; col=msgLen)
{
ch = ‘ ‘;
}
else // Otherwise, get the actual letter.
{
ch = message[letter+letterOffset];
}
}
// Get the appropriate byte from the font data.
if (bitRead(pgm_read_byte_near(&font[FONTDATAOFFSET+
(ch-fontStartChar)*fontHeight+rowOffset]),
//(colDir==RIGHT ? 7-fontBit : 7-(fontWidth-1)+fontBit))==1)
//(colDir==LEFT ? 7-fontBit : 7-(fontWidth-1)+fontBit))==1)
7-fontBit)==1)
{
// 1 = set a pixel.
strip.setPixelColor((row*LEDSPERROW)+colOffset,
strip.Color(Red1,Grn1,Blu1));

//DEBUG_PRINT(F(“#”));
}
else
{
// 0 = unset a pixel.
strip.setPixelColor((row*LEDSPERROW)+colOffset, 0);
//DEBUG_PRINT(F(” “));
}

// Move to next bit in the character.
fontBit++;
// If we get to the width of the font, move to the next letter.
if (fontBit >= fontWidth)
{
fontBit = 0;
letterOffset++;
}
} // end of for (col=0; col<LEDSPERROW; col++)

DEBUG_PRINTLN();

// If the LED strips are zig zagged, at the end of each row we
// will reverse the direction.
if (layoutMode==ZIGZAG)
{
// Invert direction.
if (colDir==RIGHT)
{
colDir = LEFT;
}
else
{
colDir = RIGHT;
}
} // end of if (layoutMode==ZIGZAG)
} // end of for (row=0; row<ROWS && row<fontHeight ; row++)
strip.show();

#if defined(DEBUG)
for (uint8_t i=0; i<LEDSPERROW; i++) Serial.print(F("-"));
Serial.println();
#endif
delay(SCROLLSPEED);
} // end of for (offset=0; offset<fontWidth; offset++)
} // end of for (letter=0; letter0)
} // end of loop()

// Simple utility function to return the current free RAM.

#if defined(DEBUG)
          for (uint8_t i=0; i<LEDSPERROW; i++) Serial.print(F("-"));
          Serial.println();
#endif
          delay(SCROLLSPEED);
        } // end of for (offset=0; offset<fontWidth; offset++)
      } // end of for (letter=0; letter<msgLen; letter++)
    } // end of if (msgLen>0)
  } // end of while(1)
} // end of loop()

// Simple utility function to return the current free RAM.
unsigned int freeRam() {
  extern int __heap_start, *__brkval;
  int v;
  return (int) &v - (__brkval == 0 ? (int) &__heap_start : (int) __brkval);
} // end of freeRam()
}
// End of LEDSign
