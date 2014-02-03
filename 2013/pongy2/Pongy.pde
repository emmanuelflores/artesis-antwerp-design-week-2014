class Pongy {
  //variables
  float posX, posY;
  float velX, velY;
  float accX, accY;
  float r;
  float resistance;
  float previousX, previousY;
  //constr
  Pongy() {//empty constructor
    posX = width/2;
    posY = height/2;
    previousX = posX;
    previousY = posY;
    resistance = 0.95;
    r = 20;
  }
  
  Pongy(float resistance){
    this.resistance = resistance;
    posX = width/2;
    posY = height/2;
    previousX = posX;
    previousY = posY;
    r = 20;
  }
  
  //methods
  void move() {
    float step = 2;
    accX = random(-step, step);
    accY = random(-step, step);

    velX +=accX;
    velY +=accY;
    velX *=resistance;
    velY *=resistance;

    posX +=velX;
    posY +=velY;
  }

  void collision() {

    if (posX < r) {
      posX = r;
      velX *=-1;
    }

    if (posX > width - r) {
      posX = width - r;
      velX *=-1;
    }

    if (posY < r) {
      posY =r;
      velY *=-1;
    }

    if (posY > height - r) {
      posY = height - r;
      velY *=-1;
    }
  }

  void render() {
    line(posX,posY,previousX,previousY);
    previousX = posX;
    previousY = posY;
  }
}

