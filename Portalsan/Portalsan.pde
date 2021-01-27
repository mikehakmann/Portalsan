Player p;


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  ellipseMode(CENTER);  //temporary player model until actual player model is done.
  
  p = new Player();
  
}



void draw() {
  background(155, 173, 183);
  fill(0);
  rect(0, height*0.70, width, height*0.25);
  
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
}
