unsigned long currentMicros;
unsigned long previousMicros;
unsigned long elapsedTime;

// Initial time to start, 10:00:00 with 90 years, 240 days. (around start of May),
// adjust as needed.

// Get this working, then more display code if needed

byte hundredths;
byte tenths;
byte secondsOnes = 0;
byte oldsecondsOnes;
byte secondsTens = 0;
byte minutesOnes = 0;
byte minutesTens = 0;
byte hoursOnes= 0;
byte hoursTens = 1;
int days = 240; //
byte years = 90;
void setup(){

Serial.begin(115200); // make serial monitor match
Serial.println (Setup Done");
}

void loop(){

currentMicros = micros();

// how long's it been?
elapsedTime = currentMicros - previousMicros;
if ( elapsedTime >=10000UL){  // 0.01 second passed? Update the timers
previousMicros  = previousMicros + 10000UL;
hundredths = hundredths+1;
if (hundredths == 10){
    hundredths = 0;
    tenths = tenths +1;
    if (tenths == 10){
        tenths = 0;
        secondsOnes = secondsOnes + 1;
        if (secondsOnes == 10){
            secondsOnes = 0;
            secondsTens = secondsTens +1;
            if (secondsTens == 6){ 
                secondsTens = 0;
                minutesOnes =  minutesOnes + 1;
                if (minutesOnes == 10){
                    minutesOnes = 0;
                    minutesTens = minutesTens +1;
                    if (minutesTens == 6){
                        minutesTens = 0;
                        hoursOnes = hoursOns + 1;
                          if (hoursOnes == 10){
                              hoursOnes = 0;
                              hoursTens = hoursTens +1;
                                if ( (hoursTens == 2) && (hoursOnes == 4){
                                      hoursOnes = 0;
                                      hoursTens = 0;
                                      if (days>1){
                                          days = days-1;
                                           }
                                      else {
                                         days = 365;
                                         years = years - 1;
                                         }
                                    
                                      } // 24 hr rollover check
                                   } //hoursTens rollover check
                              } // hoursOnes rollover check
                        } // minutesTens rollover check
                     } // minutesOnes rollover check
                 } // secondsTens rollover check
              } // secondsOnes rollover check
          } // tenths rollover check
       } // hundredths rollover check
} // hundredths passing check

if (oldSecondsOnes != secondsOnes){  // show the elapsed time
oldSecondsOnes = secondsOnes;
Serial.print (years);
Serial.print(":");
Serial.print(days);
Serial.print(":");
Serial.print(hoursTens);
Serial.print(hoursOnes);
Serial.print(":");
Serial.print(minutesTens);
Serial.print(minutesOnes);
Serial.print(":");
Serial.print(secondsTens);
Serial.println(secondsOnes);

} // end one second check

} // end loop