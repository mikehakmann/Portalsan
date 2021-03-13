import processing.sound.*;

Bullet b;
Player p;
PortalGun pg;
Maps m;
PImage player, portalGun, tutorialStage, stage1, error, portal1, portal2;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  millis();

  b = new Bullet();
  m = new Maps();
  pg = new PortalGun();
  p = new Player();

  player = loadImage("Steve.png");  //image is 30x30 pixels
  portalGun = loadImage("portal_gun.png");
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  error = loadImage("error.png");
  portal1 = loadImage("Portal green.png");
  portal2 = loadImage("Portal Magenta.png");
  pg.shootPortal_CD = millis();
  pg.tpToPortal1_CD = millis();
  pg.tpToPortal2_CD = millis();

  imageMode(CENTER);
  ellipseMode(CENTER);
}



void draw() {
  m.checkMapChange();
  image(m.loadMap(m.stage), width/2, height/2);

  fill(0);

  p.verticleMovement();
  p.movePlayer();
  p.render();
  p.rotateGun();

  pg.render(pg.portal1_X, pg.portal1_Y);
  pg.render2(pg.portal2_X, pg.portal2_Y);
  pg.portalTP1();
  pg.portalTP2();

  if (b.firedBullet) {
    b.collision();
  }

  b.bulletUpdate();

  println("mouseX: " + mouseX + "   mouseY: " + mouseY);  //test-kode til at finde koordinater (cirka-mål)
  println("playerX: " + p.pos.x + "  playerY: " + p.pos.y);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    b.firedLeft = true;
    b.firedRight = false;
    pg.firePortal(1);
  }
  if (mouseButton == RIGHT) {
    b.firedRight = true;
    b.firedLeft = false;
    pg.firePortal(2);
  }
}

void keyPressed() {
  p.playerSetMove(keyCode, true);

  if (keyCode == ' ') {
    p.jump = true;
  }
  if (keyCode == SHIFT) {
    pg.haltTP = true;
  }
}

void keyReleased() {
  p.playerSetMove(keyCode, false);

  if (keyCode == ' ') {
    p.jump = false;
  }
  if (keyCode == SHIFT) {
    pg.haltTP = false;
  }
}
