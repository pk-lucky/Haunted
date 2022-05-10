class Block {
  PVector pos, dim;
  int health;
  int tileWidth = 128;
  int tileHeight = 128;
  int tileX, tileY;
  PImage tile;
  float noiseScale = 0;
  float a = 0.0;
  int shakeTimer = 5; 
  boolean isShaking;

  Block(PVector position, PVector dimension) {
    pos = position;
    dim = dimension;
    health = 7;
    tileX = (int)random(0, 4);
    tileY = (int)random(0, 8);
    tile = createImage(tileWidth, tileHeight, ARGB);
    tile.copy(blockImg, tileX*tileWidth, tileY*tileHeight, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight );
  }

  void update() {
    if (isShaking) {
      shakeTimer--;
      noiseScale = 5;
      if (shakeTimer <= 0) {
        isShaking = false;
        shakeTimer = 5;
        noiseScale = 0;
      }
    }
  }

  void drawMe() {
    pushMatrix();
    translate(pos.x, pos.y);
    tint(255, 200);
    a+=0.6;
    float x= noise(a)*noiseScale;
    image(tile, (-dim.x/2)+x, (-dim.y/2)+x, dim.x, dim.y);
    popMatrix();
  }
}
