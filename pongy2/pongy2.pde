Pongy mustafa;

Pongy[] harryPongy;

void setup() {
  size(300, 300);
  background(255);

  //mustafa = new Pongy();
  harryPongy = new Pongy[3];

  for (int i=0;i<harryPongy.length;i++) {
    float rv = random(0.9f, 0.99f);
    harryPongy[i] = new Pongy(rv);
  }
}

void draw() {
  //  mustafa.move();
  //  mustafa.collision();
  //  mustafa.render();

  for (int i=0;i<harryPongy.length;i++) {
    harryPongy[i].move();
    harryPongy[i].collision();
    harryPongy[i].render();
  }
}

