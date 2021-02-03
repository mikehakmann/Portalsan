import processing.sound.*;

Player p;
PortalGun pg;
Maps m;
PImage player, portalGun, tutorialStage, stage1, error;
float spawnX, spawnY;
boolean flipPlayer = false;
int stage = 0;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  //ellipseMode(CENTER);  //temporary player model until actual player model is done.

  p = new Player();
  pg = new PortalGun();
  m = new Maps();
  player = loadImage("Steve.png");  //image is 30x30 pixels
  portalGun = loadImage("portal_gun.png");
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  error = loadImage("error.png");
}



void draw() {
  imageMode(CENTER);
  image(m.loadMap(stage), width/2, height/2);

  fill(0);
  
  

  p.verticleMovement();
  p.movePlayer();
  p.render();
  pg.rotateGun();

  println("mouseX: " + mouseX + "   mouseY: " + mouseY);  //test-kode til at finde koordinater (cirka-mål)
}


void keyPressed() {
  p.playerSetMove(keyCode, true);

  if (keyCode == ' ') {
    p.jump = true;
  }
}

void keyReleased() {
  p.playerSetMove(keyCode, false);

  if (keyCode == ' ') {
    p.jump = false;
  }
}
