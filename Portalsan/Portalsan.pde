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
  rect(0, height*0.90, width, height*0.10);
  
  p.movePlayer();
  p.render();
  
  
}


void keyPressed() {
  p.playerSetMove(keyCode, true);
}

void keyReleased() {
  p.playerSetMove(keyCode, false);
}
