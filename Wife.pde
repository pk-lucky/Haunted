class Wife extends MovingObject {

  float angle = -PI/4;
  int dir = 1;
  int currImageIndex = 0;
  PImage[] idle = new PImage[6];
  int isRight = 1;
  int imgWidth = 37;
  int imgHeight = 46;
  
  int MAX_HEALTH = 25;

  Wife(PVector position, PVector velocity) {
    super(position, velocity);
    health = 25;
    for (int i=0; i<6; i++) {
      idle[i] = loadImage("woman-walk-"+(i+1)+".png");
    }
  }

  void update() {
    super.update();

    if (vel.x>0) {
      isRight = 1;
    } else {
      isRight = -1;
    }
    if (frameCount % 6 == 0) {
      currImageIndex ++;
      if (currImageIndex>5) {
        currImageIndex = 0;
      }
    }
  }

  void moveCharacter() {
    pos.add(vel);
    angle += 0.04 * dir;
    if (random(0, 16)<1) {
      dir*=-1;
    }
    vel.set(0.5*cos(angle), 0.5*sin(angle));
    vel.mult(10);
  }

  void drawCharacter() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(isRight, 1);
    image(idle[currImageIndex], -imgWidth, -imgHeight, 2*imgWidth, 2*imgHeight);
    popMatrix();
  }
  
  void drawHealthBar() {
    pushMatrix();
    translate(40, 40);
    noStroke();
    fill(0, 0, 255);
    float percent=(float) health/ MAX_HEALTH;
    rect(0, 0, 500*percent, 10);
    popMatrix();
  }
}
