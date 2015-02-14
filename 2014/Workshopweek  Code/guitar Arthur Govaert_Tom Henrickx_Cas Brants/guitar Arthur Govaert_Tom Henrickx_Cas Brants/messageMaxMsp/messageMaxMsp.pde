import oscP5.*;
import netP5.*;
 
OscP5 oscP5;
NetAddress myRemoteLocation;
 
void setup() {
  size(400,400);
 
  // start oscP5, telling it to listen for incoming messages at port 5001 */
  oscP5 = new OscP5(this,5001);
 
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("127.0.0.1",5001);
}
 
void draw()
{
 sendMessage();
}
 
void sendMessage() {  
  // create an osc message
  OscMessage myMessage = new OscMessage("/test");
   int ran = (int) random(0,100);
  myMessage.add(ran); // add an int to the osc message
  myMessage.add(12.34); // add a float to the osc message 
  myMessage.add("some text!"); // add a string to the osc message
 
  // send the message
  oscP5.send(myMessage, myRemoteLocation); 
}
