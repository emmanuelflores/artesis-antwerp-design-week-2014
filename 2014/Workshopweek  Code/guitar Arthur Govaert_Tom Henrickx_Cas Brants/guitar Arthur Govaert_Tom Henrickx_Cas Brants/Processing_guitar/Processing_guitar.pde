import processing.serial.*;
import cc.arduino.*;
import com.tinkerkit.*;
import oscP5.*;
import netP5.*;


 
OscP5 oscP5;
NetAddress myRemoteLocation;

Arduino arduino;

//declare the light sensor
TKButton btn1;
TKButton btn2;
TKButton btn3;
TKPotentiometer pot;
TKPotentiometer pot2;
TKLightSensor ldr;
TKHallSensor hs;
int songIndex=1;
int soundIndex=1;

void setup() {  
  
  // start oscP5, telling it to listen for incoming messages at port 5001 */
  oscP5 = new OscP5(this,5001);
 
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("127.0.0.1",5001);

  //size(256,256);
  size(500,500);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);    
  
  //for every tinkerkit component we have to pass
  //the arduino and the port
  btn1 = new TKButton(arduino, TK.I1);
  btn2 = new TKButton(arduino, TK.I2);
  btn3 = new TKButton(arduino, TK.I3);
  pot = new TKPotentiometer(arduino, TK.I4);
  pot2 = new TKPotentiometer(arduino, TK.I5);
  ldr = new TKLightSensor(arduino, TK.I0);
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
  if (TF3 ==false && TF1==false && TF2==false){
    songIndex = 0;
    println(songIndex);
  }
  
  //get the potentiometer values
  float PotVal = pot.read();
  float PotVal2 = pot2.read();
  int Play = 0;
  float LightVal = ldr.read()/10*1.5; 
  
    
  
  //print the potentiometer values
  println(PotVal/1000);
  println(PotVal2);
  println(Play);
  println(LightVal);
  
  
  if (PotVal2>850){
  soundIndex=3;
  println(soundIndex);
  }
  
   if (PotVal2>150 && PotVal2<850){
  soundIndex=2;
  println(soundIndex);
  }
  
   if (PotVal2<150){
  soundIndex=1;
  println(soundIndex);
  }
  
  
  
  //read the light sensor
 
 
  
 
 OscMessage myMessage = new OscMessage("/songIndex");
 OscMessage myMessagePot = new OscMessage("/potentie");
 OscMessage myMessageLight = new OscMessage("/light");
  OscMessage myMessagePot2 = new OscMessage("/potentie2");
 
 myMessage.add(songIndex-1); // add an int to the osc message
 myMessagePot.add(PotVal/1000); // add an int to the osc message
 myMessagePot2.add(soundIndex); // add an int to the osc message
 myMessageLight.add(LightVal); // add an int to the osc message
 
  // send the message
  oscP5.send(myMessage, myRemoteLocation);
  oscP5.send(myMessagePot, myRemoteLocation);
  oscP5.send(myMessagePot2, myRemoteLocation);
  oscP5.send(myMessageLight, myRemoteLocation);

  delay(50);  
}
