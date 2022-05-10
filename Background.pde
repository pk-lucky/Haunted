class Background {
  PImage img;
  int repeatX;
  int repeatY;

  Background(PImage img) {
    this.img = img;
    repeatX=(((int)width/img.width)+1)*2; 
    repeatY=(((int)height/img.height)+1)*2;
  }

  void drawMe() {
    image(img, 0, 0);
  }
}
