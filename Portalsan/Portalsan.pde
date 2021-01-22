Player p = new Player();


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  
  ellipseMode(CENTER);
  
}



void draw() {
  
  background(155, 173, 183);
  
  p.movePlayer();
  p.render();
  
  
}


void keyPressed() {
  p.playerSetMove(keyCode, true);
}

void keyReleased() {
  p.playerSetMove(keyCode, false);
}
