class Bullet extends MovingObject {


  Bullet(PVector position, PVector velocity) {
    super(position, velocity);

    charHeight = charWidth = 10;
  }

  boolean hitBlock(Block b) {
    if (abs(pos.x - b.pos.x) < charWidth/2 + b.dim.x/2 && abs(pos.y - b.pos.y) < charHeight/2 + b.dim.y/2) {
      return true;
    }
    return false;
  }

  void checkWall() {
    if (abs(pos.x-width/2)>width/2 || abs(pos.y-height/2)>height/2) {
      isAlive = false;
    }
  }

  void drawCharacter() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
    image(bulletImg, 0, 0, 20, 20);
    popMatrix();
  }
}
