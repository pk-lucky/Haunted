import controlP5.*;
import ddf.minim.*;

Minim minim;
AudioPlayer shoot, music, healing, ghostSound, breathe, running, dash, explosive, roar;

final String FIRE = "cannon_01.wav";
final String THEME = "SR_Strange_room.wav";
final String HEAL = "heal.wav";
final String GHOST = "Misc_Ghost.wav";
final String BREATHE = "Misc_breath.wav";
final String RUNNING = "Snowrunning2.wav";
final String DASHING = "dash.wav";
final String EXPLOSIVE= "Grenade5Short.wav";
final String ROAR = "mob1atk.wav";


ControlP5 controlP5;
Button play;
Button replay;


Player player;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
Wife wife;
ArrayList<Ghost> ghost = new ArrayList<Ghost>();
ArrayList<HealthPU> hpPickup = new ArrayList<HealthPU>();


int charWidth = 100;
PVector startPos = new PVector(500, 400);
int numEnemies = 5;
boolean ghostAlive = false;
int transitionTimer = 90;

int state;

int level = 1;

ArrayList<Block> blocks = new ArrayList<Block>();
static final int TILE_SIZE = 50; 

final int INTRO = 0;
final int ROOM_ONE = 1;
final int ROOM_TWO = 2;
final int ROOM_THREE = 3;
final int TRANSITION = 4;
final int WON = 5;
final int LOST = 6;

static final int TILE_EMPTY = 0;
static final int TILE_SOLID = 1;


Background bg1;
Background bg2;
Background bg3;
PImage blockImg;
PImage bulletImg;
PImage potionImg;
PImage heartImg;
PImage blueHeartImg;

int enemyNumTimer = 600;


int score = 0;

int[][] map = 
  {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0}, 
  {0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, 
  {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
};

void setup() {
  state = INTRO;

  controlP5 = new ControlP5(this);
  play = controlP5.addButton("Play", 0, width/2-60, height-200, 150, 50);
  replay = controlP5.addButton("Replay", 0, width/2-60, height-200, 150, 50);

  PFont pfont = createFont("Arial", 16, true);
  play.getCaptionLabel().setFont(pfont);             
  play.setColorForeground(color(230, 62, 0));         
  play.setColorBackground(color(150, 40, 0));        
  replay.getCaptionLabel().setFont(pfont);             
  replay.setColorForeground(color(230, 62, 0));         
  replay.setColorBackground(color(150, 40, 0));  

  controlP5.getController("Replay").hide();


  size(1366, 768);
  bg1 = new Background(loadImage("bg1.png"));
  bg2 = new Background(loadImage("bg2.png"));
  bg3 = new Background(loadImage("bg3.png"));
  blockImg = loadImage("blocks.png");
  bulletImg = loadImage("bullet.png");
  potionImg = loadImage("potion.png");
  heartImg = loadImage("heart.png");
  blueHeartImg = loadImage("blue-heart.png");

  minim = new Minim(this);
  shoot = minim.loadFile(FIRE);
  music = minim.loadFile(THEME);
  healing = minim.loadFile(HEAL);
  ghostSound = minim.loadFile(GHOST);
  breathe = minim.loadFile(BREATHE);
  running = minim.loadFile(RUNNING);
  dash = minim.loadFile(DASHING);
  explosive = minim.loadFile(EXPLOSIVE);
  roar = minim.loadFile(ROAR);


  music.loop();


  for (int i=0; i<numEnemies; i++) {
    enemies.add(new Enemy(new PVector(random(charWidth/2, width-charWidth/2), random(charWidth/2, height-charWidth/2)), new PVector(random(-5, 5), random(-5, 5))));
  }  
  player = new Player(startPos, new PVector());
  wife = new Wife(new PVector(random(charWidth/2, width-charWidth/2), random(charWidth/2, height-charWidth/2)), new PVector(random(-5, 5), random(-5, 5)));

  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      switch(map[i][j]) { 
      case TILE_SOLID: 
        blocks.add(new Block(new PVector(j*TILE_SIZE, i*TILE_SIZE), new PVector(TILE_SIZE, TILE_SIZE)));
        break;
      default: //when it's empty space
        ; //do nothing
      }
    }
  }
}

void draw() {
  switch(state) {
  case INTRO:
    showIntroScreen();
    break;
  case ROOM_ONE:
    gamePlay();
    break;
  case ROOM_TWO:
    gamePlay();
    break;
  case ROOM_THREE:
    gamePlay();
    break;
  case TRANSITION:
    transition();
    break;
  case WON:
    break;
  case LOST:
    showScreen("Score: "+ score);
    controlP5.getController("Replay").show();
    break;
  }
}

void gamePlay() {
  if (level == 1) {
    bg1.drawMe();
  } else if (level == 2) {
    bg2.drawMe();
  } else {
    bg3.drawMe();
  }

  enemyNumTimer--;
  if (enemyNumTimer<=0) {
    if (level == 3) {
      numEnemies++;
    }
    enemyNumTimer = 600;
  }

  if (enemies.size()<numEnemies/2 && level == 3) {
    enemies.add(new Enemy(new PVector(random(charWidth/2, width-charWidth/2), random(charWidth/2, height-charWidth/2)), new PVector(random(-5, 5), random(-5, 5))));
  }

  if (enemies.size() == 0) {
    if (state == ROOM_ONE || state == ROOM_TWO) {
      clearLevel();
      level++;
      state = TRANSITION;
    }
  }

  for (int i=0; i<enemies.size(); i++) {
    Enemy e=enemies.get(i);
    e.update();
  }



  player.update();
  player.drawCharacter();
  if (up) player.accelerate(upAcc);
  if (down) player.accelerate(downAcc);
  if (left) player.accelerate(leftAcc);
  if (right) player.accelerate(rightAcc);

  wife.update();
  wife.drawCharacter();

  for (int i=0; i<hpPickup.size(); i++) {
    HealthPU p = hpPickup.get(i);
    p.update();
    p.drawMe();
  }

  if (ghostAlive) {
    Ghost g = ghost.get(0);
    g.update();
    g.drawCharacter();
  }

  for (int i = 0; i < blocks.size(); i++) {
    Block b = blocks.get(i);
    b.update();
    b.drawMe();
  }

  player.drawHealthBar();
  wife.drawHealthBar();
  image(heartImg, 5, 5, 30, 30);
  image(blueHeartImg, 4, 40, 30, 30);
  drawScore();
}

void showScreen(String str) {
  bg1 = new Background(loadImage("bg1.png")); 
  bg1.drawMe(); 
  PFont font = loadFont("Arial-Black-48.vlw"); 
  fill(255, 166, 33);
  textFont(font, 60); 
  text(str, width/2-120, height/2);
  if (level==1 && state!=LOST) {
    text("Left Click to Shoot", width/2-320, height/2 + 100);
  } else if (level==2 && state!=LOST) {
    text("Right Click to Stunt", width/2-330, height/2 + 100);
  } else if (level==3 && state!=LOST) {
    text("Press Shift to Dash", width/2-320, height/2 + 100);
  }
}

void clearLevel() {
  while (enemies.size()>0) {
    enemies.remove(0);
  }
  for (int i=0; i<numEnemies; i++) {
    enemies.add(new Enemy(new PVector(random(charWidth/2, width-charWidth/2), random(charWidth/2, height-charWidth/2)), new PVector(random(-5, 5), random(-5, 5))));
  }
  player.isHaunted = false;
}

void transition() {
  if (transitionTimer>0) {
    transitionTimer--;
    showScreen("Level " + level);
  } else {
    state = level;
    transitionTimer = 90;
  }
}

void showIntroScreen() {
  bg1 = new Background(loadImage("bg1.png")); 
  bg1.drawMe();
  textSize(60);
  fill(255, 166, 33);
  text("Haunted", width/2 - 100, height/2-100);
  textSize(20);
  text("War, war never changes; But it changes people. At least, it changed me. ", 350, height/2-20);
  text("Ever since I came home, I am having these hallucinations...", 400, height/2+20);
  text("I see all the people I killed. They are haunting me and I'm haunting them again.", 300, height/2+60);
  text("I told Sarah about Sarah about them. She wants to help me but doesn't know how.", 280, height/2+100);
  text("I just want it to end. I don't know what is real anymore. I don't want her to get hurt", 270, height/2+140);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName() =="Play") { 
    state = TRANSITION;
    controlP5.getController("Play").hide();
  }
  if (theEvent.getController().getName() =="Replay") { 
    resetGame();
    state = ROOM_ONE;
    level = 1;
    controlP5.getController("Replay").hide();
  }
}

void resetGame() {
  player.health = player.MAX_HEALTH;
  player.isAlive = true;
  player.isHaunted = false;
  wife.health = wife.MAX_HEALTH;
  score = 0;

  enemies.removeAll(enemies);
  for (int i=0; i<numEnemies; i++) {
    enemies.add(new Enemy(new PVector(random(charWidth/2, width-charWidth/2), random(charWidth/2, height-charWidth/2)), new PVector(random(-5, 5), random(-5, 5))));
  }  

  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      switch(map[i][j]) { 
      case TILE_SOLID: 
        blocks.add(new Block(new PVector(j*TILE_SIZE, i*TILE_SIZE), new PVector(TILE_SIZE, TILE_SIZE)));
        break;
      default: //when it's empty space
        ; //do nothing
      }
    }
  }
}

void drawScore() {
  pushMatrix();
  translate(width-150, 30);
  fill(255);
  PFont font = loadFont("Arial-Black-48.vlw"); 
  fill(255, 166, 33);
  textFont(font, 30); 
  text("Kills: " + score, 0, 0);
  popMatrix();
}
