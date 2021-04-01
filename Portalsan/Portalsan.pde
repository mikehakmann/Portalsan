import processing.sound.*; //for sound, if we decide to implement some
import gifAnimation.*; //for the portal gifs

Bullet b;
Player p;
PortalGun pg;
Maps m;
PImage player, portalGun;
PImage tutorialStage, stage1, stage2, stage3, stage4, error; //all the different stages
PImage button, poweredButton, lever, secretArea; //different stage utilities
PImage button1, button2, lever1, lever2, lever3; //effects of stage utilities
Gif portal1, portal2, lava; //the portals are gifs - "portal1" is green and "portal2" is magenta


void setup() {
  size(802, 602);
  frameRate(60);
  cursor(CROSS);
  millis();

  b = new Bullet();
  m = new Maps(); //this also initializes the different images
  pg = new PortalGun();
  p = new Player();

  lava = new Gif(this, "stage_3_Lava.gif");     //"
  portal1 = new Gif(this, "PortalGreen.gif");   //initializes the gifs
  portal2 = new Gif(this, "PortalMagenta.gif"); //"
  lava.loop();    //"
  portal1.loop(); //makes the gifs loop
  portal2.loop(); //"

  pg.shootPortal_CD = millis(); //"
  pg.tpToPortal1_CD = millis(); //initializing the different cooldowns
  pg.tpToPortal2_CD = millis(); //"

  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(14);

  p.getPlayerColors();
}



void draw() {
  m.mapProperties(); //to change the stage, if player is within certain bounds and loads stage specific utilities
  image(m.loadMap(m.stage), width/2, height/2); //draws the map, based on 'stage'
  m.loadMapImages(); //loads map-specific things like levers, lever effects, lava, and so on

  //if a bullet is fired, checks and performs collision and updates bullet
  if (b.firedBullet) { //called before everything else, since bullets rely heavily on background colors
    b.collision();
    b.bulletUpdate();
  }
  
  p.verticleMovement(); //really just player's collision when falling & jumping
  p.movePlayer(); //first let player move (sideways),
  p.render();     //then render player
  p.rotateGun(); //gun is drawn *after* checking color around player for collision so it doesn't interfere

  //if (!(millis() - pg.shootPortal_CD > 1500)) {//if the cooldown time for shooting a portal hasn't passed:
  //  pushMatrix();
  //  noFill();
  //  arc(mouseX, mouseY, 25, 25, -HALF_PI, (((millis() - pg.shootPortal_CD)/1500) * TWO_PI) - HALF_PI);
  //  popMatrix();
  //}
  pg.renderPortal1(pg.portal1_X, pg.portal1_Y); //renders portals
  pg.renderPortal2(pg.portal2_X, pg.portal2_Y); //"
  if (pg.renderPortal1 && pg.renderPortal2) { //if both portals are placed, then allows for teleporting between them
    pg.portalTP1(); //func for teleporting *from* portal 1
    pg.portalTP2(); //func for teleporting *from* portal 2
  }

  if (m.coverUp) {
    pushMatrix();
    translate(width/2, height/2);
    image(secretArea, 0, 0);
    popMatrix();
  }

  //println("mouseX: " + mouseX + "  mouseY: " + mouseY);
  //println("Color at mouse: " + get(int(mouseX), int(mouseY)));
}



void mousePressed() {
  if (millis() - pg.shootPortal_CD > 1500) { //if the cooldown time for shooting a portal has passed:
    if (mouseButton == LEFT) {
      b.firedLeft = true; //left clicked, meaning left portal should be fired
      b.bulletColor = #328b39;
      pg.firePortal(1); //fire the correct portal
    }//comment to stop "else" from appearing on this line
    else if (mouseButton == RIGHT) {
      b.firedLeft = false; //right portal was fired, which *isn't* the left one
      b.bulletColor = #9205b6;
      pg.firePortal(2);
    }
  }
  if (keyCode == ENTER) {
    loop();
  }
}

void keyPressed() {
  p.playerSetMove(keyCode, true);

  if (keyCode == ' ') { //Note: player can only jump while on the ground
    p.jump = true;
  }
  if (keyCode == 'E') { //activates nearby levers while held down
    m.activate = true;
  }
  if (keyCode == SHIFT) { //holding shift halts/disables teleporting between portals
    pg.haltTP = true;
  }
  if (keyCode == 'R') { //pressing 'R' resets portals
    pg.resetPortals(0);
  }
}

void keyReleased() {
  p.playerSetMove(keyCode, false);

  if (keyCode == ' ') {
    p.jump = false;
  }
  if (keyCode == 'E') {
    m.activate = false;
  }
  if (keyCode == SHIFT) {
    pg.haltTP = false;
  }
}
