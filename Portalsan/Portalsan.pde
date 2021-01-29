Player p;
Maps m;
PImage player, tutorialStage, stage1, error;
int stage = 0;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  //ellipseMode(CENTER);  //temporary player model until actual player model is done.
  
  p = new Player();
  m = new Maps();
  player = loadImage("Steve.png");
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  error = loadImage("error.png");
}



void draw() {
  //background(155, 173, 183);
  //checkStage();
  image(m.loadMap(stage), 0, 0);
  
  
  fill(0);
  
  p.verticleMovement();
  p.movePlayer();
  p.render();
  
  println("X: " + mouseX + "   Y: " + mouseY);  //test-kode til at finde koordinater (cirka-mål)
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
