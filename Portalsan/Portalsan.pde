Player p = new Player();


void setup() {
  size(802, 602);
  background(155, 173, 183);
  frameRate(60);
  
  
  
}



void draw() {
  
  background(155, 173, 183);
  
  
  
}


void keyPressed() {
  p.playerSetMove(keyCode, true);
}

void keyReleased() {
  p.playerSetMove(keyCode, false);
}
