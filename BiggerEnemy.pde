class BiggerEnemy extends Enemy 
{
  float angle;
  ArrayList<Bullet> projectiles = new ArrayList<Bullet>();

  boolean isNear = false;
  int fireTimer = 60;

  PImage[] idle = new PImage[6];
  PImage[] attack = new PImage[11];

  int tileWidth1 = 160;
  int tileWidth2 = 240;
  int tileHeight1 = 144;
  int tileHeight2 = 192;

  int index1 = 0;
  int index2 = 0;

  int isRight = -1;

  int damageTimer  = 300;

  BiggerEnemy(PVector position, PVector velocity) {
    super(position, velocity);
    health = 8;
    charWidth = 70;
    charHeight = 70;

    PImage sheet1 = loadImage("demon-idle.png");
    PImage sheet2 = loadImage("demon-attack.png");
    for (int i=0; i<6; i++) {
      PImage tile = createImage(tileWidth1, tileHeight1, ARGB);
      tile.copy(sheet1, i*tileWidth1, 0, tileWidth1, tileHeight1, 0, 0, tileWidth1, tileHeight1);
      idle[i] = tile;
    }
    for (int i=0; i<11; i++) {
      PImage tile = createImage(tileWidth2, tileHeight2, ARGB);
      tile.copy(sheet2, i*tileWidth2, 0, tileWidth2, tileHeight2, 0, 0, tileWidth2, tileHeight2);
      attack[i] = tile;
    }
  }

  void update() {
    super.update();


    nearPlayer();

    if (vel.x > 0) {
      isRight = -1;
    } else {
      isRight = 1;
    }

    angle = atan2(player.pos.y - pos.y, player.pos.x - pos.x);
    vel = PVector.fromAngle(angle);

    if (isAlive && player.isAlive && isNear) {
      index1 = 0;
      damageTimer--;
      if (damageTimer<=0) {
        roar.play(0);
        player.decreaseHealth(2);
        damageTimer = 300;
        if (player.health<=0) {
          player.dead();
        }
      }
      if (frameCount % 6 == 0) {
        index2 ++;
        if (index2>10) {
          index2 = 0;
        }
      }
      fireTimer--;
      if (fireTimer<=0) {
        fireTimer = 60;
        isNear = false;
        index2 = 0;
      }
    } else {
      if (frameCount % 6 == 0) {
        index1 ++;
        if (index1>5) {
          index1 = 0;
        }
      }
    }
  }

  void moveCharacter() {
    if (!stunt) {
      pos.add(vel.mult(3));
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
    scale(isRight, 1);
    if (isNear) {
      image(attack[index2], -tileWidth2/2, -tileHeight2/2, tileWidth2, tileHeight2);
    } else {
      image(idle[index1], -tileWidth1/2, -tileHeight1/2, tileWidth1, tileHeight1);
    }
    popMatrix();
  }

  void nearPlayer() {
    if (abs(pos.x - player.pos.x) < charWidth/2 + player.charWidth/2 + 100 && abs(pos.y - player.pos.y) < charHeight/2 + player.charHeight/2 + 100) {
      isNear = true;
    }
  }
}
