class Player {
  PVector pos;
  PVector vel;
  PVector playerAim;
  boolean isUp, isDown, isLeft, isRight = false;

  Player() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(5, 5);
    playerAim = new PVector(mouseX, mouseY);
    
  }
  
  
  void render() {
    ellipse(pos.x, pos.y, 50, 50);
  }
  

  void movePlayer() {
    pos.x = constrain(pos.x + vel.x * (int(isRight) - int(isLeft)), 1, width  - 1);
    pos.y = constrain(pos.y + vel.x * (int(isDown)  - int(isUp)), 1, height - 1);
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case +'A':                // Player can only move sideways and jump (which isn't very usefull most of the time)
    case LEFT:                // "
      return isLeft = b;      // "
                              // "
    case +'D':                // "
    case RIGHT:               // "
      return isRight = b;     // "
                              // "
    default:                  // "
      return b;               // "
    }
  }
}
