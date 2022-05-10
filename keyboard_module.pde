boolean up, down, left, right;

void keyPressed() {
  if (key==CODED) {
    if (keyCode == LEFT)  left=true;
    if (keyCode == RIGHT) right=true;
    if (keyCode == UP) up=true;
    if (keyCode == DOWN) down=true;
    if (keyCode == SHIFT) player.dash();
  }
}

void keyReleased() {
  if (key==CODED) {
    if (keyCode == LEFT)  left=false;
    if (keyCode == RIGHT) right=false;
    if (keyCode == UP) up=false;
    if (keyCode == DOWN) down=false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT && player.isHaunted == false) {
    player.fire();
  }
  
  if (mouseButton == RIGHT && player.isHaunted == false && state != ROOM_ONE) {
    player.explode();
    explosive.play(0);
  }
}

PVector upAcc = new PVector(0, -2);
PVector downAcc = new PVector(0, 2);
PVector leftAcc = new PVector(-2, 0);
PVector rightAcc = new PVector(2, 0);
