/*
  Test the different Button methods: pressed, released, held
  and getSwitch. 
  
  modified in by Matteo Loglio on 6/7/13
*/

#include <TinkerKit.h>

TKButton btn1(I1);
TKButton btn2(I2);
TKButton btn3(I3);

int songIndex;

void setup()
{ 
  Serial.begin(9600); 
}

void loop()
{

    boolean TF1 = false;
    boolean TF2 = false;
    boolean TF3 = false;
    
    if (btn1.held()){
      TF1 = true;
    }
     else {
     TF1 = false;
     }
     
   if (btn2.held()){
      TF2 = true;
    }
     else {
     TF2 = false;
     }
   if (btn3.held()){
      TF3 = true;
    }
     else {
     TF3 = false;
     }
     
     
  if (TF1 == true && TF2==false && TF3==false){
    songIndex = 1;
    Serial.println(songIndex);
  }
   if (TF2 == true && TF1==false && TF3==false){
    songIndex = 2;
    Serial.println(songIndex);
  }
   if (TF3 == true && TF1==false && TF2==false){
    songIndex = 3;
    Serial.println(songIndex);
  }
  if (TF3 == false && TF1==true && TF2==true){
    songIndex = 4;
    Serial.println(songIndex);
  }
  if (TF3 ==true && TF1==true && TF2==false){
    songIndex = 5;
    Serial.println(songIndex);
  }
  if (TF3 ==true && TF1==false && TF2==true){
    songIndex = 6;
    Serial.println(songIndex);
  }
  if (TF3 ==true && TF1==true && TF2==true){
    songIndex = 7;
    Serial.println(songIndex);
  }
 

  delay(50);  
     
}



