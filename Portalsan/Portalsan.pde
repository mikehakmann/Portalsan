Player p;
Maps m;
PImage player, tutorialStage, stage1, error;
float spawnX, spawnY;
int stage = 0;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  //ellipseMode(CENTER);  //temporary player model until actual player model is done.
  
  p = new Player();
  m = new Maps();
  player = loadImage("Steve.png");  //image is 30x30 pixels
  tutorialStage = loadImage("tutorial.png");
  stage1 = loadImage("stage_1.png");
  error = loadImage("error.png");
}



void draw() {
  imageMode(CENTER);
  //background(155, 173, 183);
  //checkStage();
  image(m.loadMap(stage), width/2, height/2);
  
  fill(0);
  
  p.verticleMovement();
  p.movePlayer();
  p.render();
  
  println("mouseX: " + mouseX + "   mouseY: " + mouseY);  //test-kode til at finde koordinater (cirka-mål)
  //noLoop();
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
