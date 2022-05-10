class HealthPU {
  PVector position, dim;
  int removeTimer = 300;

  HealthPU(PVector pos) {
    position = pos;
    dim = new PVector(20, 20);
  }

  void update() {
    pickedUp();
    removeTimer--;
    if (removeTimer<=0) {
      removed();
    }
  }
  void drawMe() {
    pushMatrix();
    fill(0, 255, 0);
    translate(position.x, position.y);
    image(potionImg, -dim.x, -dim.y, 2*dim.x, 2*dim.y);
    popMatrix();
  }

  void pickedUp() {
    if (abs(position.x - player.pos.x) < dim.x/2 + player.charWidth/2 && abs(position.y - player.pos.y) < dim.y/2 + player.charWidth/2) {
      player.health++;
      if (wife.health<15) {
        wife.health++;
      }
      healing.play(0);
      hpPickup.remove(this);
    }
  }

  void removed() {
    enemies.add(new Enemy (this.position, new PVector(random(-5, 5), random(-5, 5))));
    hpPickup.remove(this);
  }
}
