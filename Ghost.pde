class Ghost extends MovingObject {

  int timer;
  float angle;

  int tileWidth = 64;
  int tileHeight1 = 48;
  int tileHeight2 = 80;
  PImage[] ghostImg = new PImage[13];
  int currImageIndex = 0;
  int isRight = -1;

  Ghost(PVector position, PVector velocity) {
    super(position, velocity);
    charWidth = 50;
    charHeight = 50;
    timer = 0;
    PImage sheet1 = loadImage("ghost-appears.png");
    PImage sheet2 = loadImage("ghost-idle.png");
    for (int i=0; i<6; i++) {
      PImage tile = createImage(tileWidth, tileHeight1, ARGB);
      tile.copy(sheet1, i*tileWidth, 0, tileWidth, tileHeight1, 0, 0, tileWidth, tileHeight1);
      ghostImg[i] = tile;
    }
    for (int i=0; i<7; i++) {
      PImage tile = createImage(tileWidth, tileHeight2, ARGB);
      tile.copy(sheet2, i*tileWidth, 0, tileWidth, tileHeight2, 0, 0, tileWidth, tileHeight2);
      ghostImg[i+6] = tile;
    }
  }

  void update() {
    super.update();
    if (frameCount % 6 == 0) {
      currImageIndex ++;
      if (currImageIndex>12) {
        currImageIndex = 6;
      }
    }
    timer++;
    angle = atan2(player.pos.y - pos.y, player.pos.x - pos.x);
    vel = PVector.fromAngle(angle);
    if (vel.x>0) {
      isRight =-1;
    } else {
      isRight = 1;
    }
    if (this.hitCharacter(player)) {
      ghostSound.pause();
      breathe.play(0);
      player.isHaunted = true;
      ghostAlive = false;
      ghost.remove(this);
    }
  }

  void moveCharacter() {
    pos.add(vel.mult(timer/90));
  }

  void drawCharacter() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(isRight* 2 , 2);
    if (currImageIndex>5) {
      image(ghostImg[currImageIndex], -tileWidth/2, -tileHeight2/2, tileWidth, tileHeight2);
    } else {
      image(ghostImg[currImageIndex], -tileWidth/2, -tileHeight1/2, tileWidth, tileHeight1);
    }
    popMatrix();
  }
}
