class MovingObject {
  PVector pos, vel;
  float charWidth, charHeight;
  int health;
  boolean isAlive;

  MovingObject(PVector position, PVector velocity) {
    pos = position;
    vel = velocity;

    charWidth = 100;
    charHeight = 100;
    health = 1;
    isAlive = true;
  }

  void update() {
    moveCharacter();
    checkWall();
  }

  void moveCharacter() {
    pos.add(vel);
  }

  void checkWall() {
    if (pos.x+charWidth <0) {
      pos.x = width + charWidth/2;
    }
    if (pos.x-charWidth > width) {
      pos.x = 0 - charWidth/2;
    }
    if (pos.y+charHeight <0) {
      pos.y = height + charHeight/2;
    }
    if (pos.y-charHeight > height) {
      pos.y = 0 - charHeight/2;
    }
  }
  
  

  void drawCharacter() {
    pushMatrix();
    noFill();
    translate(pos.x, pos.y);
    ellipse(0, 0, 100, 100);
    popMatrix();
  }

  boolean hitCharacter(MovingObject hitBy) {
    if (abs(pos.x - hitBy.pos.x) < charWidth/2 + hitBy.charWidth/2 && abs(pos.y - hitBy.pos.y) < charHeight/2 + hitBy.charHeight/2) {
      return true;
    }
    return false;
  }

  void decreaseHealth(int value) {
    health -= value;
  }
}
