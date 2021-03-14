import processing.sound.*; //for sound, if we decide to implement some
import gifAnimation.*; //for the portal gifs

Bullet b;
Player p;
PortalGun pg;
Maps m;
PImage player, portalGun, tutorialStage, stage1, error;
Gif portal1, portal2; //the portals are gifs - "portal1" is green and "portal2" is magenta


void setup() {
  size(802, 602);
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
  
  portal1 = new Gif(this, "PortalGreenGif.gif");   //initializes the portal gifs
  portal2 = new Gif(this, "PortalMagentaGif.gif"); //"
  portal1.loop(); //makes the portal gifs loop
  portal2.loop(); //"
  
  pg.shootPortal_CD = millis();
  pg.tpToPortal1_CD = millis();
  pg.tpToPortal2_CD = millis();

  imageMode(CENTER);
  ellipseMode(CENTER);
}



void draw() {
  m.checkMapChange(); //to change the stage, if player is within certain bounds
  image(m.loadMap(m.stage), width/2, height/2); //draws the map, based on 'stage'

  //if a bullet is fired, checks and performs collision and updates bullet
  if (b.firedBullet) { //called before everything else, since bullets rely heavily on background colors
    b.collision();
    b.bulletUpdate();
  }

  p.verticleMovement();
  p.movePlayer();
  p.render();
  p.rotateGun(); //notice gun is drawn *after* checking color around player for collision (that way it doesn't interfere)

  pg.renderPortal1(pg.portal1_X, pg.portal1_Y); //renders portals
  pg.renderPortal2(pg.portal2_X, pg.portal2_Y); //"
  if (pg.renderPortal1 && pg.renderPortal2) { //if both portals are placed, then allows for teleporting between them
    pg.portalTP1(); //func for teleporting *from* portal 1
    pg.portalTP2(); //func for teleporting *from* portal 2
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    b.firedLeft = true; //left clicked, so left portal should be fired
    b.firedRight = false; //right portal should *not* be fired
    pg.firePortal(1); //fire the correct portal
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
  if (keyCode == 'R') { //pressing 'R' resets portals
    pg.resetPortals(1);
    pg.resetPortals(2);
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
