import com.tinkerkit.*;

import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Gesture.State;

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
LeapMotionP5 leap;

int pos = 0;

color [] colarray = { 
  color(255, 0, 0), color(0, 255, 0), color(255, 145, 0), color(255, 255, 0)
};

String lastGesture = "";

String tt = "Te traag!";
String ts = "Te snel!";
String sg = "Perfect!";


//   these don't seem to work in Processing 1.5.1
//float ttw = textWidth(tt);
//float tsw = textWidth(ts);
//float sgw = textWidth(sg);

int MaxSpeed = 1300;
int MinSpeed = 300;

public void setup() {
  
  noCursor();
  smooth();
  textSize(80);
  size(screen.width/2, screen.height/2);
  background(0);

  arduino = new Arduino(this, Arduino.list()[0], 57600);
  leap = new LeapMotionP5(this);
}


public void draw() {
  //  textSize(100);
  //  background(0);
  for (Hand hand : leap.getHandList()) {
    PVector handPos = leap.getPosition(hand);
    ellipse(handPos.x, handPos.y, 20, 20);
  }
  
  textSize(40);
  text(lastGesture, 50, 50);
}

public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {

    System.out.println("//////////////////////////////////////");
    System.out.println("Speed: " + gesture.speed());
    lastGesture = "Speed: " + gesture.speed() + "\n";


    if (gesture.speed() >=MaxSpeed) {     

      System.out.println(ts);    
      background(colarray[0]);
      textSize(100);
      text(ts, ((screen.width/4)- 200), (screen.height/4));    

    }

    else if (gesture.speed() >=MinSpeed) {

      System.out.println(sg);    
      background(colarray[1]);    
      textSize(120);
      text(sg, ((screen.width/4)- 180), (screen.height/4));

//      delay(3000);
//      background(0);

      //    delay (5000);

      pistondown();
      pistonup();
    }

    else {

      System.out.println(tt);
      background(colarray[2]);
      textSize(100);      
      text(tt, ((screen.width/4)- 200), (screen.height/4));    
    }
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

public void keyPressed() {

  println("Toets ingedrukt");

  if (leap.isEnabled(Type.TYPE_SWIPE)) {
    leap.disableGesture(Type.TYPE_SWIPE);
    lastGesture = "";
  } 
  else {
    leap.enableGesture(Type.TYPE_SWIPE);
    lastGesture = "";
  }
}

public void stop() {
  leap.stop();
}


void pistondown() {

  println ("going down");
  for (pos = 0; pos < 180; pos += 1)  // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    arduino.analogWrite(11, pos);              // tell servo to go to position in variable 'pos' 

    //         println (pos);
    //         text ("going down", (screen.width)-50,50);
    //         text (pos,20,20);
  }
}

void pistonup() {

  println ("going up");    
  for (pos = 180; pos>=1; pos-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    arduino.analogWrite(11, pos);              // tell servo to go to position in variable 'pos' 

    //         println (pos);
    //         text ("going down", (screen.width)-50,50);         
    //         text (pos,20,20);
  }
}

