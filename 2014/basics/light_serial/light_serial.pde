import processing.serial.*;
import cc.arduino.*;
import com.tinkerkit.*;

Arduino arduino;

//declare the light sensor
TKLightSensor ldr;

void setup() {  

  //size(256,256);
  size(500,500);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[4], 57600);    
  
  //for every tinkerkit component we have to pass
  //the arduino and the port
  ldr = new TKLightSensor(arduino, TK.I0);
}

void draw() {

 //read the light sensor
 float val = ldr.read();
 
 //map the ldr values (0,1023) on the grayscale (0,255)
 val = map(val, 0, 1023, 0, 255);
  
 //set the background according to the light sensor 
 background(val);
 
 println(val);
 
 float ratio = ldr.read();
 ratio = map(ratio,0,100,0,200);
 
// noFill();
// stroke(204, 102, 0);
// ellipse(width*0.5,height*0.5,ratio,ratio);
  
//  for(int i=0;i<20;i++){
//   noFill();
//   int _color = 10;
//  stroke(204, 102, 0);
//  ellipse(width*0.5,height*0.5,i*ratio,i*ratio);
//  }
}
