class Player extends MovingObject {

  float damp = 0.5;
  int hitTimer, randomTimer;
  int hauntedTimer = 400;
  int fireDegree = 0;
  int healthTimer = 60;
  int explosionTimer = 60;
  int dashTimer = 60;
  boolean isHaunted;
  int MAX_HEALTH = 10;

  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  PImage[] idle = new PImage[5];
  PImage[] run = new PImage[6];

  int tileWidth=48;
  int tileHeight=48;

  int index1 = 0;
  int index2 = 0;

  int isRight = 1;



  Player(PVector position, PVector velocity) {
    super(position, velocity);
    health = 10;
    hitTimer = 60;
    randomTimer = 0;
    isHaunted = false;

    PImage sheet1 = loadImage("Gunner_Black_Idle.png");
    for (int i=0; i<5; i++) {
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet1, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
      idle[i] = tile;
    }
    PImage sheet2 = loadImage("Gunner_Black_Run.png");
    for (int i=0; i<6; i++) {
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet2, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
      run[i] = tile;
    }
  }

  void update() {
    super.update();

    checkBullets();

    if (frameCount % 6 == 0) {
      if (left || right || up || down) {
        index1=0;
        index2++;
        if (index2>5) {
          index2 = 0;
        }
      } else {
        index2=0;
        index1++;
        if (index1>4) {
          index1 = 0;
        }
      }
    }

    if (vel.x>0) {
      isRight = 1;
    } else {
      isRight = -1;
    }
    if (isHaunted) {
      if (health<10 && healthTimer == 0) {
        health++;
        healthTimer = 60;
      }
      healthTimer--;
      player.randomFire();
      hauntedTimer--;
      if (hauntedTimer == 0) {
        fireDegree = 0;
        isHaunted = false;
        hauntedTimer = 600;
      }
    }

    if (isAlive) {
      dashTimer--;
      if (hitTimer>0) {
        hitTimer--;
      }
    } else {
      state = LOST;
    }
  }

  void moveCharacter() {
    super.moveCharacter();
    vel.mult(damp);
  }

  void drawCharacter() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(100);
    scale(isRight, 1);
    if (left || right || up || down) {
      running.play();
      image(run[index2], -tileWidth, -tileHeight, 2*tileWidth, 2*tileHeight);
    } else {
      running.play(0);
      running.pause();
      image(idle[index1], -tileWidth, -tileHeight, 2*tileWidth, 2*tileHeight);
    }
    popMatrix();
  }

  void accelerate(PVector acc) {
    vel.add(acc);
  }

  void fire() {
    float angle = atan2(mouseY - pos.y, mouseX - pos.x);
    PVector vel = PVector.fromAngle(angle);
    vel.mult(20);
    bullets.add(new Bullet(new PVector(pos.x, pos.y), vel));
    shoot.play(0);
  }

  void randomFire() {
    shoot.play(0);
    PVector vel1 = PVector.fromAngle(radians(fireDegree));
    PVector vel2 = PVector.fromAngle(radians(fireDegree + 90));
    PVector vel3 = PVector.fromAngle(radians(fireDegree + 180));
    PVector vel4 = PVector.fromAngle(radians(fireDegree + 270));
    fireDegree++;
    vel1.mult(20);
    vel2.mult(20);
    vel3.mult(20);
    vel4.mult(20);
    if (randomTimer==5) {
      bullets.add(new Bullet(new PVector(pos.x, pos.y), vel1));
      bullets.add(new Bullet(new PVector(pos.x, pos.y), vel2));
      bullets.add(new Bullet(new PVector(pos.x, pos.y), vel3));
      bullets.add(new Bullet(new PVector(pos.x, pos.y), vel4));
      randomTimer=0;
    } else {
      randomTimer++;
    }
  }

  void checkBullets() {
    for (int i=0; i<bullets.size(); i++) {
      Bullet bullet = bullets.get(i);
      bullet.update();
      bullet.drawCharacter();

      for (int j=0; j<enemies.size(); j++) {
        Enemy e = enemies.get(j);
        if (bullet.hitCharacter(e)) {
          bullet.isAlive = false;
          e.decreaseHealth(1);
          if (e.health<=0) {
            if (ghostAlive || player.isHaunted) {
              if (e instanceof BiggerEnemy) {
                enemies.add(new Enemy (e.pos, new PVector(random(-5, 5), random(-5, 5))));
              } else {
                hpPickup.add(new HealthPU(e.pos));
              }
            }
            if (!ghostAlive && !player.isHaunted && enemies.size()!= 0) {
              ghostSound.play(0);
              ghostAlive = true;
              ghost.add(new Ghost(e.pos, e.vel));
            }
            score++;
            enemies.remove(e);
          }
        }
      }

      for (int j=0; j<blocks.size(); j++) {
        Block b = blocks.get(j);
        if (bullet.hitBlock(b)) {
          bullet.isAlive = false;
          b.health--;
          b.isShaking = true;
          if (b.health<=0) {
            blocks.remove(b);
          }
        }
      }

      if (bullet.hitCharacter(wife)) {
        bullet.isAlive = false;
        wife.decreaseHealth(1);
        if (wife.health<=0) {
          player.health = 0;
          player.isAlive = false;
        }
      }
      if (!bullet.isAlive) bullets.remove(i);
    }
  }

  void explode() {
    for (int i=0; i<enemies.size(); i++) {
      Enemy e=enemies.get(i);
      if (abs(pos.x - e.pos.x) < charWidth/2 + e.charWidth/2 + 50 && abs(pos.y - e.pos.y) < charHeight/2 + e.charHeight/2 + 50) {
        e.stunt = true;
      }
    }
  }

  void dash() {
    if (dashTimer <=0 && level>2) {
      dash.play(0);
      accelerate(vel.mult(7));
      dashTimer = 60;
    }
  }

  void dead() {
    isAlive = false;
    state = LOST;
  }

  void drawHealthBar() {
    pushMatrix();
    translate(40, 10);
    noStroke();
    fill(255, 0, 0);
    float percent=(float) health/ MAX_HEALTH;
    rect(0, 0, 500*percent, 10);
    popMatrix();
  }
}
