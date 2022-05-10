class Enemy extends MovingObject {

  float angle = -PI/4;
  int dir = 1;
  boolean stunt = false;
  int stuntTimer = 180;
  int tileWidth = 96;
  int tileHeight = 112;
  PImage[] idle = new PImage[8];
  int currImageIndex = 0;
  int isRight = -1;

  Enemy(PVector position, PVector velocity) {
    super(position, velocity);
    health = 5;
    charWidth = 50;
    charHeight = 50;
    PImage sheet = loadImage("skull.png");
    for (int i=0; i<8; i++) {
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
      idle[i] = tile;
    }
  }

  void update() {
    super.update();
    drawCharacter();

    if (vel.x > 0) {
      isRight = -1;
    } else {
      isRight = 1;
    }
    if (frameCount % 6 == 0) {
      currImageIndex ++;
      if (currImageIndex>7) {
        currImageIndex = 0;
      }
    }
    if (this.hitCharacter(player) && isAlive) {
      if (player.hitTimer<=0) {
        player.decreaseHealth(1);
        if (player.health <= 0 ) {
          player.dead();
        }
        player.hitTimer=30;
      }
    }

    for (int i=0; i<enemies.size(); i++) {
      Enemy e=enemies.get(i);        
      if (e != this && this.hitCharacter(e) && e instanceof BiggerEnemy == false && this instanceof BiggerEnemy == false && state != ROOM_ONE) {
        enemies.remove(e);
        enemies.add(new BiggerEnemy(this.pos, this.vel));
        enemies.remove(this);
      }
    }
  }

  void moveCharacter() {
    if (!stunt) {
      pos.add(vel);
      angle += 0.04 * dir;
      if (random(0, 16)<1) {
        dir*=-1;
      }
      vel.set(0.5*cos(angle), 0.5*sin(angle));
      vel.mult(5);
    } else {
      stuntTimer--;
      if (stuntTimer<0) {
        stuntTimer = 180;
        stunt = false;
      }
    }
  }

  void drawCharacter() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(10);
    scale(isRight, 1);
    image(idle[currImageIndex], -tileWidth/2, -tileHeight/2, tileWidth, tileHeight);
    popMatrix();
  }
}
