Player p;
PImage player, tutorialStage, stage1;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  //ellipseMode(CENTER);  //temporary player model until actual player model is done.
  
  p = new Player();
  player = loadImage("Steve.png");
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  
}



void draw() {
  //background(155, 173, 183);
  image(tutorialStage, 0, 0);
  fill(0);
  
  p.verticleMovement();
  p.movePlayer();
  p.render();
  
  
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
