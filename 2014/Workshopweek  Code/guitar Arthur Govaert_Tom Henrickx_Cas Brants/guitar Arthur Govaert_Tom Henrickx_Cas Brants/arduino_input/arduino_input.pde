import processing.serial.*;
import cc.arduino.*;
import com.tinkerkit.*;

Arduino arduino;

//declare the light sensor
TKButton btn1;
TKButton btn2;
TKButton btn3;
int songIndex=1;

void setup() {  

  //size(256,256);
  size(500,500);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);    
  
  //for every tinkerkit component we have to pass
  //the arduino and the port
  btn1 = new TKButton(arduino, TK.I1);
  btn2 = new TKButton(arduino, TK.I2);
  btn3 = new TKButton(arduino, TK.I3);
}

void draw() {
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
    println(songIndex);
  }
   if (TF2 == true && TF1==false && TF3==false){
    songIndex = 2;
    println(songIndex);
  }
   if (TF3 == true && TF1==false && TF2==false){
    songIndex = 3;
    println(songIndex);
  }
  if (TF3 == false && TF1==true && TF2==true){
    songIndex = 4;
    println(songIndex);
  }
  if (TF3 ==true && TF1==true && TF2==false){
    songIndex = 5;
    println(songIndex);
  }
  if (TF3 ==true && TF1==false && TF2==true){
    songIndex = 6;
    println(songIndex);
  }
  if (TF3 ==true && TF1==true && TF2==true){
    songIndex = 7;
    println(songIndex);
  }
 

  delay(50);  
}
