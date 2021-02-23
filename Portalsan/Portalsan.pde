import processing.sound.*;

Bullet b;
Player p;
PortalGun pg;
Maps m;
PImage player, portalGun, tutorialStage, stage1, error, portal1, portal2;
float spawnX, spawnY;
boolean flipPlayer = false;
int stage = 0;
int   portalTimer = 2000;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  millis();
  //ellipseMode(CENTER);  //temporary player model until actual player model is done.
  
  b = new Bullet();
  p = new Player();
  pg = new PortalGun();
  m = new Maps();
  player = loadImage("Steve.png");  //image is 30x30 pixels
  portalGun = loadImage("portal_gun.png");
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  error = loadImage("error.png");
  portal1 = loadImage("Portal green.png");
  portal2 = loadImage("Portal Magenta.png");
last_millis = millis();



}



void draw() {
  imageMode(CENTER);
  image(m.loadMap(stage), width/2, height/2);

  fill(0);


  p.verticleMovement();
  p.movePlayer();
  p.render();
  p.rotateGun();
  //pg.portalSpawn();
  pg.render(portalX1, portalY1);
  pg.render2(portalX2,portalY2);
  //println("mouseX: " + mouseX + "   mouseY: " + mouseY);  //test-kode til at finde koordinater (cirka-mål)
}

void mousePressed(){
  if (mouseButton == LEFT) {
pg.portalSpawn1();
  }
   if (mouseButton == RIGHT){
   pg.portalSpawn2();
   }
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
