float value, value2;//variables
float nonSenseValue;
float _x;
float _y;

void setup() {
  size(500, 500);
  background(100, 100, 100);
  frameRate(30);
  value = 50;
  
  sayHello();
  
  _x = width/2;
  _y = height/2;
}


void draw() {
  int _r = (int)random(0,255);
  int _g = (int)random(0,255);
  int _b = (int)random(0,255);
  //background(_r,_g,_b);
  background(255,255,255);
  value = random(40, 100);
  value2 = random(100, 200);
  frameRate(20);
  //float x = random(0,width);
  //float y = random(0,height);
  float xWalk = random(-2,2);
  float yWalk = random(-2,2);
  _x +=xWalk;//_x = _x + xWalk;
  _y +=yWalk;
  ellipse(_x,_y, value, value);
            frameRate(60);
  ellipse(width-100, height-100, value2, value2);
  
  
  drawingCircle();
}

void sayHello(){
  println("hola mundo");
}

//this is a comment which will be ignored
//this below is a function
void drawingCircle(){
  float value = random(200,300);
  int _r = (int)random(0,255);
  int _g = (int)random(0,255);
  int _b = (int)random(0,255);
  fill(_r,_g,_b);
  ellipse(100,100,value,value); 
}



