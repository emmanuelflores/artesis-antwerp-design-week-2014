//tinkerkit example for light sensor

#include <TinkerKit.h>

TKLightSensor ldr(I0);	//create the "ldr" object on port I0

TKLed led(O0);		//create the "led" object on port O0

void setup() {
  // initialize serial communications at 9600 bps
  Serial.begin(9600);
}

void loop() {
  // store the ldr values into a variable called brightnessVal
  int brightnessVal = ldr.read();            

  // set the led brightness
  led.brightness(brightnessVal);       
  
  //to have it at full brightness
  //when it's dark, uncomment this line:
  //led.brightness(1023 - brightnessVal);

  // print the results to the serial monitor:
  Serial.print("brightness = " );                      
  Serial.println(brightnessVal);      


  // wait 10 milliseconds before the next loop
  delay(10);                    
}
